local Base = require("View.GiftPack.GiftPackTournamentSprintBaseView")
local GiftPackTournamentSprint01View = Base:New("GiftPackTournamentSprint01View", "GiftPackTournamentSprintAtlas")
local this = GiftPackTournamentSprint01View

function GiftPackTournamentSprint01View:OnEnable()
    Base.OnEnable(self)
    UISound.play("sale_weekly3")
end

function GiftPackTournamentSprint01View:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then
        return
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackTournamentSprint01View)
    ModelList.GiftPackModel:CloseView()
end


return this