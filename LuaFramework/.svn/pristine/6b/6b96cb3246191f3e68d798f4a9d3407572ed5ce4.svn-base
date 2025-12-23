local HallofFameArriveItem = require "View/HallofFame/HallofFameArriveItem"
local HallofFameArriveFullItem = HallofFameArriveItem:New()
local this = HallofFameArriveFullItem

local HallofFameTierInfoItem = require "View/HallofFame/HallofFameTierInfoItem"
local HallofFameStageInfoItem = require "View/HallofFame/HallofFameStageInfoItem"

local TournamentScoreBgConfig = require "View/Tournament/TournamentScoreBgConfig"

this.auto_bind_ui_items = {
	"tierSlider",
	"tierInfoItem",
	"stageItem",
	"tierLock",
	"bg",
	"tierUnLock",
	"diBg1",
	"playerNameItem",
	"playerCountItem",
	"line",
	"root",
	"stageItemRoot",
	"Handle",
	"myScore",
	"starBg",
	"upRowObj",
	"Fill",
	"objParent"
}

local itemHeight = 1900
local sliderHeightOffset = 220


function HallofFameArriveFullItem:New(isNowShowState,isInitState)
	local o = {}
	self.__index = self
	self.isChangeShowState=true
	self.isNowShowState=isNowShowState and true or false
	self.isInitState=isInitState
	self.initState=true
	self.isTrue = false
	setmetatable(o,self)
	return o
end

function HallofFameArriveFullItem:OnDispose()
	self.tierInfoView = nil
	--self.stageItemList = nil
	self.bgIndex = nil
	self.upRatio = nil
	self.downRatio = nil
	self._stageRratios = nil
	self.startMoveScore = nil
end

function HallofFameArriveFullItem:SetItem(data,index,startScore,isUpTier)
	self._data = data
	self.bgIndex = index
	self._tiers = self._data.tier
	self.startMoveScore = startScore or nil
	if self._init and self._data then
		if self.initState==true then
			self:SetBg();
			self:SetItemBg();
			self:SetSliderBg(true)
			-- self:SetMyInfo(startScore);
			self:SetMyInfo(self.startMoveScore);
			self.initState=false
		end
		self:SetTierInfo();
		self:SetStageItems();
		self:ShowFirstStagePlayer();
		
		self:ShowStagePlayerNum();
	end
end

function HallofFameArriveFullItem:SetItemBg()
	local color = TournamentScoreBgConfig[self.bgIndex][10]
	local bgColor = Color.New(1,1,1,1)
	local bgColor1 = Color.New(1,1,1,150 / 250)
	if self._isSettle then
		self.bg.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,120 / 255)
	else
		self.bg.color = Color.New(color[1] / 255,color[2] / 255,color[3] / 255,color[4] / 255)
	end

	if self.diBg2 then
		self.diBg2.color = self._isSettle and bgColor1 or bgColor
	end
	if self.diBg1 then
		self.diBg1.color = self._isSettle and bgColor1 or bgColor
	end
end

function HallofFameArriveFullItem:SetTierInfo()
	self.tierInfoView = HallofFameTierInfoItem:New()
	self.tierInfoView:SkipLoadShow(self.tierInfoItem)
	self.tierInfoView:SetData(self._data,self.bgIndex)
end

--设置自己的信息
--@params startScore 初始积分，用于爬进度动画
function HallofFameArriveFullItem:SetMyInfo(startScore)
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
	local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
	local score = ModelList.HallofFameModel:GetMayRankScore()
	--log.log("周榜内容检查 分数拆分" ,self.go.name , score  , scoreRange)
	if startScore then
		score = startScore
	end
	score = Mathf.Clamp(score,scoreRange[1],scoreRange[2])
	local startValue = self:CalculateSliderValue(score)
	if startScore and startScore < scoreRange[2] and startScore >= scoreRange[1] then
		-- self.myScore.text = score
		self.myScore.text = fun.NumInsertComma(score)
--		log.log("更新进度积分数据a" , score)
	end
	self.tierSlider.value = startValue
	self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * startValue)
	
	--段位节点
	if scoreRange and score >= scoreRange[2] then
		fun.set_active(self.tierUnLock,true)
		fun.set_active(self.tierLock,false)
	else
		fun.set_active(self.tierUnLock,false)
		fun.set_active(self.tierLock,true)
	end
	
	--log.log("周榜内容检查 进度动画数据" , startScore  , scoreRange ,startScore and startScore < scoreRange[2] and startScore >= scoreRange[1] )
	if startScore and startScore < scoreRange[2] and startScore >= scoreRange[1]  then
		LuaTimer:SetDelayFunction(0.3,function()
				self.parent.myScoreItem.transform.position = self.Handle.transform.position
		end,nil,LuaTimer.TimerType.UI)	
		self:PlaySliderAnim(score)
	end
end

function HallofFameArriveFullItem:PlayTierItemAnim(animName)
	local anim = fun.get_component(self.tierInfoItem,fun.ANIMATOR)
	if anim then
		anim:Play(animName)
	end
end

function HallofFameArriveFullItem:SetSliderBg(isRush)
	if not ModelList.HallofFameModel:HasSprintBuff() then
        Cache.SetImageSprite("HallofFameScoreAtlas","ZBJfJdtNr",self.Fill)
		return
	end
	if isRush then
        Cache.SetImageSprite("HallofFameScoreAtlas","ZBJfUp",self.Fill)
	else
        Cache.SetImageSprite("HallofFameScoreAtlas","ZBJfJdtNr",self.Fill)
	end
end

--Slider动画
function HallofFameArriveFullItem:PlaySliderAnim(startScore,startRatio)
	
	self:SetSliderBg(false)
	local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
	local lastScore = Mathf.Clamp(startScore,scoreRange[1],scoreRange[2])
	local curScore = ModelList.HallofFameModel:GetMayRankScore()
	local startValue = self:CalculateSliderValue(lastScore)

	if not startRatio then
		startValue = ((itemHeight - sliderHeightOffset * 2) * startValue + sliderHeightOffset) / itemHeight
	end
	local targetValue = self:CalculateSliderValue(curScore)
	targetValue = ((itemHeight - sliderHeightOffset * 2) * targetValue + sliderHeightOffset) / itemHeight
	if curScore > scoreRange[2] then
		targetValue = 1
	end
	local time = (targetValue - startValue) * (itemHeight - sliderHeightOffset * 2) / 250
	if startRatio and startRatio == 0 then
		time = (targetValue - startValue) * itemHeight  / 250
	end
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
	
	--local bgLineaAnchoredPositionX = self.bgLine.transform.anchoredPosition.x
	local bgAn = fun.get_component(self.bg,fun.RECT)
	local bgLiang = fun.get_component(self.bg2,fun.RECT)
	--阶段分数
	local scoreList = ModelList.HallofFameModel:GetAllStageNeedScore(self._tiers)
	local delayTime = 1
	if self._animDelayTime then
		delayTime = delayTime + self._animDelayTime
	end
	LuaTimer:SetDelayFunction(0.5,function()
		if not self or fun.is_null(self.parent)then
			return
		end
			self.parent:PlayScoreChangeSound()
			if ModelList.HallofFameModel:HasSprintBuff() then
				fun.set_active(self.upRowObj,true)
			else
				fun.set_active(self.upRowObj,false)
			end
			self.parent:SetEffectVisible(true)
			Anim.do_smooth_float_update(startValue,targetValue,time / 1.5 ,function(num)
				if not self or fun.is_null(self.tierSlider)then
					return
				end
					self.tierSlider.value = num
					local pre = (num * itemHeight - sliderHeightOffset) / (itemHeight - sliderHeightOffset * 2)
					pre = Mathf.Clamp(pre,0,1)
					local score = math.floor(pre * (scoreRange[2] - scoreRange[1]) + scoreRange[1]) 
					local num1 = math.floor(num * (scoreRange[2] - scoreRange[1]) + scoreRange[1])
					self.myScore.text = fun.NumInsertComma(num1)
					self.starBg.sizeDelta = Vector2.New(self.starBg.sizeDelta.x,sliderHeight * num)
					self.parent.myScoreItem.transform.position = self.Handle.transform.position	
					self.upRowObj.transform.position = self.Handle.transform.position
					if self._tiers == 14 then
						bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,sliderHeight * (1 - num) + 330)
						self.bg.transform.anchoredPosition = Vector2.New(self.bg.transform.anchoredPosition.x,self.bg.transform.anchoredPosition.y + 330)
						self.bg.transform.localPosition = Vector3.New(0,2250,0)
					else
						if self.initState == true then
							bgAn.sizeDelta = Vector2.New(bgAn.sizeDelta.x,1900);
						end 
					end
					for i, v in ipairs(scoreList) do
						if score > v and lastScore < v then
							if self.parent.showAnim then
								self.stageItemList[#scoreList - i + 1]:FlyRewardToTopArea()
								break			
							end			
						end
					end
				end,function()
					fun.set_active(self.upRowObj,false)
					self.parent:SetEffectVisible(false)
					for i, v in ipairs(scoreList) do
						if curScore > v and lastScore < v then
							if self.parent.showAnim then
								self.stageItemList[#scoreList - i + 1]:FlyRewardToTopArea()
								break
							end
						end
					end
					
					if curScore >= scoreRange[2] then
						self.tierInfoView:PlayTierAwardAnim(self._data.tierReward,self.parent.btn_gift.transform.position,function()
								self.parent.btn_gift_anim:Play("act")
								self.parent:PlayCurrentTierAnim(self._tiers + 1)
							end)
						self:PlayTierItemAnim("changeenter")
						fun.set_active(self.tierUnLock,true)
						fun.set_active(self.tierLock,false)
					end
					self.myScore.text = fun.NumInsertComma(scoreRange[2])
					self.parent:SetEffectVisible(false)
					fun.set_active(self.parent.ef_jindu,false)
				end)
			end,nil,LuaTimer.TimerType.UI)
	

	LuaTimer:SetDelayFunction(0.5,function()
		if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) or fun.is_null(self.parent.item_list.content) then
			return
		end
			local startPercent = self:CalculateScrollPercent(lastScore)
			local endPercent = self:CalculateScrollPercent(curScore)
			Anim.do_smooth_float_update(startPercent,endPercent,time / 1.5 ,function(num)
				if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) then
					return
				end
					self.parent.item_list.verticalNormalizedPosition = num
				end,function()
				UISound.stop_loop("weekly_increase")
				if not self or fun.is_null(self.parent) or fun.is_null(self.parent.item_list) then
					return
				end
				self.parent.item_list.verticalNormalizedPosition = endPercent
					self.isTrue = true
				end)
				
		end,nil,LuaTimer.TimerType.UI)	
			
		
end

--设置阶段奖励
function HallofFameArriveFullItem:SetStageItems(startScore)
	self.stageItemList = {}
	self._stageRratios = {}
	if self._data then
		local myScore = ModelList.HallofFameModel:GetMayRankScore()
		if startScore then
			myScore = startScore
		end
		local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
		local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
		local bottomHight = (220 / sliderHeight) * sliderHeight
		local score = ModelList.HallofFameModel:GetMayRankScore()
		if self.startMoveScore then
			score = self.startMoveScore
			if self.isNowShowState==true and self.isChangeShowState==true and self.isTrue == true then
				score = myScore
			end
		end
		local startScoreData = Mathf.Clamp(score,scoreRange[1],scoreRange[2])
		local lastScore = Mathf.Clamp(startScoreData,scoreRange[1],scoreRange[2])

		for i, v in ipairs(self._data.stageList) do
			local ratio = (v.score - scoreRange[1]) / (scoreRange[2] - scoreRange[1])
			ratio = Mathf.Clamp(ratio,0,1)
			
			local startValue = ((sliderHeight - 220 * 2) * ratio + 220) / sliderHeight
			table.insert(self._stageRratios,startValue)
			
			local hight = ratio * (sliderHeight - 220 * 2) + bottomHight
			local parent = self.root
			if self.stageItemRoot then
				parent = self.stageItemRoot
			end
			local go = fun.get_instance(self.stageItem, self.root)
			if go then
				go.name = "testGrid" .. math.random(1,100)
				go.transform.anchoredPosition = Vector2.New(go.transform.anchoredPosition.x,hight)
				fun.set_active(go,true)
				fun.set_parent(go,parent)
				local view = HallofFameStageInfoItem:New()
				view:SkipLoadShow(go.gameObject,true)
				view:SetData(v,self.bgIndex,myScore,ratio,lastScore,true)
				table.insert(self.stageItemList,view)
			end		
		end
	end	
end

--显示阶段人数
function HallofFameArriveFullItem:ShowStagePlayerNum()
	local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
	for i = 1, #self._stageRratios do
		if self._data.stageList[i].stagePlayerNum > 0 then
			local ratio = 0
			if i == 1 then
				ratio = self._stageRratios[i] / 2
			else
				ratio = (self._stageRratios[i] + self._stageRratios[i - 1]) / 2
			end
			local posY = ratio * sliderHeight
			
			--判断阶段人数是否>=5，>=则显示人数，<则显示玩家
			if self._data.stageList[i].stagePlayerNum >= 5 then
				local go=nil
				--代表刷新这个item的头像
				if self.isNowShowState==true and self.isChangeShowState==true then
					if #HallFameCountObjectPool>0 then
						go = HallFameObjectPop(1)
						fun.set_parent(go,self.root)
						fun.set_active(go,true)
					else
				        go = fun.get_instance(self.playerCountItem, self.root);
						fun.set_active(go,true)
					end
				end
				if go then
					go.transform.anchoredPosition = Vector2.New(go.transform.anchoredPosition.x,posY)
					fun.set_active(go,true)
					self:SetPlayerItem(go,self._data.stageList[i].stagePlayerNum)
				end
			else
				if self._data.stageList[i].showPlayers then
					local playerNum = #self._data.stageList[i].showPlayers
					local childCount = fun.get_child_count(self.root)
					for j, player in ipairs(self._data.stageList[i].showPlayers) do
						if playerNum > 1 then
							self:SetOnePlayer(player,posY,24 * (j - 1),childCount,false,j)
						else
							self:SetOnePlayer(player,posY,24 * (j - 1),childCount,true,j)
						end
					end
				end	
			end		
		end	
	end
	self.isNowShowState = true
end

--计算段位与第一个阶段奖励之间item显示的位置
function HallofFameArriveFullItem:CalculatePos()
	local ratio = self._stageRratios[#self._stageRratios]
	local top = 1 - ratio
	self.downRatio = ratio + (top / 4)
	self.upRatio = 1 - (top / 4)
end

--显示第一到第五名
function HallofFameArriveFullItem:ShowFirstStagePlayer()
	if self._data and self._data.topPlayers then
		local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
		if self.downRatio == nil or self.upRatio == nil then
			self:CalculatePos()
		end
		local showNum = 0
		for i = #self._data.topPlayers, 1,-1 do
			if self._data.topPlayers[i].order == 1 then
				local posY = self.upRatio * sliderHeight
				self:SetOnePlayer(self._data.topPlayers[i],posY,0,nil,true,1)
			elseif self._data.topPlayers[i].order >= 2 and self._data.topPlayers[i].order <= 5 then
				showNum = showNum + 1
				local posY = self.downRatio * sliderHeight
				self:SetOnePlayer(self._data.topPlayers[i],posY,24 * (self._data.topPlayers[i].order - 2),false,false,5 - showNum)
			end
		end
	end
end

function HallofFameArriveFullItem:SetOnePlayer(data,posY,posX,childIndex,showName,index)
	local go=nil
	if self.isNowShowState==true and self.isChangeShowState==true then
		if #HallFameHeadObjectPool>0 then
			go = HallFameObjectPop(2)
			fun.set_parent(go,self.root)
			fun.set_active(go,true)
		else
			go = fun.get_instance(self.playerNameItem, self.root);
			fun.set_active(go,true)
		end
	end
	if go then
		if childIndex then
			go.transform:SetSiblingIndex(childIndex)
		end
		if index==1  then
			go.transform.anchoredPosition = Vector2.New(-169.18,posY);
		elseif index==2 then
			go.transform.anchoredPosition = Vector2.New(-193.18,posY);
		elseif index==3 then
			go.transform.anchoredPosition = Vector2.New(-217.18,posY);
		elseif index==4 then
			go.transform.anchoredPosition = Vector2.New(-241.18,posY);
		elseif index==5 then
			go.transform.anchoredPosition = Vector2.New(-265.18,posY);
		end
		local nickname = nil;
		if showName then
			nickname = data.nickname;
			if nickname == "" then
				nickname = Csv.GetData("robot_name",tonumber(data.uid),"name")
			end
		end
		self:SetHeadIcon(data.uid,data.avatar,fun.get_component(go,fun.REFER),nickname);
	end
end

--计算scrollView的垂直滑动值
function HallofFameArriveFullItem:CalculateScrollPercent(startScore)
	local curTiers = ModelList.HallofFameModel:GetTiers()
	local totalHight1 = 320
	for i = 14, 1,-1 do
		if i > curTiers then
			totalHight1 = totalHight1 + 1900
		elseif i == curTiers then
			totalHight1 = totalHight1 + 1920 * 2
		elseif i > self._tiers then
			totalHight1 = totalHight1 + 1800		
		end
	end

	local contentHeight = fun.get_component(self.parent.item_list.content,fun.RECT).rect.height
	local viewportHeight = fun.get_component(self.parent.item_list.viewport,fun.RECT).rect.height
	local diff = contentHeight - viewportHeight

	local totalHight2 = totalHight1
	local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
	local ratio = (startScore - scoreRange[1]) / (scoreRange[2] - scoreRange[1])
	ratio = Mathf.Clamp(ratio,0,1)
	--ratio = ((itemHeight - sliderHeightOffset * 2) * ratio + sliderHeightOffset) / itemHeight
	local diff1 = itemHeight * (1 - ratio)
	if diff1 < 0 then
		diff1 = 0
	end
	totalHight2 = totalHight2 + diff1
	local middlePercent = Mathf.Clamp(1 - (totalHight2 - viewportHeight / 2) / diff,0,1)
	
	return middlePercent
end

function HallofFameArriveFullItem:ShowChangePush()
	local count=fun.get_child_count(self.root)
	if count > 15 then
		for i = 1, count do
			local obj=fun.get_child(self.root,i-1)
			if obj~=nil and obj.name=="playerCountItem(Clone)" then
				HallFameObjectPush(1,obj)
				fun.set_active(obj,false)
				fun.set_parent(obj,self.objParent)
			elseif obj~=nil and obj.name=="playerNameItem(Clone)" then
				local t =  fun.get_component(fun.find_child(obj.gameObject,"nameTxt"),fun.OLDTEXT)
				t.text=""
				HallFameObjectPush(2,obj)
				fun.set_active(obj,false)
				fun.set_parent(obj,self.objParent)
			elseif obj~=nil and obj.name=="stageItemRoot" then
				local stageCount = fun.get_child_count(obj)
				for j=1,stageCount do
					local stageItem=fun.get_child(obj,j-1)
					Destroy(stageItem)
				end
			elseif obj~=nil and obj.name=="stageIEfRoot" then
				local effectCount = fun.get_child_count(obj)
				for z=1,effectCount do
					local effectItem=fun.get_child(obj,z-1)
					if effectItem~=nil and effectItem.name~="headEffect" then
						Destroy(effectItem)
					end
				end
			end
		end
	end
end

function HallofFameArriveFullItem:HasSprintBuff()
	return ModelList.HallofFameModel:HasSprintBuff()
end

return this