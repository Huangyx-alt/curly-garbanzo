local TournamentArriveItem = BaseView:New("TournamentArriveItem")
local this = TournamentArriveItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local TournamentTierInfoItem = require "View/Tournament/TournamentTierInfoItem"
local TournamentScoreBgConfig = require "View/Tournament/TournamentScoreBgConfig"


--显示分割线的段位
local showLine = {1,4,7,10,13}

this.auto_bind_ui_items ={
	"tierSlider",
	"tierInfoItem",
	"playerCountItem",
	"Handle",
	"tierUnLock",
	"tierLock",
	"starBg",
	"myScoreItem",
	"myScore",
	"bg",
	"diBg1",
	"line",
	"root",
	"bg2",
	"Fill",
	"objParent"
}

--段位进度条实际缩短的值（顶部和底部按策划需求要留空）
local sliderHeightOffset = 220
local itemHeight = 450;

function TournamentArriveItem:New(isNowShowState,isInitState)
	local o = {}
	self.__index = self
	self.isChangeShowState=true
	self.isNowShowState=isNowShowState and true or false
	self.isInitState=isInitState
	self.initState=true
	setmetatable(o,self)
	return o
end

function TournamentArriveItem:GetRoot()
	return self.root;
end

function TournamentArriveItem:SetParent(parent)
	self.parent = parent
end

function TournamentArriveItem:Awake()
	self:on_init()
end

function TournamentArriveItem:OnEnable(isSettle)
	self._init = true
	self._isSettle = isSettle;
	
	self:OnShow();
end

function TournamentArriveItem:OnDisable()
	self:OnDispose()
	self._init = nil
	self._data = nil
	self.reward_item = nil;
	self._showAnim = nil
	self._animDelayTime = nil;
	self._isSettle = nil;
end

function TournamentArriveItem:OnShow()
	
end

function TournamentArriveItem:OnDispose()

end

function TournamentArriveItem:SetItem(data,index,startScore,isUpTier,name)
	self._data = data;
	self.bgIndex = index;
	self._tiers = self._data.tier;
	self.parentName=name

	if self._init and self._data then
		
		if self.initState==true then
			self:SetBg();
			self:SetItemBg();
			self:SetMyInfo(startScore);
			self.initState=false
		end
		
		self:SetTierInfo(startScore);
		
		self:SetTierPlayerNum();
		self:SetSliderBg(true)
	end	
	self.isNowShowState=true
end


function TournamentArriveItem:SetSliderBg(isRush)
	if not ModelList.TournamentModel:HasSprintBuff() then
        Cache.SetImageSprite("TournamentScoreAtlas","ZBJfJdtNr",self.Fill)
		return
	end
	if isRush then
        Cache.SetImageSprite("TournamentScoreAtlas","ZBJfUp",self.Fill)
	else
        Cache.SetImageSprite("TournamentScoreAtlas","ZBJfJdtNr",self.Fill)
	end
end

--设置段位信息
function TournamentArriveItem:SetTierInfo(startScore)
	self.tierInfoView = TournamentTierInfoItem:New();
	self.tierInfoView:SkipLoadShow(self.tierInfoItem);
	self.tierInfoView:SetData(self._data,self.bgIndex);
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	if startScore == nil or (startScore and startScore > scoreRange[2]) then
		self:PlayTierItemAnim("changeidle");
		self.tierInfoView:SetStage(true);		
	end
end

function TournamentArriveItem:PlayTierItemAnim(animName)
	local anim = fun.get_component(self.tierInfoItem,fun.ANIMATOR);
	if anim then
		anim:Play(animName);
	end
end

--设置背景相关图片
function TournamentArriveItem:SetBg()
	local tiers = ModelList.TournamentModel:GetTiers();
	if self.tierUnLock~=nil then
		self.tierUnLock.sprite = AtlasManager:GetSpriteByName("TournamentScoreAtlas",TournamentScoreBgConfig[self.bgIndex][7]);
		self.tierLock.sprite = AtlasManager:GetSpriteByName("TournamentScoreAtlas",TournamentScoreBgConfig[self.bgIndex][6]);
	end

	
	if self._tiers == 14 then
		--最高段位要将背景拉高
		local rectBg = fun.get_component(self.bg,fun.RECT);
		rectBg.sizeDelta = Vector2.New(rectBg.sizeDelta.x,rectBg.sizeDelta.y + 330);
		local rectBg1 = fun.get_component(self.diBg1,fun.RECT);
		rectBg1.sizeDelta = Vector2.New(rectBg1.sizeDelta.x,rectBg1.sizeDelta.y + 330);
	end
	self:ShowLine();
end

--显示分界线
function TournamentArriveItem:ShowLine()
	local isShow = false;
	for i, v in ipairs(showLine) do
		if v == self._tiers then
			isShow = true;
			break;
		end
	end
	fun.set_active(self.line,isShow);
end

--设置背景颜色
function TournamentArriveItem:SetItemBg()
	local color = TournamentScoreBgConfig[self.bgIndex][1];
	local bgColor = Color.New(1,1,1,1);
	local bgColor1 = Color.New(1,1,1,150 / 250);
	if self._isSettle then
		self.bg.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,180 / 255);
	else
		self.bg.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,color[4] / 255);
	end
	
	if self.diBg2 then
		self.diBg2.color = self._isSettle and bgColor1 or bgColor;
	end
	if self.diBg1 then
		self.diBg1.color = self._isSettle and bgColor1 or bgColor;
	end
end

--设置每个阶段玩家的数量
function TournamentArriveItem:SetTierPlayerNum()
	local str = "";
	if self._data and self._data.tierPlayerNum then
		fun.set_active(self.playerCountItem,self._data.tierPlayerNum > 0);
		str = self._data.tierPlayerNum;
		self:SetPlayerItem(self.playerCountItem,str);
	end
end

--设置玩家数量
--@params item 			item对象 GameObject
--@params str 			显示的文本
function TournamentArriveItem:SetPlayerItem(item,str)
	local refItem = fun.get_component(item , fun.REFER);
	if refItem then
		local txt = refItem:Get("txt");
		local anim = refItem:Get("anim");
		if anim then
			LuaTimer:SetDelayFunction(1,function()
				if anim and fun.is_not_null(anim) then
					anim:Play("start")
				end
			end,nil,LuaTimer.TimerType.UI)
		end
		if fun.is_not_null(txt) then
			txt.text = str
		end
	end
end

--设置玩家头像
function TournamentArriveItem:SetHeadIcon(uid,avatar,item,nickname)
	local img_head = item:Get("imgHead");
	local nameTxt = item:Get("nameTxt");
	local myUid = ModelList.PlayerInfoModel:GetUid()
	local model = ModelList.PlayerInfoSysModel
	if myUid == tonumber(uid) then
		model:LoadOwnHeadSprite(img_head);
	else
		local useAvatarName = model:GetCheckAvatar(avatar , uid)
		model:LoadTargetHeadSpriteByName(useAvatarName ,img_head)
	end
	
	if nickname then
		nameTxt.text = nickname;
	end
end

--根据分数计算在上下限分数之间的占比
function TournamentArriveItem:CalculateSliderValue(score)
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local ratio = (score - scoreRange[1]) / (scoreRange[2] - scoreRange[1]);
	ratio = Mathf.Clamp(ratio,0,1);
	return ratio
end

--设置自己的信息
--@params startScore 初始积分，用于爬进度动画
function TournamentArriveItem:SetMyInfo(startScore)
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height;
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local score = ModelList.TournamentModel:GetMayRankScore();
	if startScore then
		score = startScore;
	end
	score = Mathf.Clamp(score,scoreRange[1],scoreRange[2]);
	local startValue = self:CalculateSliderValue(score);
	if startScore and startScore < scoreRange[2] and startScore >= scoreRange[1] then
		self.myScore.text = score;
	end
	self.tierSlider.value = startValue;
	self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * startValue)
	
	--段位节点
	if scoreRange and score >= scoreRange[2] then
		fun.set_active(self.tierUnLock,true);
		fun.set_active(self.tierLock,false);
	else
		fun.set_active(self.tierUnLock,false);
		fun.set_active(self.tierLock,true);
	end
	
	if startScore and startScore < scoreRange[2] and startScore >= scoreRange[1]  then
		LuaTimer:SetDelayFunction(0.3,function()
				self.parent.myScoreItem.transform.position = self.Handle.transform.position
		end,nil,LuaTimer.TimerType.UI)	
		self:PlaySliderAnim(score)
	end
end

--计算scrollView的垂直滑动值
function TournamentArriveItem:CalculateScrollPercent(startScore)
	local curTiers = ModelList.TournamentModel:GetTiers();
	local totalHight1 = 320;
	for i = 14, 1,-1 do
		if i > curTiers then
			totalHight1 = totalHight1 + 1900;
		elseif i == curTiers then
			totalHight1 = totalHight1 + 1920 * 2;
		elseif i > self._tiers then
			totalHight1 = totalHight1 + 450;		
		end
	end

	local contentHeight = fun.get_component(self.parent.item_list.content,fun.RECT).rect.height;
	local viewportHeight = fun.get_component(self.parent.item_list.viewport,fun.RECT).rect.height;
	local diff = contentHeight - viewportHeight;

	local totalHight2 = totalHight1;
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local ratio = (startScore - scoreRange[1]) / (scoreRange[2] - scoreRange[1]);
	ratio = Mathf.Clamp(ratio,0,1);
	--ratio = ((itemHeight - sliderHeightOffset * 2) * ratio + sliderHeightOffset) / itemHeight;
	local diff1 = itemHeight * (1 - ratio);
	if diff1 < 0 then
		diff1 = 0;
	end
	totalHight2 = totalHight2 + diff1;
	local middlePercent = Mathf.Clamp(1 - (totalHight2 - viewportHeight / 2) / diff,0,1);
	
	return middlePercent;
end

--Slider动画
function TournamentArriveItem:PlaySliderAnim(startScore)
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local lastScore = Mathf.Clamp(startScore,scoreRange[1],scoreRange[2]);
	local curScore = ModelList.TournamentModel:GetMayRankScore();
	local startValue = self:CalculateSliderValue(lastScore);
	local targetValue = self:CalculateSliderValue(curScore);
	
	LuaTimer:SetDelayFunction(0.5,function()
			self:PlayTierItemAnim("enter");
			self.parent:PlayMyTierItemAnim("end");
	end,nil,LuaTimer.TimerType.UI)
	
	self._animTime = (targetValue - startValue) * itemHeight / 250;
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height;
	LuaTimer:SetDelayFunction(0.5,function()
			fun.set_active(self.parent.ef_jindu,true);
			self.parent:PlayScoreChangeSound();	
			Anim.do_smooth_float_update(startValue,targetValue,self._animTime / 2,function(num)
					self.tierSlider.value = num;
					local score = math.floor(num * (scoreRange[2] - scoreRange[1]) + scoreRange[1]);
					self.myScore.text = score;
					self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * num)
					self.parent.myScoreItem.transform.position = self.Handle.transform.position
				end,function()
					self.myScore.text = scoreRange[2];
					self.tierInfoView:PlayTierAwardAnim(self._data.tierReward,self.parent.btn_gift.transform.position,function()
							self.parent.btn_gift_anim:Play("act");
							self.parent:PlayCurrentTierAnim(self._tiers + 1);
					end);
					self:PlayTierItemAnim("changeenter");
					fun.set_active(self.tierUnLock,true);
					fun.set_active(self.tierLock,false);
				end)
		end,nil,LuaTimer.TimerType.UI)
	
	
	LuaTimer:SetDelayFunction(0.5,function()
			local startPercent = self:CalculateScrollPercent(lastScore);
			local endPercent = self:CalculateScrollPercent(scoreRange[2]);
			Anim.do_smooth_float_update(startPercent,endPercent,self._animTime / 2,function(num)
					self.parent.item_list.verticalNormalizedPosition = num;
				end,function()
					self.parent.item_list.verticalNormalizedPosition = endPercent;
				end)
		end,nil,LuaTimer.TimerType.UI)
end

function TournamentArriveItem:ShowChangePush()

end

function TournamentArriveItem:ShowAnim()
	self._showAnim = true;
end

return this
	