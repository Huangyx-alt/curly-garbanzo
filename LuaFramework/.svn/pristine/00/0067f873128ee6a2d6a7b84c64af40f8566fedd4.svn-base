local BottomRegularlyAwardBaseState = require("State/BottomRegularlyAwardView/BottomRegularlyAwardBaseState")
local BottomRegularlyAwardDisableState = Clazz(BottomRegularlyAwardBaseState,"BottomRegularlyAwardDisableState")

function BottomRegularlyAwardDisableState:OnEnter(fsm)
    fsm:GetOwner():SetDisable()
end

function BottomRegularlyAwardDisableState:OnLeave(fsm)

end

function BottomRegularlyAwardDisableState:Change2Raw(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardRawState")
    end
end

function BottomRegularlyAwardDisableState:Change2Mature(fsm)
    if fsm then
        self:ChangeState(fsm,"BottomRegularlyAwardMatureState")
    end
end

function BottomRegularlyAwardDisableState:CheckAd(fsm)
    if fsm then
        if fsm:GetOwner():IsAbleWatchAd() then
            self:Change2Raw(fsm)
        end
    end
end
return BottomRegularlyAwardDisableState