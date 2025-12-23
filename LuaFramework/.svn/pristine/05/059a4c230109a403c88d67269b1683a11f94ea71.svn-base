local BottomRegularlyAwardBaseState = require("State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState")
local BottomRegularlyAwardMatureState = Clazz(BottomRegularlyAwardBaseState,"BottomRegularlyAwardMatureState")

function BottomRegularlyAwardMatureState:Change2Raw(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardRawState")
    end
end

function BottomRegularlyAwardMatureState:ChangeDisable(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardDisableState")
    end
end

function BottomRegularlyAwardMatureState:ClickRegularlyAward(fsm)
    if fsm then
        fsm:GetOwner():ShowAwardView()
    end
end

function BottomRegularlyAwardMatureState:OnEnter(fsm)
    fsm:GetOwner():SetMature()
end

function BottomRegularlyAwardMatureState:OnLeave(fsm)
end
return BottomRegularlyAwardMatureState