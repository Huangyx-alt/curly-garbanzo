require "State/Common/CommonState"
local TournamentScoreView = BaseView:New('TournamentScoreView',"TournamentScoreAtlas");
local this = TournamentScoreView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.update_x_enabled = true

local TournamentArriveItem = require "View/Tournament/TournamentArriveItem"
local TournamentCurrentItem = require "View/Tournament/TournamentCurrentItem"
local TournamentNoArriveItem = require "View/Tournament/TournamentNoArriveItem"
local TournamentBlackGoldItem = require "View/Tournament/TournamentBlackGoldItem"
local TournamentTopTierInfoItem = require "View/Tournament/TournamentTopTierInfoItem"
local TournamentRankUpView = require "View/Tournament/TournamentRankUpView"
local TournamentArriveFullItem = require "View/Tournament/TournamentArriveFullItem"

local remainTimeCountDown = RemainTimeCountDown:New()

this.auto_bind_ui_items = {
	"btn_close",
	"item_list",
	"Content",
	"noArriveItem",
	"currentItem",
	"arriveItem",
	"currentBlackGoldItem",
	"settleRoot",
	"btn_continue",
	"btn_gift",
	"myTier",
	"text_countdown",
	"curTierInfoItem",
	"btn_open",
	"bg_1",
	"bg_2",
	"myScoreItem",
	"Handle",
	"arrow",
	"background",
	"btn_mask",
	"anima",
	"ef_jindu",
	"btn_gift_anim",
	"ef_buff",
	"ef_jindubuff",
	"Tournamentbuff",
	"btn_help",
	"backgroundbei",
	"topOneItemList",
	"topOneRewardItem",
	"myNewRewardItem",
	"myNewRewardList",
	"btn_continue_back",
	"tierTargetImg",
	"arriveFullItem",
	"buffIcon",
	"superMatchSmash",
	"smashIcon",
	"slotTicket",
    "ticketNum",
}

local tierItemType =
{
	Arrive = 1,
	Current = 2,
	NoArrive = 3,
}

--段位分层用于显示背景
local tierRange =
{
	[1] = {min = 1,max = 1},
	[2] = {min = 2,max = 4},
	[3] = {min = 5,max = 7},
	[4] = {min = 8,max = 10},
	[5] = {min = 11,max = 13},
	[6] = {min = 14,max = 14},
}

--段位item列表
local tierItemList = {}
--总段位
local totalTier = 0;
--当前段位
local tiers = 0;
--当前难度
local difficulty = 0;
--当前段位在ScrollView中的上边界
local topPercent = 0;
--myScoreItem在ScrollView中的下边界
local myBottomPercent = 0;
--myScoreItem在ScrollView中的上边界
local mytopPercen = 0;
--当顶部有段位奖励时，myScoreItem在ScrollView中的上边界
local mytopHasTierInfoPercen = 0;
--myScoreItem在ScrollView中的位于屏幕中间的位置
local middlePercent = 0;
--是否升段了
local isUpTier = false;
--是否为结算
local isSettle = false;
--结算之前的积分
local oldScore = nil;
--结算之前的段位
local lastWeekTier = nil;
--结算之前排名信息
local lastWeekRankInfo = nil;
--当前段位高度
local curTierHeight = 3840;
--未达到段位高度
local noArriveHeight = 1900;
--达到段位高度(参与领奖)
-- local arriveAndRewardPrepareHeight = 450;
local arriveAndRewardPrepareHeight = 1900;

--达到段位高度(不参与领奖)
local arriveAndRewardOverHeight = 450;

--段位进度条实际缩短的值（顶部和底部按策划需求要留空）
local sliderHeightOffset = 220
--当前播放动画的index
local animTier = 0;
--mask是否能点击
local maskCanClick = false;

local uiCamera = nil;
local showRangTop = nil;
local showRangDown = nil;
local TimeOutList  = {}

local items={}

local currentItemHeight = 0

CountObjectPool={}
HeadObjectPool={}

local itemList={}

function TournamentScoreView:Awake(obj)
    --this.update_x_enabled = true
    self:on_init()
end

--默认加载当前段位，所以把当前段位的存入table ， 取的时候table是默认有值的，相同引用,默认取第一个就行
function ObjectPop(itemType)
	if itemType==1 then
		return table.remove(CountObjectPool,1)
	elseif itemType==2 then
		return table.remove(HeadObjectPool,1)
	end
end
--不限最大数量，直接添加
function ObjectPush(itemType,item)
	if itemType==1 then
		table.insert(CountObjectPool,item)
	elseif itemType==2 then
		table.insert(HeadObjectPool,item)
	end
end
-- 关闭界面全部销毁
function TournamentScoreView:DestroyAll()
	
end

function TournamentScoreView:OnEnable(params)

	--Facade.SendNotification(NotifyName.HideUI,ViewList.HallCityView)
	--Facade.SendNotification(NotifyName.HideUI,ViewList.TopConsoleView)
	--Facade.SendNotification(NotifyName.HideUI,ViewList.HallCityBannerView)
	
	showRangTop = UnityEngine.Screen.height * 2;
	showRangDown = 0 - UnityEngine.Screen.height;

	--获取总共段位数量
	totalTier = ModelList.TournamentModel:GetTotalTournamentTrophy();
	tiers,difficulty = ModelList.TournamentModel:GetTiers();
	Facade.RegisterView(self)
	CommonState.BuildFsm(self,"TournamentScoreView")
	--界面入场动画
	self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
			--界面入场动画
			AnimatorPlayHelper.Play(self.anima,{"TournamentScoreViewenter"},false,function()
					self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
				end)
		end)

	UISound.play("weekly_round_open")

	--是否是结算调用
	isSettle = false;
	if params then
		--界面关闭回调
		self._exit_callback = params.callBack;
		isUpTier = params.isUpTier;
		isSettle = params.isSettle;
		oldScore = params.oldScore;
		lastWeekTier = params.lastWeekTier;
		if not params.lastWeekRankInfo then
			lastWeekRankInfo = ModelList.TournamentModel:GetMyRankInfo();
		else
			lastWeekRankInfo = params.lastWeekRankInfo;
		end
	end
	self:GetUiCamera();
	--isUpTier = true
	--lastWeekTier = tiers - 2;

	--显示界面
	self:SetBg();
    self:CheckSmash(isSettle)
	self:CheckSoltSpin(isSettle)
	fun.set_active(self.settleRoot,isSettle);
	self:SetPanel();

	if ModelList.TournamentModel:HasSprintBuff() then
		fun.set_active(self.buffIcon, true)
	else
		fun.set_active(self.buffIcon, false)
	end

end

function TournamentScoreView:GetUiCamera()
	local cameraGo = nil;
	if isSettle then
		cameraGo = fun.GameObject_find("Canvas/CameraUI")
	else
		cameraGo = fun.GameObject_find("Canvas/Camera")
	end
	if cameraGo then
		uiCamera = fun.get_component(cameraGo, "Camera")
	end
end

--function TournamentScoreView:on_x_update()
--end

--设置进度特效
function TournamentScoreView:SetEffectVisible(visible)
	if visible then
		if self:HasSprintBuff() then
			fun.set_active(self.ef_buff,true);
			fun.set_active(self.ef_jindubuff,true);
			-- fun.set_active(self.Tournamentbuff,true);
		end
	else
		fun.set_active(self.ef_buff,false);
		fun.set_active(self.ef_jindubuff,false);
	end
end

--根据段位获取背景索引
function TournamentScoreView:GetBgIndex(tiers)
	for i, v in ipairs(tierRange) do
		if tiers >= v.min and tiers <= v.max then
			return i;
		end
	end
end

--设置背景
function TournamentScoreView:SetBg()
	if isSettle then
		self.background.color = Color.New(5 / 255, 5 / 255, 5 / 255, 100 / 255);
	else
		if lastWeekTier == nil then
			self.background.color = Color.New(5 / 255, 5 / 255, 5 / 255, 1);
		else
			self.background.color = Color.New(5 / 255, 5 / 255, 5 / 255, 100 / 255);
		end
	end
end

function TournamentScoreView:OnDisable()
	
	Event.Brocast(EventName.Event_show_tournament_score_view)
	Facade.RemoveView(self)
	CommonState.DisposeFsm(self)
	remainTimeCountDown:StopCountDown()
	self._exit_callback = nil
	self.tierInfoView = nil;
	isUpTier = false;
	isSettle = false;
	oldScore = nil;
	lastWeekTier = nil;
	self.arrowStatus = nil;
	self.isPlayScoreChangeSound = nil;
	this.showAnim = nil;
	animTier = 0;
	maskCanClick = false;
	TournamentRankUpView:OnDisable();
	CountObjectPool={}
	HeadObjectPool={}
end

--退出
function TournamentScoreView:PlayExite()
	if self.closeTime and os.time() - self.closeTime < 1 then
		return
	end
	self.closeTime = os.time()
	self:ClearTimeList()
	if self._exit_callback then
		self._exit_callback()
	end
	Facade.SendNotification(NotifyName.CloseUI,this)
end

function TournamentScoreView:ClearTimeList()
	for i, v in pairs(TimeOutList) do
		LuaTimer:Remove(v)
	end
	TimeOutList = {}
end

--初始化的时候，计算在屏幕中的段位ID
function TournamentScoreView:GetVisableTierIndex(currTier,maxTier)
	if currTier==1 then
		return {1,2}
	elseif currTier==maxTier then
		return {currTier-1,currTier}
	else
		if isSettle then
			for i =lastWeekTier ,currTier do
				if lastWeekTier == currTier then
					return {currTier-1,currTier,currTier+1}
				else
					return {i}
				end
			end
		else
			if lastWeekTier == nil then
				if currTier > 2   then
					return {currTier-2,currTier-1,currTier,currTier+1}
				else
					return {currTier-1,currTier,currTier+1}
				end
				
			else
				for i = lastWeekTier ,currTier do
					    return {i}
				end
			end
			
		end

	end
end


function TournamentScoreView:SetPanel()
	--初始化列表
	local showingTierIndex=self:GetVisableTierIndex(tiers,totalTier)
	log.log("dghdgh00077 TournamentScoreView:SetPanel the tiers is ", tiers, oldScore, isUpTier)
	--coroutine.start(function()
		for i = totalTier, 1,-1 do
			local tierType = tierItemType.Arrive;
			local isNowShowState=fun.is_include(i,showingTierIndex)
			if i < tiers  then
	
				if isUpTier  then
					local curScore = ModelList.TournamentModel:GetMayRankScore();
					local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(i);
					if (oldScore and oldScore < scoreRange[2] and oldScore >= scoreRange[1]) or (oldScore and oldScore < scoreRange[2] and oldScore < scoreRange[1])  then
						--真正开头的格子
						self:LoadTierItems(self.arriveFullItem,TournamentArriveFullItem,i,tierItemType.Arrive,isNowShowState,true);
					else
						--已经结束的格子 本次流程不领奖
						self:LoadTierItems(self.arriveItem,TournamentArriveItem,i,tierItemType.Arrive,isNowShowState,true);
					end
				else
					self:LoadTierItems(self.arriveItem,TournamentArriveItem,i,tierItemType.Arrive,isNowShowState,true);
				end
			elseif i == tiers then
				self:LoadTierItems(self.currentItem,TournamentCurrentItem,i,tierItemType.Current,isNowShowState,true);
				--WaitForEndOfFrame()
			else
				self:LoadTierItems(self.noArriveItem,TournamentNoArriveItem,i,tierItemType.NoArrive,isNowShowState,true);
				
			end
			
		end
		--- 调整到这个位置,否则SetGiftBox执行时间检查，时间过期了直接执行PlayExite,此时TimeOutList还没有添加两个计时器，导致报错
		local tmpLuaTimer1 = LuaTimer:SetDelayFunction(0.2,function()
			self:CalculateScrollPercent();

			if oldScore then
				--需要开始爬进度，定位在初始位置
				self:SetScrollStratPos();
			else
				self:ScrollToCurrent();
			end


			local tmpLuaTimer2 =LuaTimer:SetDelayFunction(0.1,function()
				log.log("周榜流程问题检查 dx")
				self:SetItemListVisible();
			end,nil,LuaTimer.TimerType.UI);
			table.insert(TimeOutList , tmpLuaTimer2)
		end,nil,LuaTimer.TimerType.UI);
		table.insert(TimeOutList , tmpLuaTimer1)
	
		self:SetTierItems();
		self:SetGiftBox();
		self:SetMyRankTierAward();
		self:AddListenerScrollChaged();
	
		if ModelList.TournamentModel:CheckHasStateAward() then
			ModelList.TournamentModel:C2S_RequestStageReward();
		end
	
		--在需要播放动画的时候先打开遮罩
		if oldScore then
			self:SetMaskVisible(true);
			self:SetEffectVisible(true);
		end
	--end)
	

	-- local itemCount=fun.get_child_count(self.Content)
	-- for i = 0, itemCount-1 do
	-- 	items[i+1]=fun.get_child(self.Content,i)
	-- end
end

function TournamentScoreView:SetMaskVisible(visible)
	---暂时屏蔽周榜遮罩
	log.log("dghdgh0007 TournamentScoreView:SetMaskVisible, ", visible)
	fun.set_active(self.btn_mask,visible);
end

--加载段位item
function TournamentScoreView:LoadTierItems(prefab,view,index,tierType,isNowShowState,isInit)
	if tierItemList[index] == nil then
		tierItemList[index] = {}
	end
	local go = nil;
	if tierType == tierItemType.Current then
		go = prefab;
		fun.set_parent(go,self.Content.gameObject);
	else
		go = fun.get_instance(prefab, self.Content.gameObject);
	end
	if go then
		
		local view = view:New(isNowShowState,isInit);
		--go.gameObject.name = tostring(index)
		view:SetParent(this)
		view:SkipLoadShow(go.gameObject,true,nil,isSettle);
		tierItemList[index] = view;
	
		itemList[index] = fun.get_component(go.gameObject,fun.CANVAS_GROUP)
	end
end

function TournamentScoreView:GetUIVisable(cam,ui)
	local pos = cam:WorldToScreenPoint(ui.transform.position);
	if (pos.y < showRangDown or pos.y > showRangTop) then
		return false;
	end
	return true
end

--设置段位item
function TournamentScoreView:SetTierItems()
	log.log("周榜流程问题检查 设置数据 SetTierItems tiers" , tiers)
	-- log.log("周榜流程问题检查 设置数据 SetTierItems tierItemList" ,  #tierItemList)
	log.log("周榜流程问题检查 设置数据 SetTierItems isSettle" , isSettle)
	log.log("周榜流程问题检查 设置数据 SetTierItems lastWeekTier" , lastWeekTier)
	

	if tiers==#tierItemList then
		log.log("周榜流程问题检查 设置数据 SetTierItems 正常这个流程会卡死了")
	end

	if tiers==1 then	
		self:IsCurrentItem(tiers,tierItemList[tiers],true)
		self:IsCurrentItem(tiers+1,tierItemList[tiers+1],true)
	elseif tiers==#tierItemList and lastWeekTier == tiers - 1 then
		self:IsCurrentItem(tiers-1,tierItemList[tiers-1],true)
		self:IsCurrentItem(tiers,tierItemList[tiers],true)
	else
		if isSettle then
			for i = lastWeekTier , tiers do
				if lastWeekTier == tiers then
					self:IsCurrentItem(tiers-1,tierItemList[tiers-1],true)
					self:IsCurrentItem(tiers,tierItemList[tiers],true)
					self:IsCurrentItem(tiers+1,tierItemList[tiers+1],true)
					break
				else
					self:IsCurrentItem(i,tierItemList[i],true)
				end
			end
		else
			if lastWeekTier == nil then
				if tiers > 2  then
					self:IsCurrentItem(tiers-2,tierItemList[tiers-2],true)
					self:IsCurrentItem(tiers-1,tierItemList[tiers-1],true)
					self:IsCurrentItem(tiers,tierItemList[tiers],true)
					self:IsCurrentItem(tiers+1,tierItemList[tiers+1],true)
				else
					self:IsCurrentItem(tiers-1,tierItemList[tiers-1],true)
					self:IsCurrentItem(tiers,tierItemList[tiers],true)
					self:IsCurrentItem(tiers+1,tierItemList[tiers+1],true)
				end
				
			else
				for i = lastWeekTier , tiers do
					self:IsCurrentItem(i,tierItemList[i],true)
				end
			end
			
		end
	end
end

function TournamentScoreView:IsCurrentItem(index, v, isInit)
	log.log("周榜流程问题检查 设置数据 IsCurrentItem index" , index)
	log.log("周榜流程问题检查 设置数据 IsCurrentItem isInit" , isInit)

	if #tierItemList < index then
		log.log("周榜流程问题检查 设置数据 IsCurrentItem 需要屏蔽 超出界限 index" , #tierItemList , index)
		return
	end
	local data = ModelList.TournamentModel:GetStageInfo(index);

	log.log("周榜流程问题检查 设置数据 IsCurrentItem data" , data)
	local bgIndex = self:GetBgIndex(data.tier);
	if isInit then
		v:SetItem(data,bgIndex,oldScore,isUpTier,index,tiers)
	else
		v:SetItem(data,bgIndex,nil,nil,index,tiers)
	end
end

function TournamentScoreView:SetItemListVisible()
	local canvas_group = fun.get_component(self.item_list,fun.CANVAS_GROUP);
	if canvas_group then
		canvas_group.alpha = 1
	end
	fun.set_active(self.background,true);
end

--计算scroll滚动的百分比
function TournamentScoreView:CalculateScrollPercent()
	local totalHight1 = 320;
	for i = totalTier, 1,-1 do
		if i > tiers then
			totalHight1 = totalHight1 + noArriveHeight;
		end
	end
	--- 有个报错  LuaException: event:171: View/Tournament/TournamentScoreView:390: attempt to index a nil value
	if fun.is_null(self.item_list) or fun.is_null(self.item_list.content) or fun.is_null(self.item_list.viewport) then
		log.log("周榜流程问题检查 错误 这里会有个报错 " )
		return;
	end
	local contentHeight = fun.get_component(self.item_list.content,fun.RECT).rect.height;
	local viewportHeight = fun.get_component(self.item_list.viewport,fun.RECT).rect.height;
	local diff = contentHeight - viewportHeight;
	topPercent = Mathf.Clamp(1 - totalHight1 / diff,0,1);

	--计算自己的位置
	local totalHight2 = totalHight1;
	local myInfo = ModelList.TournamentModel:GetMyRankInfo();
	if not myInfo then
		log.log("周榜流程问题检查 错误 这里会有个报错 myInfo" ,myInfo)
		return
	end

	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(tiers);
	local ratio = (myInfo.score - scoreRange[1]) / (scoreRange[2] - scoreRange[1]);
	ratio = Mathf.Clamp(ratio,0,1);
	ratio = ((curTierHeight - sliderHeightOffset * 2) * ratio + sliderHeightOffset) / curTierHeight;
	ratio = Mathf.Clamp(ratio,0,1);
	local diff1 = curTierHeight * (1 - ratio);
	if diff1 < 0 then
		diff1 = 0;
	end
	totalHight2 = totalHight2 + diff1;
	middlePercent = Mathf.Clamp(1 - (totalHight2 - viewportHeight / 2) / diff,0,1);

	local diff2 = curTierHeight * ratio;
	--自己顶部
	myBottomPercent = Mathf.Clamp(1 - (totalHight1 + curTierHeight - diff2 - viewportHeight) / diff,0,1);
	mytopPercen = Mathf.Clamp(1 - (totalHight1 + curTierHeight - diff2) / diff,0,1);
	mytopHasTierInfoPercen = Mathf.Clamp(1 - (totalHight1 + curTierHeight - diff2 - 384) / diff,0,1);
	----计算底部位置
	--local totalHight3 = totalHight1;
	--local diff2 = 1920 * 2;
	--totalHight3 = totalHight3 + diff2;
	--bottomPercent = Mathf.Clamp(1 - totalHight3 / diff,0,1);
end

--定位在开始的位置
function TournamentScoreView:SetScrollStratPos()
	local totalHight1 = 320;
	for i = totalTier, 1,-1 do
		if i > tiers then
			totalHight1 = totalHight1 + 1900;
		elseif i == tiers and isUpTier then
			totalHight1 = totalHight1 + 1920 * 2;
		elseif i > lastWeekTier and isUpTier then
			local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(i);
			if oldScore and oldScore < scoreRange[2] and oldScore >= scoreRange[1]  then
				totalHight1 = totalHight1 + arriveAndRewardPrepareHeight;
			else
				totalHight1 = totalHight1 + arriveAndRewardOverHeight;
			end
		end
	end

	local itemHeight = curTierHeight;
	if isUpTier then
		itemHeight = arriveAndRewardPrepareHeight
	end

	local contentHeight = fun.get_component(self.item_list.content,fun.RECT).rect.height;
	local viewportHeight = fun.get_component(self.item_list.viewport,fun.RECT).rect.height;
	local diff = contentHeight - viewportHeight;

	local totalHight2 = totalHight1;
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(lastWeekTier);
	local ratio = (oldScore - scoreRange[1]) / (scoreRange[2] - scoreRange[1]);
	ratio = Mathf.Clamp(ratio,0,1);
	if not isUpTier then
		ratio = ((curTierHeight - sliderHeightOffset * 2) * ratio + sliderHeightOffset) / curTierHeight;
		ratio = Mathf.Clamp(ratio,0,1);
	end


	local diff1 = itemHeight * (1 - ratio);
	if diff1 < 0 then
		diff1 = 0;
	end
	totalHight2 = totalHight2 + diff1;

	local percent = Mathf.Clamp(1 - (totalHight2 - viewportHeight / 2) / diff,0,1);
	self.item_list.verticalNormalizedPosition = percent;
	self:SetBottomArrow(3);
end

--滑动至当前段位
function TournamentScoreView:ScrollToCurrent()
	self.item_list.verticalNormalizedPosition =  middlePercent;
	if middlePercent == 1 then
		self:UpdateByScroll(1);
	end
end
local refCount=0
function TournamentScoreView:UpdateByScroll(value)
	if not isUpTier then
		self.myScoreItem.transform.position = self.Handle.transform.position;
	end
	refCount = refCount + 1
	if not isUpTier then
		for i, v in ipairs(tierItemList) do
			local root = v:GetRoot();
			if not self:GetUIVisable(uiCamera,root)  then
				v.isChangeShowState=false
				v.isInitState=false
				v:ShowChangePush()
				v.isNowShowState = false
				itemList[i].alpha=0
			else
				if refCount >= 2 then
					v.isChangeShowState=true
					if  v.isNowShowState==false then
							v.isNowShowState=true
								if i == tiers then
									self:IsCurrentItem(i,v)
								else
									self:IsCurrentItem(i,v,true)
								end
							refCount = 0
						end
					itemList[i].alpha=1
				end
			end
		end
	end
	
	if tierItemList[tiers] then
		if value <= 0 then
			value = 0;
		end
		if value <= topPercent then
			self.tierInfoView:OnShow();

			if value < mytopHasTierInfoPercen then
				self:SetBottomArrow(2);
			elseif value > myBottomPercent then
				self:SetBottomArrow(1);
			else
				self:SetBottomArrow(3)
			end
		else
			self.tierInfoView:OnHide();

			if value < mytopPercen then
				self:SetBottomArrow(2);
			elseif value > myBottomPercent then
				self:SetBottomArrow(1);
			else
				self:SetBottomArrow(3);
			end
		end
	end
end


--监听滑动事件
function TournamentScoreView:AddListenerScrollChaged()
	self.luabehaviour:AddScrollRectChange(self.item_list.gameObject,function(value)
				self:UpdateByScroll(value.y);
		end)
end

--设置底部箭头
--@params type 1:向下 2：向上 3.不显示
function TournamentScoreView:SetBottomArrow(type)
	if self.arrowStatus == nil then
		self.arrowStatus = -1;
	end
	if self.arrowStatus ~= type then
		self.arrowStatus = type
		if self.arrowStatus == 1 then
			self.arrow.sprite = AtlasManager:GetSpriteByName("TournamentScoreAtlas","ZBJfTxFhjt02");
		elseif self.arrowStatus == 2 then
			self.arrow.sprite = AtlasManager:GetSpriteByName("TournamentScoreAtlas","ZBJfTxFhjt01");
		end
		fun.set_active(self.btn_open,self.arrowStatus ~= 3);
	end
end

--设置当前段位奖励
function TournamentScoreView:SetMyRankTierAward()
	local data = ModelList.TournamentModel:GetStageInfo(tiers);
	self.tierInfoView = TournamentTopTierInfoItem:New();
	self.tierInfoView:SkipLoadShow(self.curTierInfoItem,true);
	local bgIndex = self:GetBgIndex(tiers)
	self.tierInfoView:SetData(data,bgIndex);
end

function TournamentScoreView:PlayMyTierItemAnim(animName)
	local anim = fun.get_component(self.curTierInfoItem,fun.ANIMATOR);
	if anim then
		anim:Play(animName);
	end
end

--设置底部礼物盒子
function TournamentScoreView:SetGiftBox()
	local rank = ModelList.TournamentModel:GetRankMySectionIndex();
	self.myTier.text = "Rank" ..  rank;
	remainTimeCountDown:StartCountDown(CountDownType.cdt2,
		ModelList.TournamentModel:GetRemainTime(),
		self.text_countdown)
end

function TournamentScoreView:on_btn_close_click()
	self:PlayExite();
end

function TournamentScoreView:on_btn_help_click()
	local viewName = ""
	if ModelList.TournamentModel:CheckIsBlackGoldUser() then
		viewName = "TournamentBlackGoldView"
	else
		viewName = "TournamentView"
	end
	Facade.SendNotification(NotifyName.ShowUI, ViewList[viewName])
end

function TournamentScoreView:on_btn_gift_click()
	local rankInfo = ModelList.TournamentModel:GetMyRankInfo();
	local myUid = ModelList.PlayerInfoModel:GetUid();
	local rewards = rankInfo.reward;
	local offset = Vector3.New(-50, 300 , 0)
	self:OpenTopPlayerRewardTip(rewards , offset,RewardShowTipOrientation.leftDown , Vector2.New(0,1))
end

function TournamentScoreView:OpenTopPlayerRewardTip(rewards,offset , dir, pivot)
	if not rewards then
		return
	end
	local pos = self.btn_gift.transform.position
	local rewardsNum = #rewards
	local params = {
		pivot = pivot,
		rewards = rewards,
		bg_width = self:GetShowTipWidth(#rewards),
		pos = pos,
		dir = dir,
		offset = offset,
	}
	Facade.SendNotification(NotifyName.ShowUI,ViewList.RewardShowTipView,nil,false,params)
end

--礼盒按钮点后弹出奖励面板的宽度
function TournamentScoreView:GetShowTipWidth(rewardsNum)
	return (rewardsNum - 1) * 150 + 320
end

function TournamentScoreView:on_btn_continue_click()
	self:PlayExite();
end

--箭头点击
function TournamentScoreView:on_btn_open_click()
	self:ScrollToCurrent();
end

--领取阶段奖励回调
function TournamentScoreView.OnTournamentStageReward(data,stateAwardInfo)
	this.showAnim = true;
end

function TournamentScoreView:PlayScoreChangeSound()
	if not self.isPlayScoreChangeSound then
		self.isPlayScoreChangeSoun = true;
		UISound.play_loop("weeklyincrease")
	end
end


--播放当前段位动画
function TournamentScoreView:PlayCurrentTierAnim(tiersIndex)
	local rankInfo = ModelList.TournamentModel:GetMyRankInfo()
	if not rankInfo then return end
	local startAward = ModelList.TournamentModel:GetRankLastAward(tiersIndex, difficulty)
	local topAward = ModelList.TournamentModel:GetFirstAward(tiersIndex, difficulty)
	
	log.log("周榜奖励收集流程 重用X tiersIndex " , tiersIndex , tiers )
	if tiersIndex < tiers then
		self:SetTrophyName(tiersIndex); --需求变更，直接显示成2->3 直接显示3
		animTier = tiersIndex;
		self:FastShowReward()
	else
		if tiersIndex == tiers then
			startAward = rankInfo.reward
		end
		if self.tierInfoView then
			self.tierInfoView:PlayAnim("changeenter");
			self:SetTrophyName(tiersIndex); --需求变更，直接显示成2->3 直接显示3
			local tmpLuaTimer2 = LuaTimer:SetDelayFunction(4,function()
					maskCanClick = true;
				end,nil,LuaTimer.TimerType.UI)
			table.insert(TimeOutList , tmpLuaTimer2)
		end
		animTier = tiersIndex;
		TournamentRankUpView:OnEnable({
				startAward = startAward,topAward = topAward,tier = tiersIndex,
				topOneRewardItem = self.topOneRewardItem,topOneItemList = self.topOneItemList,
				myNewRewardItem = self.myNewRewardItem,myNewRewardList = self.myNewRewardList})
	end

	
end

function TournamentScoreView:SetTrophyName(tier)
	local trophyName = fun.GetCurrTournamentActivityImg(tiers)
	Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
			if sprite then
				self.tierTargetImg.sprite = sprite
			end
		end)
end

function TournamentScoreView:HasSprintBuff()
	local mayRankInfo = ModelList.TournamentModel:GetMyRankInfo();
	if not mayRankInfo or not mayRankInfo.buffs then
		return false
	end

	local sprintBuffIds = ModelList.TournamentModel:GetSprintBuffIds()
	for key, buffId in ipairs(sprintBuffIds) do
		for idx , buff in ipairs(mayRankInfo.buffs) do
			if buff.id == buffId then
				return true
			end
		end
	end

	return false
end


function TournamentScoreView:FastShowReward()
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(animTier);
	if tiers == animTier then
		isUpTier = false;
	end
	tierItemList[animTier]:SetMyInfo(scoreRange[1],false,0);
	local tmpLuaTimer2 = LuaTimer:SetDelayFunction(1,function()
			self:SetTrophyName(tiers);
		end,nil,LuaTimer.TimerType.UI)
	table.insert(TimeOutList , tmpLuaTimer2)
	animTier = 0;
end

function TournamentScoreView:on_btn_mask_click()
	if not maskCanClick then
		return
	end

	maskCanClick = false;

	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(animTier);
	if tiers == animTier then
		isUpTier = false;
	end
	tierItemList[animTier]:SetMyInfo(scoreRange[1],false,0);
	if self.tierInfoView then
		self.tierInfoView:PlayAnim("changeexit");
		local tmpLuaTimer2 = LuaTimer:SetDelayFunction(1,function()
				self:SetTrophyName(tiers);
			end,nil,LuaTimer.TimerType.UI)
		table.insert(TimeOutList , tmpLuaTimer2)
	end
	TournamentRankUpView:OnDestroy();
	animTier = 0;
end

--------------------------------------region 锤力器------------------

--- 检查是否有锤力器道具

--- 结算数据检查有没有锤力器道具
function TournamentScoreView:CheckSmash(isSettle)
    if isSettle then
        local index = ModelList.SuperMatchModel:IsSmashRewardInSettleReward()
        if index > 0 then
            this.smashIcon.sprite = AtlasManager:GetSpriteByName("GameItemAtlas", "ClqJs0" .. index)
            fun.set_active(this.superMatchSmash, true)
        end
    end
end

function TournamentScoreView:CheckSoltSpin(isSettle)
    fun.set_active(self.slotTicket, false)
    if isSettle then
		if not ModelList.PiggySloltsGameModel.CheckPiggySlotsGameExist() then
            return
        end

        local num = ModelList.PiggySloltsGameModel.GetBreakNum()
        if num and num > 0 then
            fun.set_active(self.slotTicket, true)
            self.ticketNum.text = "x" .. tostring(num)
        end
    end
end

--------------------------------------endregion---------------------


this.NotifyList = {
	{notifyName = NotifyName.Tournament.ReqStageReward,func = this.OnTournamentStageReward},
}

return this


