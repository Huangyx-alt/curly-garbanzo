
local PowerUpBaseState = require "State.PowerUpView.PowerUpBaseState"
local PowerUpClickState = Clazz(PowerUpBaseState,"PowerUpClickState")

function PowerUpClickState:OnEnter(fsm, previous, ...)
    local params1 = ({ ... })[1]
    local params2 = ({ ... })[2]
  
    if params1 == 1 then
        fsm:GetOwner():OnCloseView()
    elseif params1 == 2 then
        fsm:GetOwner():OnPlay()
    elseif params1 == 3 then
        fsm:GetOwner():OnTurnPage(params2)
    elseif params1 == 4 then
        fsm:GetOwner():OnClickDrawCard(params2)
    end
    self:StopTimer()
    self._timer = Invoke(function()
        --Facade.SendNotification(NotifyName.Common.CommonTip, LangManager.GetTxt("Commond/ServerNoRespond"))
        --Facade.SendNotification(NotifyName.Common.PopupDialog, 8012, 1);
        --UIUtil.show_common_popup(8012,true)
        self:Change2Primitive(fsm)
    end,8)
end

function PowerUpClickState:StopTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function PowerUpClickState:DrawCard(fsm,waitCount)
    if fsm then
        self:StopTimer()
        self:ChangeState(fsm,"PowerUpDrawCardState",waitCount)
    end
end

function PowerUpClickState:FinishClick(fsm)
    if fsm then
        self:Change2Primitive(fsm)
    end
end

function PowerUpClickState:FinishShowHand(fsm)
    if fsm then
        self:Change2Primitive(fsm)
    end
end

function PowerUpClickState:GoBackPowerUp(fsm)
    if fsm then
        self:Change2Primitive(fsm)
    end
end

function PowerUpClickState:SendMsg2Server2EnterGame(fsm)
    if fsm then
        fsm:GetOwner():SendMsg2Server2EnterGame()
    end
end

function PowerUpClickState:Change2Primitive(fsm)
    self:ChangeState(fsm,"PowerUpPrimitiveState")
end

function PowerUpClickState:OnLeave(fsm)
    self:StopTimer()
end

function PowerUpClickState:Dispose()
    self:OnLeave(nil)
end

return PowerUpClickState