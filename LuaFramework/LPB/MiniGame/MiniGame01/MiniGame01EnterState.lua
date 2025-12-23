
MiniGame01EnterState = Clazz(MiniGame01BaseState,"MiniGame01EnterState")

local enterCount = nil

function MiniGame01EnterState:OnEnter(fsm,previous,...)
    fsm:GetOwner():PlayEnterAction()
    enterCount = 0
end

function MiniGame01EnterState:OnLeave(fsm)
    enterCount = nil
end

function MiniGame01EnterState:ResphoneLayerInfo(fsm)
    if fsm then
        fsm:GetOwner():SetLayerInfo()
        self:EnterFinish(fsm)
    end
end

function MiniGame01EnterState:EnterFinish(fsm)
    if fsm then
        enterCount = enterCount or 0
        enterCount = enterCount + 1
        if enterCount > 1 then
            fsm:GetOwner():PlayStageEnterAction(fsm)
        end
    end
end

function MiniGame01EnterState:GetReady(fsm)
    self:ChangeState(fsm,"MiniGame01OriginalState")
end

function MiniGame01EnterState:EnterFinish2Original(fsm)
    if fsm then
        self:ChangeState(fsm,"MiniGame01OriginalState")
    end
end