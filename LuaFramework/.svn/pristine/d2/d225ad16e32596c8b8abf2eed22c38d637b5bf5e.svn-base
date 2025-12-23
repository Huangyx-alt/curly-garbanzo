local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleAvailableState = Clazz(PuzzleBaseState,"PuzzleAvailableState")

function PuzzleAvailableState:OnEnter(fsm,previous,...)
    fsm:GetOwner():SetAvailable(...)
    fsm:GetOwner():ShowOrHide(true)
    --log.r("==============================>>PuzzleAvailableState")
end

function PuzzleAvailableState:OnLeave(fsm)

end

function PuzzleAvailableState:AddPieces(fsm)
    if fsm then
        self:ChangeState(fsm,"PuzzleAddPiecesState")
    end
end

function PuzzleAvailableState:Goback(callback)
    if callback then
        callback()
    end
end

function PuzzleAvailableState:OpenShopView(fsm)
    if fsm then
        fsm:GetOwner():OnOpenShopView()
    end
end
return PuzzleAvailableState