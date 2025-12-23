
--周榜未解锁状态
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local HallCityTournamentLockBannerItem = HallCityBannerItem:New("HallCityTournamentLockBannerItem","TournamentTrueGoldBannerAtlas")
local this = HallCityTournamentLockBannerItem

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
    "unlockLevel1",
    "unlockLevel2",
    "unlockLevel3",
    "levelMin",
    "levelMax",
    "Slider",

}

local minOffsetLevel = 3 -- 相差等级小于等于3 显示一个进度条 大于3显示另外一个

function HallCityTournamentLockBannerItem:OnEnable()
    self:InitTime()
    self:InitView()
end

function HallCityTournamentLockBannerItem:InitView()
    local unlockLv =  ModelList.TournamentModel:GetUnlockTournamentLv()
    local myLevel = ModelList.PlayerInfoModel:GetLevel()
    local offsetLevel = unlockLv - myLevel
    if offsetLevel > minOffsetLevel then
        --展示单个进度条
        fun.set_active(self.levelMin, false)
        fun.set_active(self.levelMax, true)
        self.Slider.value = myLevel / unlockLv
    else
        --展示分段进度条
        fun.set_active(self.levelMin, true)
        fun.set_active(self.levelMax, false)
        for i = 1 , offsetLevel do
            local slider = self["unlockLevel" .. i]
            fun.set_active(slider , false)
        end
    end
end

function HallCityTournamentLockBannerItem:GetLeftTime()
    return ModelList.TournamentModel:GetRemainTime()
end

function HallCityTournamentLockBannerItem:FinishEndTime()
    Event.Brocast(NotifyName.HallCityBanner.RemoveBannerItem, self.bannerId)
end

function HallCityTournamentLockBannerItem:HitBannerFunc()
end


return this