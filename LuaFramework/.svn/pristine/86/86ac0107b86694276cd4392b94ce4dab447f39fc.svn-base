local QuickTaskBaseState = require "State/QuickTaskView/QuickTaskBaseState"
local QuickTaskClaimAwardsState = Clazz(QuickTaskBaseState,"QuickTaskClaimAwardsState")

local Input = nil
local KeyCode = nil

function QuickTaskClaimAwardsState:OnEnter(fsm)
    log.r("enter  QuickTaskClaimAwardsState")
    self._fsm = fsm
    self.isClick = false
    Input = UnityEngine.Input
    KeyCode = UnityEngine.KeyCode
    self:start_x_update()
end

function QuickTaskClaimAwardsState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    Input = nil
    KeyCode = nil
    self._fsm = nil
    self.isClick = nil
end

function QuickTaskClaimAwardsState:Dispose()
    self:OnLeave(nil)
end

function QuickTaskClaimAwardsState:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        if not self.isClick then
            self.isClick = true
            self._fsm:GetOwner():DoClaimAward()
            self._timer = Invoke(function()
                self:ServerNoResponse()    
            end,5)
        end
    end
end

function QuickTaskClaimAwardsState:ServerNoResponse()
    --Facade.SendNotification(NotifyName.Common.CommonTip, LangManager.GetTxt("Commond/ServerNoRespond"))
    --Facade.SendNotification(NotifyName.Common.PopupDialog, 8012, 1);
    self.isClick = false
    --UIUtil.show_common_popup(8012,true)
end

function QuickTaskClaimAwardsState:ClaimRewardResult(fsm)
    self:ChangeState(self._fsm,"QuickTaskAchieveState",1)
end

return QuickTaskClaimAwardsState