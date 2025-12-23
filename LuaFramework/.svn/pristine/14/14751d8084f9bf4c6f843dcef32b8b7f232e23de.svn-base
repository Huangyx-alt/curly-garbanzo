local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local  PuzzleEnterState = Clazz(PuzzleBaseState,"PuzzleEnterState")

function PuzzleEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function PuzzleEnterState:OnLeave(fsm)

end

function PuzzleEnterState:EnterFinish(fsm)
    self:ChangeState(fsm,"PuzzleOriginalState")
end
return PuzzleEnterState