local HallofFameArriveItem = require "View/HallofFame/HallofFameArriveItem"
local HallofFameNoArriveItem = HallofFameArriveItem:New()
local this = HallofFameNoArriveItem

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
	"objParent"
}

function HallofFameNoArriveItem:New(isNowShowState,isInitState)
	local o = {}
	self.__index = self
	self.isChangeShowState=true
	self.isNowShowState=isNowShowState and true or false
	self.isInitState=isInitState
	self.initState=true
	setmetatable(o,self)
	return o
end

function HallofFameNoArriveItem:OnDispose()
	self.tierInfoView = nil
	--self.stageItemList = nil
	self.bgIndex = nil
	self.upRatio = nil
	self.downRatio = nil
	self._stageRratios = nil
end

function HallofFameNoArriveItem:SetItem(data,index,startScore,isUpTier,name,curTiers)
	self._data = data
	self.bgIndex = index
	self._tiers = self._data.tier
	self.parentName = name
	self.curTiers = curTiers
	if self._init and self._data then
		
		if self.initState==true then
			self:SetBg();
			
			self:SetItemBg();
			self:SetStageItems();
		 	self.initState=false
		 end
		
		self:SetTierInfo();
		if self._tiers <= (self.curTiers+1) then
			self:ShowFirstStagePlayer();
			self:ShowStagePlayerNum();
		end
		
	end
end

function HallofFameNoArriveItem:SetItemBg()
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

function HallofFameNoArriveItem:SetTierInfo()
	self.tierInfoView = HallofFameTierInfoItem:New()
	self.tierInfoView:SkipLoadShow(self.tierInfoItem)
	self.tierInfoView:SetData(self._data,self.bgIndex)
end

--设置阶段奖励
function HallofFameNoArriveItem:SetStageItems(startScore)
	self.stageItemList = {}
	self._stageRratios = {}
	if self._data then
		local myScore = ModelList.HallofFameModel:GetMayRankScore()
		if startScore then
			myScore = startScore
		end
		local sliderHeight = fun.get_component(self.tierSlider,fun.RECT).rect.height
		local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
		--log.log("HallofFameNoArriveItem SetStageItems scoreRange, self._tiers, ", scoreRange, self._tiers, self._data.stageList)
		local bottomHight = (220 / sliderHeight) * sliderHeight
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
				go.transform.anchoredPosition = Vector2.New(go.transform.anchoredPosition.x,hight)
				fun.set_active(go,true)
				fun.set_parent(go,parent)
				local view = HallofFameStageInfoItem:New()
				view:SkipLoadShow(go.gameObject,true)
				view:SetData(v,self.bgIndex,myScore,ratio)
				table.insert(self.stageItemList,view)
			end		
		end
	end	
end

--显示阶段人数
function HallofFameNoArriveItem:ShowStagePlayerNum()
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
			--if self._tiers <= (self.curTiers + 1) then
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
			--end	
		end
		
	end
	self.isNowShowState = true
end

function HallofFameNoArriveItem:ShowChangePush()
	local count=fun.get_child_count(self.root)
	if count > 14 then
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
			end
		end
	end
end

--计算段位与第一个阶段奖励之间item显示的位置
function HallofFameNoArriveItem:CalculatePos()
	local ratio = self._stageRratios[#self._stageRratios]
	local top = 1 - ratio
	self.downRatio = ratio + (top / 4)
	self.upRatio = 1 - (top / 4)
end

--显示第一到第五名
function HallofFameNoArriveItem:ShowFirstStagePlayer()
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

function HallofFameNoArriveItem:SetOnePlayer(data,posY,posX,childIndex,showName,index,isCurrent)
	local go=nil
	if isCurrent then
		if #HallFameHeadObjectPool>0 then
			go = HallFameObjectPop(2)
			fun.set_parent(go,self.root)
			fun.set_active(go,true)
		else
			go = fun.get_instance(self.playerNameItem, self.root);
			fun.set_active(go,true)
		end
	else
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
	end
	
	
	if go then
		--log.log("go.transform.anchoredPosition.x   ",go.transform.anchoredPosition.x,"   posX    ",posX)
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

return this