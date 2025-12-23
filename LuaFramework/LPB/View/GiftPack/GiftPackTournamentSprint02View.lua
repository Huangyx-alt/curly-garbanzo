local Base = require("View.GiftPack.GiftPackTournamentSprintBaseView")
local GiftPackTournamentSprint02View = Base:New("GiftPackTournamentSprint02View", "GiftPackTournamentSprintAtlas")
local this = GiftPackTournamentSprint02View

function GiftPackTournamentSprint02View:OnEnable()
    Base.OnEnable(self)
    UISound.play("sale_weekly6")
end

function GiftPackTournamentSprint02View:ClosePackView()
    --if self._fsm:GetCurName() == "GiftPackShowState" then
    --    return
    --end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackTournamentSprint02View)
    ModelList.GiftPackModel:CloseView()
end


return this