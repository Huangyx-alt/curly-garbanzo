local TournamentNoArriveItem = require "View/Tournament/TournamentNoArriveItem"
local TournamentCurrentItem = TournamentNoArriveItem:New()
local this = TournamentCurrentItem

local TournamentTierInfoItem = require "View/Tournament/TournamentTierInfoItem"
local TournamentScoreBgConfig = require "View/Tournament/TournamentScoreBgConfig"

this.auto_bind_ui_items = {
	"tierSlider",
	"myScoreItem",
	"myScore",
	"stageItem",
	"playerCountItem",
	"playerNameItem",
	"imgHead",
	"imageFrame",
	"starBg",
	"tierInfoItem",
	"buffFlag",
	"sprintBuffBtn",
	"tierLock",
	"tierUnLock",
	"Handle",
	"bg",
	"diBg1",
	"bg2",
	"bgLine",
	"line",
	"diBg2",
	"ef_jindu",
	"root",
	"Fill",
	"stageItemRoot",
	"upRowObj",
	"objParent"
}

--段位进度条实际缩短的值（顶部和底部按策划需求要留空）
local sliderHeightOffset = 220
local itemHeight = 3840;

function TournamentCurrentItem:New(isNowShowState,isInitState)
	local o = {}
	self.__index = self
	self.isChangeShowState=true
	self.isNowShowState=isNowShowState and true or false
	self.isInitState=isInitState
	self.initState=true
	setmetatable(o,self)
	return o
end

function TournamentCurrentItem:OnEnable(isSettle)
	self._isSettle = isSettle;
	self._init = true
	self:InitSprintBuff();
end

function TournamentCurrentItem:SetItem(data,index,startScore,isUpTier,name)
	self._data = data;
	self.bgIndex = index;
	self._tiers = self._data.tier;
	self.parentName=name
	if self._init and self._data then
		if self.initState==true then
			self:SetBg();
		    self:SetItemBg();
			self:SetSliderBg(true)
			self:SetMyInfo(startScore,isUpTier);
			self:SetStageItems(startScore);
		 	self.initState=false
		 end
		
		 self:SetTierInfo(startScore);
		
		
		self:ShowCurFirstStagePlayer();
		self:ShowCurStagePlayerNum();
		
		--self.go.name = "testItem:TournamentCurrentItem:" ..index
	end
end

function TournamentCurrentItem:SetTierInfo(startScore)
	self.tierInfoView = TournamentTierInfoItem:New();
	self.tierInfoView:SkipLoadShow(self.tierInfoItem);
	self.tierInfoView:SetData(self._data,self.bgIndex);
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	if startScore and startScore > scoreRange[2] then
		self:PlayTierItemAnim("changeidle");
		self.tierInfoView:SetStage(true);
	end
end

function TournamentCurrentItem:SetItemBg()
	local color = TournamentScoreBgConfig[self.bgIndex][1];
	local color2 = TournamentScoreBgConfig[self.bgIndex][10];
	if self._isSettle then
		self.bg2.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,180 / 255);
		self.bg.color = Color.New(color2[1] / 255,color2[2] / 255,color2[3] / 255,120 / 255);
	else
		self.bg2.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,color[4] / 255);
		self.bg.color = Color.New(color2[1] / 255,color2[2] / 255,color2[3] / 255,color2[4] / 255);	
	end
	
	local bgLineImg = fun.get_component(self.bgLine,fun.IMAGE);
	fun.SetSprite(bgLineImg,AtlasManager:GetSpriteByName("TournamentScoreAtlas",TournamentScoreBgConfig[self.bgIndex][11]))

	local bgColor = Color.New(1,1,1,1);
	local bgColor1 = Color.New(1,1,1,150 / 250);
	if self.diBg2 then
		self.diBg2.color = self._isSettle and bgColor1 or bgColor;
	end
	if self.diBg1 then
		self.diBg1.color = self._isSettle and bgColor1 or bgColor;
	end
end


--设置自己的信息(头像、积分、进度条)
function TournamentCurrentItem:SetMyInfo(startScore,isUpTier,startRatio)
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local myscore = ModelList.TournamentModel:GetMayRankScore();
	local score = myscore;
	if startScore then
		score = Mathf.Clamp(startScore,scoreRange[1],scoreRange[2]);
	end
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height;
	--头像
	ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(self.imgHead);
	--Slider位置
	local startValue = self:CalculateSliderValue(score);
	startValue = ((itemHeight - sliderHeightOffset * 2) * startValue + sliderHeightOffset) / itemHeight;
	if isUpTier or startRatio then
		startValue = 0;
	end
	if not startScore and myscore > scoreRange[2] then
		startValue = 1;
	end
	self.tierSlider.value = startValue;
	self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * startValue)
	local bgAn = fun.get_component(self.bg,fun.RECT);
	local bgLiang = fun.get_component(self.bg2,fun.RECT);
	if self._tiers == 14 then
		bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,sliderHeight * (1 - startValue) + 330);
		self.bg.transform.anchoredPosition = Vector2.New(self.bg.transform.anchoredPosition.x,self.bg.transform.anchoredPosition.y + 330);
		self.bg.transform.localPosition = Vector3.New(0,2250,0);
	else
		bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,sliderHeight * (1 - startValue));
		self.bg.transform.localPosition = Vector3.New(0,1920,0);
	end
	bgLiang.sizeDelta = Vector2.New(bgLiang.sizeDelta.x,sliderHeight * startValue);
	fun.set_active(self.bgLine,not isUpTier);
	self.bgLine.transform.anchoredPosition = Vector2.New(self.bgLine.transform.anchoredPosition.x,sliderHeight * startValue);
	
	if not isUpTier then
		self.myScore.text = fun.NumInsertComma(score);
	end
	--检查加成
	self:CheckSprintBuff();
	--段位节点
	if scoreRange and score >= scoreRange[2] then
		fun.set_active(self.tierUnLock,true);
		fun.set_active(self.tierLock,false);
	else
		fun.set_active(self.tierUnLock,false);
		fun.set_active(self.tierLock,true);
	end
	
	if startScore and not isUpTier  then
		self:PlaySliderAnim(score,startRatio)
	end
	
	
end

function TournamentCurrentItem:SetSliderBg(isRush)
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

--Slider动画
function TournamentCurrentItem:PlaySliderAnim(startScore,startRatio)	
	self:SetSliderBg(true)
	log.log("dghdgh0007 open this startScore  startRatio",startScore,startRatio)
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local lastScore = Mathf.Clamp(startScore,scoreRange[1],scoreRange[2]);
	local curScore = ModelList.TournamentModel:GetMayRankScore();
	local startValue = self:CalculateSliderValue(lastScore);
	if not startRatio then
		startValue = ((itemHeight - sliderHeightOffset * 2) * startValue + sliderHeightOffset) / itemHeight;
	end
	local targetValue = self:CalculateSliderValue(curScore);
	targetValue = ((itemHeight - sliderHeightOffset * 2) * targetValue + sliderHeightOffset) / itemHeight;
	if curScore > scoreRange[2] then
		targetValue = 1;
	end
	local time = (targetValue - startValue) * (itemHeight - sliderHeightOffset * 2) / 250;
	if startRatio and startRatio == 0 then
		time = (targetValue - startValue) * itemHeight  / 250;
	end
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height;
	
	local bgLineaAnchoredPositionX = self.bgLine.transform.anchoredPosition.x;
	local bgAn = fun.get_component(self.bg,fun.RECT);
	local bgLiang = fun.get_component(self.bg2,fun.RECT);
	--阶段分数
	local scoreList = ModelList.TournamentModel:GetAllStageNeedScore(self._tiers);
	local delayTime = 1;
	if self._animDelayTime then
		delayTime = delayTime + self._animDelayTime;
	end
	LuaTimer:SetDelayFunction(0.5,function()
		if not self or fun.is_null(self.parent)then
			return
		end
			self.parent:PlayScoreChangeSound();
			if ModelList.TournamentModel:HasSprintBuff()then
				fun.set_active(self.upRowObj,true)
			else
				fun.set_active(self.upRowObj,false)
			end
			self.parent:SetEffectVisible(true);
			Anim.do_smooth_float_update(startValue,targetValue,time / 3,function(num)
				if not self or fun.is_null(self.tierSlider)then
					return
				end
					self.tierSlider.value = num;
					local pre = (num * itemHeight - sliderHeightOffset) / (itemHeight - sliderHeightOffset * 2);
					pre = Mathf.Clamp(pre,0,1);
					local score = math.floor(pre * (scoreRange[2] - scoreRange[1]) + scoreRange[1]); 
					local num1 = math.floor(num * (scoreRange[2] - scoreRange[1]) + scoreRange[1]);
					self.myScore.text = fun.NumInsertComma(num1);
					self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * num)
					self.parent.myScoreItem.transform.position = self.Handle.transform.position
					self.upRowObj.transform.position = self.Handle.transform.position
					self.bgLine.transform.anchoredPosition = Vector2.New(bgLineaAnchoredPositionX,sliderHeight * num);
					if self._tiers == 14 then
						bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,sliderHeight * (1 - num) + 330);
						self.bg.transform.anchoredPosition = Vector2.New(self.bg.transform.anchoredPosition.x,self.bg.transform.anchoredPosition.y + 330);
						self.bg.transform.localPosition = Vector3.New(0,2250,0);
					else
						bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,sliderHeight * (1 - num));
					end
					bgLiang.sizeDelta = Vector2.New(bgLiang.sizeDelta.x,sliderHeight * num);
					
					for i, v in ipairs(scoreList) do
						if score > v and lastScore < v then
							if self.parent.showAnim then
								self.stageItemList[#scoreList - i + 1]:FlyRewardToTopArea();
								break;			
							end			
						end
					end
				end,function()
					self.parent:SetEffectVisible(false);
					fun.set_active(self.upRowObj,false)
					for i, v in ipairs(scoreList) do
						if curScore > v and lastScore < v then
							if self.parent.showAnim then
								self.stageItemList[#scoreList - i + 1]:FlyRewardToTopArea();
								break;
							end
						end
					end
					
					if curScore > scoreRange[2] then
						self.tierInfoView:PlayTierAwardAnim(self._data.tierReward, self.parent.btn_gift.transform.position, function()
							if self and  fun.is_not_null(self.parent) and fun.is_not_null(self.parent.btn_gift_anim) then
								self.parent.btn_gift_anim:Play("act");
							end
						end);
						self:PlayTierItemAnim("changeenter");
						fun.set_active(self.tierUnLock,true);
						fun.set_active(self.tierLock,false);
					end
					self.myScore.text = fun.NumInsertComma(curScore);
					self.parent:SetMaskVisible(false);
					self.parent.tierInfoView:OnHide();
					self.parent:SetEffectVisible(false)
					fun.set_active(self.parent.ef_jindu,false);
				end)
			end,nil,LuaTimer.TimerType.UI)
	

	LuaTimer:SetDelayFunction(0.5,function()
		if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) or fun.is_null(self.parent.item_list.content) then
			return
		end
			local startPercent = self:CalculateScrollPercent(lastScore);
			local endPercent = self:CalculateScrollPercent(curScore);
			Anim.do_smooth_float_update(startPercent,endPercent,time / 3,function(num)
				if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) then
					return
				end
					self.parent.item_list.verticalNormalizedPosition = num;
				end,function()
				UISound.stop_loop("weeklyincrease")
				if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) then
					return
				end
				self.parent.item_list.verticalNormalizedPosition = endPercent;

				end)
		end,nil,LuaTimer.TimerType.UI)	
end

function TournamentCurrentItem:CalculateScrollPercent(startScore)
	local curTiers = ModelList.TournamentModel:GetTiers();
	local totalHight1 = 320;
	for i = 14, 1,-1 do
		if i > self._tiers then
			totalHight1 = totalHight1 + 1900;
		end
	end

	local contentHeight = fun.get_component(self.parent.item_list.content,fun.RECT).rect.height;
	local viewportHeight = fun.get_component(self.parent.item_list.viewport,fun.RECT).rect.height;
	local diff = contentHeight - viewportHeight;

	--计算自己的位置
	local totalHight2 = totalHight1;
	local scoreRange = ModelList.TournamentModel:GetScoreRangeByTiers(self._tiers);
	local ratio = (startScore - scoreRange[1]) / (scoreRange[2] - scoreRange[1]);
	ratio = Mathf.Clamp(ratio,0,1);
	ratio = ((itemHeight - sliderHeightOffset * 2) * ratio + sliderHeightOffset) / itemHeight;
	local diff1 = itemHeight * (1 - ratio);
	if diff1 < 0 then
		diff1 = 0;
	end
	totalHight2 = totalHight2 + diff1;
	local middlePercent = Mathf.Clamp(1 - (totalHight2 - viewportHeight / 2)  / diff,0,1);

	return middlePercent;
end

--加成相关
function TournamentCurrentItem:InitSprintBuff()
	self.luabehaviour:AddClick(self.sprintBuffBtn, function()
			self:PlayBtnClickSound()
			self:OnBtnTournamentBuffClick(self.sprintBuffBtn)
		end)
	fun.set_active(self.buffFlag, false)
end

function TournamentCurrentItem:CheckSprintBuff()
	if fun.is_null(self.buffFlag) then
		return
	end

	if ModelList.TournamentModel:HasSprintBuff() then
		fun.set_active(self.buffFlag, true)
	else
		fun.set_active(self.buffFlag, false)
	end
end

function TournamentCurrentItem:HasSprintBuff()
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

function TournamentCurrentItem:OnBtnTournamentBuffClick(target)
	local bubble = ViewList.BubbleTipView and ViewList.BubbleTipView.go
	if bubble and bubble.gameObject.activeSelf then
		return
	end
	local posParams = self:GetBuffPosParams()
	local des_text = ModelList.TournamentModel:GetSprintBuffDes()
	local ArrowDirection = ViewList.BubbleTipView.ArrowDirection
	local params = {
		pos = target.transform.position,
		dir = ArrowDirection.bottom,
		text = des_text,
		offset = Vector3.New(posParams.bubbleX or 0, posParams.bubbleY or 0, 0),
		exclude = {target},
		arrowOffset = posParams.arrowOffset or 0,
	}
	Facade.SendNotification(NotifyName.ShowUI, ViewList.BubbleTipView, nil, false, params)
end


function TournamentCurrentItem:GetBuffPosParams()
	local params = {}
	params.buffX = 20
	params.buffY = 20
	params.bubbleX = 0
	params.bubbleY = 90
	params.arrowOffset = 0
	return params
end

----------------

--显示自己阶段第一到第五名玩家
function TournamentCurrentItem:ShowCurFirstStagePlayer()
	local myRankInfo = ModelList.TournamentModel:GetMyRankInfo()
	local stageData = self._data.stageList[#self._data.stageList];
	if myRankInfo.score > stageData.score then
		--超过最大阶段
		local myRatio = self:CalculateSliderValue(myRankInfo.score);
		myRatio = ((itemHeight - sliderHeightOffset * 2) * myRatio + sliderHeightOffset) / itemHeight;

		local stageRatio = self:CalculateSliderValue(stageData.score);
		stageRatio = ((itemHeight - sliderHeightOffset * 2) * stageRatio + sliderHeightOffset) / itemHeight;
		
		self:ShowNearPlayer(myRankInfo,myRatio,1,stageRatio,true);	
		
	else
		self:ShowFirstStagePlayer();		
	end
end

--显示自己最近的玩家
function TournamentCurrentItem:ShowNearPlayer(myRankInfo,myRatio,upStageRatio,downStageRatio,isShowFirst)
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height;
	local rankInfoList = ModelList.TournamentModel:GetServerRankInfo();
	local upRatio = (myRatio + upStageRatio) / 2;
	local downRatio = (downStageRatio + myRatio) / 2;
	
	local nearStageScore = nil
	if self._data then
		for i, playerData in ipairs(self._data.stageList) do
			if myRankInfo.score >= playerData.minScore and myRankInfo.score <= playerData.score then
				nearStageScore = self._data.stageList[i].score
				break
			end
		end
	end

	--显示第一名玩家
	if isShowFirst then
		if myRankInfo.order > 1 then
			if self._data and self._data.topPlayers then
				for i, playerData in ipairs(self._data.topPlayers) do
					if playerData.order == 1 then
						local posY = upRatio * sliderHeight;
						self:SetOnePlayer(playerData,posY,0,nil,true,1,true);
						break;
					end
				end
			end	
		end
	end
	
	local showCount = 0;
	local showNum = 0
	local count = fun.get_child_count(self.root)
	for i, v in ipairs(rankInfoList) do
		--前一名玩家
		if not isShowFirst then
			if v.order == myRankInfo.order - 1 then
				if nearStageScore ~= nil and v.score <= nearStageScore then
					local pos = upRatio * sliderHeight;
					self:SetOnePlayer(v,pos,0,nil,true,1,true);
				end
			end
		end
		--显示自己后4名玩家
		if myRankInfo.order < v.order then
			showNum = showNum + 1
			local palyerPosY = downRatio * sliderHeight;
			self:SetOnePlayer(v,palyerPosY,showCount * 24,count,false,  showNum,true);
			showCount = showCount + 1;
		end
		if showCount >= 4 then
			break;
		end
	end
end


--显示阶段之间玩家数量
function TournamentCurrentItem:ShowCurStagePlayerNum()
	local myRankInfo = ModelList.TournamentModel:GetMyRankInfo()
	local sliderHeight = itemHeight;
	local myStageIndex = self:GetStageIndex(myRankInfo);
	
	for i = 1, #self._stageRratios do
		if i ~= myStageIndex then
			local ratio = 0;
			if i == 1 then
				ratio = self._stageRratios[i] / 2;
			else
				ratio = (self._stageRratios[i] + self._stageRratios[i - 1]) / 2;
			end
			local posY = ratio * sliderHeight;
			
			--判断阶段人数是否>=5，>=则显示人数，<则显示玩家
			if self._data.stageList[i].stagePlayerNum >= 5 then

				local go = nil
				if self.isNowShowState==true and self.isChangeShowState==true then
					if #CountObjectPool>0 then
						go = ObjectPop(1)
						fun.set_parent(go,self.root)
						fun.set_active(go,true)
					else
						go = fun.get_instance(self.playerCountItem, self.root);
						fun.set_active(go,true)
					end
				end	
				if go then
					go.transform.anchoredPosition = Vector2.New(go.transform.anchoredPosition.x,posY);
					self:SetPlayerItem(go,self._data.stageList[i].stagePlayerNum);
				end
			else
				local showPlayerNum = 0
				if self._data.stageList[i].showPlayers then
					local playerNum = #self._data.stageList[i].showPlayers;
					local childCount = fun.get_child_count(self.root)
					for j, player in ipairs(self._data.stageList[i].showPlayers) do
						if playerNum > 1 then
							showPlayerNum = showPlayerNum + 1
							self:SetOnePlayer(player,posY,24 * (j - 1),childCount,false,showPlayerNum,true);
						else
							self:SetOnePlayer(player,posY,24 * (j - 1),childCount,true,j,true);
						end
						
					end
				end
			end
		else
			local myRatio = self:CalculateSliderValue(myRankInfo.score);
			myRatio = ((sliderHeight - sliderHeightOffset * 2) * myRatio + sliderHeightOffset) / sliderHeight;
			
			local upStageRatio = self:CalculateSliderValue(self._data.stageList[i].score);
			upStageRatio = ((sliderHeight - sliderHeightOffset * 2) * upStageRatio + sliderHeightOffset) / sliderHeight;
			
			local downStageRatio = self:CalculateSliderValue(self._data.stageList[i].minScore);
			downStageRatio = ((sliderHeight - sliderHeightOffset * 2) * downStageRatio + sliderHeightOffset) / sliderHeight;
			
			self:ShowNearPlayer(myRankInfo,myRatio,upStageRatio,downStageRatio,false);
		end	
	end
	self.isNowShowState=true
end	

function TournamentCurrentItem:ShowChangePush()
	local count=fun.get_child_count(self.root)
	if count > 15 then
		for i = 1, count do
			local obj=fun.get_child(self.root,i-1)
			if obj~=nil and obj.name=="playerCountItem(Clone)" then
				ObjectPush(1,obj)
				fun.set_active(obj,false)
				fun.set_parent(obj,self.objParent)
			elseif obj~=nil and obj.name=="playerNameItem(Clone)" then
				local t =  fun.get_component(fun.find_child(obj.gameObject,"nameTxt"),fun.OLDTEXT)
				t.text=""
				ObjectPush(2,obj)
				fun.set_active(obj,false)
				fun.set_parent(obj,self.objParent)
			end
		end
	end	
end

--获取在阶段区间
function TournamentCurrentItem:GetStageIndex(myRankInfo)
	for i, v in ipairs(self._data.stageList) do
		if myRankInfo.score >= v.minScore and myRankInfo.score <= v.score then
			return i;
		end
	end
end

return this