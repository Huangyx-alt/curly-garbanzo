local BottomRegularlyAwardBaseState = require("State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState")
local BottomRegularlyAwardOriginalState = Clazz(BottomRegularlyAwardBaseState,"BottomRegularlyAwardOriginalState")

function BottomRegularlyAwardOriginalState:OnEnter(fsm)
end

function BottomRegularlyAwardOriginalState:OnLeave(fsm)
    if fsm then
        fsm:GetOwner():SetUnLock()
    end
end

function BottomRegularlyAwardOriginalState:Change2Raw(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardRawState")
    end
end

function BottomRegularlyAwardOriginalState:Change2Mature(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardMatureState")
    end
end

function BottomRegularlyAwardOriginalState:ChangeDisable(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardDisableState")
    end
end
return BottomRegularlyAwardOriginalState