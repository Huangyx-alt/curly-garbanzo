
local RewardIconValueView = require "View/CommonView/RewardIconValueView"

local RouletteRewardItem = RewardIconValueView:New(nil)
local this = RouletteRewardItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_selected",
    "img_reward",
    "text_value"
}

function RouletteRewardItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._cacheVip = ModelList.PlayerInfoModel:GetVIP()
    return o
end

function RouletteRewardItem:SetMaskTag(isMask)
    self._isMask = isMask
end

function RouletteRewardItem:SetMask()
    fun.set_active(self.img_selected, self._isMask)
end

function RouletteRewardItem:GetRewardId()
    if self._info then
        return self._info[3] or 0
    end
end

function RouletteRewardItem:IsRouletteJackpot()
    if self._info then
        return self._info[3] == 1
    end
end

function RouletteRewardItem:GetRotate2Pos(rotation_z)
    return  rotation_z - (math.max(0,self:GetRewardId() - 1)) * 30
end

function RouletteRewardItem:SetRewardData(reward)
    self._rewardInfo = reward
    self:RefreshVipAddition()
end

function RouletteRewardItem:RefreshVipAddition()
    if self._rewardInfo then
        if self._rewardInfo[1] == Resource.diamon or self._rewardInfo[1] == Resource.coin then
            local myVip = ModelList.PlayerInfoModel:GetVIP()
            if myVip > (self._cacheVip or 0) then
                self._cacheVip = myVip
            end
            local vipInfo = Csv.GetData("vip",self._cacheVip,"roulette")
            self:SetInfo({self._rewardInfo[1],fun.format_bonus_number(math.floor(self._rewardInfo[2] * (vipInfo / 100))),self._rewardInfo[3]})
        else
            self:SetInfo({self._rewardInfo[1],fun.format_bonus_number(self._rewardInfo[2]),self._rewardInfo[3]})    
        end
    end
end

return RouletteRewardItem