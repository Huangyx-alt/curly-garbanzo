
local TournamentBlackGoldUnlockProgressView = BaseView:New("TournamentBlackGoldUnlockProgressView")
local this = TournamentBlackGoldUnlockProgressView

this.auto_bind_ui_items ={
    "unlockLevel1",
    "unlockLevel2",
    "unlockLevel3",
    "levelMin",
    "levelMax",
    "Slider",
    "bgNormal",
    "bgBlackGold",

}

local minOffsetLevel = 3 -- 相差等级小于等于3 显示一个进度条 大于3显示另外一个

function TournamentBlackGoldUnlockProgressView:Awake(obj)
    self:on_init()
end

function TournamentBlackGoldUnlockProgressView:OnEnable()
    self:InitBg()
    self:InitView()
end

function TournamentBlackGoldUnlockProgressView:OnDisable()
    Event.Brocast(EventName.Event_show_unlock_tournament_unlock_progress_view)
    Facade.RemoveView(self)
end

function TournamentBlackGoldUnlockProgressView:InitBg()
    if ModelList.TournamentModel:CheckIsBlackGoldUser() then
        fun.set_active(self.bgNormal,false)
        fun.set_active(self.bgBlackGold,true)
    else
        fun.set_active(self.bgNormal,true)
        fun.set_active(self.bgBlackGold,false)
    end
end

function TournamentBlackGoldUnlockProgressView:InitView()
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

    LuaTimer:SetDelayFunction(3, function()
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
end

return this