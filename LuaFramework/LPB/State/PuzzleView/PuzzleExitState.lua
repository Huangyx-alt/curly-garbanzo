local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleExitState = Clazz(PuzzleBaseState,"PuzzleExitState")

function PuzzleExitState:OnEnter(fsm)
    fsm:GetOwner():PlayExit()
end

function PuzzleExitState:OnLeave(fsm)

end
return  PuzzleExitState