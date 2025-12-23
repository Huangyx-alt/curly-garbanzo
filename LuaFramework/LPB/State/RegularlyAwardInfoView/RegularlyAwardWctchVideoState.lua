local RegularlyAwardInfoBaseState = require("State/RegularlyAwardInfoView/RegularlyAwardInfoBaseState")
local RegularlyAwardWctchVideoState = Clazz(RegularlyAwardInfoBaseState,"RegularlyAwardWctchVideoState")

function RegularlyAwardWctchVideoState:OnEnter(fsm,previous,...)
    local params = select(1,...)
    if params == 1 then
        fsm:GetOwner():WatchVideo()
    else
        fsm:GetOwner():ClaimMoreRwards()
    end
end

function RegularlyAwardWctchVideoState:OnLeave(fsm)

end

function RegularlyAwardWctchVideoState:CliamRewardRespone(fsm,isExit)
    if fsm then
        if isExit then
            self:ChangeState(fsm,"RegularlyAwardInfoExitState",2,2)
        end
    end
end

function RegularlyAwardWctchVideoState:AdBreakOut(fsm)
    if fsm then
        self:ChangeState(fsm,"RegularlyAwardInfoOriginalState")
    end
end
return RegularlyAwardWctchVideoState