local PuzzleBaseState = require("State.PuzzleView.PuzzleBaseState")
local PuzzleDisabledState = Clazz(PuzzleBaseState,"PuzzleDisabledState")

function PuzzleDisabledState:OnEnter(fsm,previous,...)
    --log.r("==============================>>PuzzleDisabledState")
    fsm:GetOwner():SetDisable(...)
    fsm:GetOwner():ShowOrHide(true)
end

function PuzzleDisabledState:OnLeave(fsm)

end

function PuzzleDisabledState:Goback(callback)
    if callback then
        callback()
    end
end

function PuzzleDisabledState:OpenShopView(fsm)
    if fsm then
        fsm:GetOwner():OnOpenShopView()
    end
end
return PuzzleDisabledState