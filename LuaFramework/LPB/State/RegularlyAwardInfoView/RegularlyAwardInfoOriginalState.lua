local RegularlyAwardInfoBaseState = require("State/RegularlyAwardInfoView/RegularlyAwardInfoBaseState")
local RegularlyAwardInfoOriginalState = Clazz(RegularlyAwardInfoBaseState,"RegularlyAwardInfoOriginalState")

function RegularlyAwardInfoOriginalState:OnEnter(fsm)
    ModelList.GuideModel:OpenUI("RegularlyAwardInfoView")
end

function RegularlyAwardInfoOriginalState:OnLeave(fsm)
end

function RegularlyAwardInfoOriginalState:PlayEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"RegularlyAwardInfoEnterState")
    end
end

function RegularlyAwardInfoOriginalState:GobackClick(fsm)
    if fsm then
        self:ChangeState(fsm,"RegularlyAwardInfoExitState",1)
    end
end

function RegularlyAwardInfoOriginalState:ClaimRewar(fsm,params)
    if fsm then
        self:ChangeState(fsm,"RegularlyClaimRewardState",params)
    end
end

function RegularlyAwardInfoOriginalState:WatchVideo(fsm,params)
    if fsm then
        self:ChangeState(fsm,"RegularlyAwardWctchVideoState",params)
    end
end
return  RegularlyAwardInfoOriginalState