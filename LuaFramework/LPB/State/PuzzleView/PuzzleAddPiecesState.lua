local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleAddPiecesState = Clazz(PuzzleBaseState,"PuzzleAddPiecesState")

function PuzzleAddPiecesState:OnEnter(fsm)
    fsm:GetOwner():OnAddPieces()
    self.Timer = Invoke(function()
        self:AddPiecesResult(fsm)
    end,10)
end

function PuzzleAddPiecesState:OnLeave(fsm)
    self:ServerRespone()
end

function PuzzleAddPiecesState:ServerRespone()
    if self.Timer then
        self.Timer:Stop()
        self.Timer = nil
    end
end

function PuzzleAddPiecesState:AddPiecesResult(fsm)
    if fsm then
        fsm:GetOwner():CheckPuzzleProgress()
        --fsm:GetOwner():CheckState()
    end
end
return PuzzleAddPiecesState