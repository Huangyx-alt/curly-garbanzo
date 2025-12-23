local RegularlyAwardInfoBaseState = require("State/RegularlyAwardInfoView/RegularlyAwardInfoBaseState")
local RegularlyAwardInfoEnterState = Clazz(RegularlyAwardInfoBaseState,"RegularlyAwardInfoEnterState")

function RegularlyAwardInfoEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function RegularlyAwardInfoEnterState:OnLeave(fsm)

end

function RegularlyAwardInfoEnterState:FinishEnter(fsm)
    if fsm then
        self:ChangeState(fsm,"RegularlyAwardInfoOriginalState")
    end
end
return  RegularlyAwardInfoEnterState