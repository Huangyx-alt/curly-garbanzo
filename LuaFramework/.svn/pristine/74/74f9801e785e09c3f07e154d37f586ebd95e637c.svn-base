local HallofFameCurrentItem = require "View/HallofFame/HallofFameCurrentItem"
local HallofFameGoldItem = HallofFameCurrentItem:New()
local HallofFameTopPlayerItem = require "View/HallofFame/HallofFameTopPlayerItem"
local this = HallofFameGoldItem

this.auto_bind_ui_items = {
	"tierSlider",
	"handleSlide",
	"myScoreItem",
	"myScore",
	"tierTarget",
	"textScore",
	"tierRewards",
	"CommonItem",
	"Content",
	"stageItem",
	"tierInfoItem",
	"playerCountItem",
	"playerNameItem",
	"normalRoot",
	"blackGoldRoot",
	"playerInfoItem_1",
	"playerInfoItem_2",
	"topPlayerRoot",
}

--设置前3名玩家
function HallofFameGoldItem:SetTopPlayer()
	--if self.topPlayers == nil then
		--self.topPlayers = {}
	--end
	
	if self._data and self._data.stageInfo and self._data.stageInfo.topPlayers then
		local topPlayers = self._data.stageInfo.topPlayers
		for i, v in ipairs(topPlayers) do
			local item = self.topPlayerRoot:Get("playerItem_" .. i)
			HallofFameTopPlayerItem:SetItem(item,v)
			
			--table.insert(self.topPlayer,HallofFameTopPlayerItem)
		end
	end
end

--设置普通item
function HallofFameGoldItem:SetNormalItem()
	fun.set_active(self.blackGoldRoot,false)
	fun.set_active(self.normalRoot,true)
	self:SetStageItems()
	self:SetMyInfo()
	self:SetStagePlayerNum()
	self:SetStagePlayer()
end

--设置黑金段位
function HallofFameGoldItem:SetBlackGoldItem()
	fun.set_active(self.blackGoldRoot,true)
	fun.set_active(self.normalRoot,false)
	
	local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._tiers)
	if self._data and self._data.stageInfo and self._data.stageInfo.stageList then
		local stageList = self._data.stageInfo.stageList
		for i, playerInfo in ipairs(stageList[1].showPlayers) do
			local ratio = (playerInfo.score - scoreRange[1]) / (scoreRange[2] - scoreRange[1])
			ratio = Mathf.Clamp(ratio,0,1)
			local sliderHeight = fun.get_component(self.blackGoldRoot:Get("tierSlider"),fun.RECT).rect.height
			local hight = ratio * sliderHeight
			
			local go = nil
			if i % 2 == 1 then
				go = fun.get_instance(self.playerInfoItem_1, self.go)
			else
				go = fun.get_instance(self.playerInfoItem_2, self.go)
			end
			go.transform.anchoredPosition = Vector2.New(go.transform.anchoredPosition.x,hight)
			fun.set_active(go,true)

			--设置数据
			self:SetPlayer(go,playerInfo)
		end
	end	
end

--设置玩家item
function HallofFameGoldItem:SetPlayer(item,playerInfo)
	local refItem = fun.get_component(item , fun.REFER)
	local userName = refItem:Get("userName")
	local txt = refItem:Get("txt")
	local imgHead = refItem:Get("imgHead")
	local imageFrame = refItem:Get("imageFrame")
	
	local myUid = ModelList.PlayerInfoModel:GetUid()
	local model = ModelList.PlayerInfoSysModel
	if myUid == tonumber(playerInfo.uid) then
		model:LoadOwnHeadSprite(imgHead)
		model:LoadOwnFrameSprite(imageFrame)
		--特殊显示
	else
		local useAvatarName = model:GetCheckAvatar(playerInfo.avatar , playerInfo.uid)
		model:LoadTargetHeadSpriteByName(useAvatarName ,imgHead)
		local useFrameName = model:GetCheckFrame(playerInfo.frame , playerInfo.uid)
		model:LoadTargetFrameSpriteByName(useFrameName , imageFrame)
	end
	
	txt.text = fun.formatNum(playerInfo.score) or 0
	userName.text = playerInfo.nickname
end

return this