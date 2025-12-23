local Base = require("View.GiftPack.GiftPackTournamentSprintBaseView")
local GiftPackHalloweenView = Base:New("GiftPackHalloweenView", "GiftPackHalloweenViewAtlas")
local this = GiftPackHalloweenView

function GiftPackHalloweenView:OnEnable()
    Base.OnEnable(self)
    UISound.play("sale_halloween")

    local ref = fun.get_component(self.GiftPackTournamentSprintView.gameObject, fun.REFER)
    local spineAni = ref:Get("spine")

    if spineAni then 
        -- 播放动画
        spineAni:SetAnimation("act",nil,false,0)
        spineAni:AddAnimation("idle",nil,true,0)
    end 
end

function GiftPackHalloweenView:ClosePackView()
    if self._fsm:GetCurName() == "GiftPackShowState" then
        return
    end

    self:ClearCountDown()
    Facade.SendNotification(NotifyName.HideUI, ViewList.GiftPackHalloweenView)
    ModelList.GiftPackModel:CloseView()
end


return this