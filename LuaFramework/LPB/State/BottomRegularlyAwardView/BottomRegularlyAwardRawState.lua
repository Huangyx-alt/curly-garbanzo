local BottomRegularlyAwardBaseState = require("State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState")
local BottomRegularlyAwardRawState = Clazz(BottomRegularlyAwardBaseState,"BottomRegularlyAwardRawState")

function BottomRegularlyAwardRawState:Change2Mature(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardMatureState")
    end
end

function BottomRegularlyAwardRawState:ChangeDisable(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardDisableState")
    end
end

function BottomRegularlyAwardRawState:ClickRegularlyAward(fsm)
    if fsm then
        fsm:GetOwner():CheckAdvert()
    end
end

function BottomRegularlyAwardRawState:AdBreakOut(fsm)
    if fsm then
        fsm:GetOwner():CheckRemainTime()
    end
end

function BottomRegularlyAwardRawState:OnEnter(fsm)
    fsm:GetOwner():SetRaw()
end

function BottomRegularlyAwardRawState:OnLeave(fsm)
end
return BottomRegularlyAwardRawState