local RegularlyAwardInfoBaseState = require("State/RegularlyAwardInfoView/RegularlyAwardInfoBaseState")
local RegularlyAwardInfoExitState = Clazz(RegularlyAwardInfoBaseState,"RegularlyAwardInfoExitState")

function RegularlyAwardInfoExitState:OnEnter(fsm,previous,...)
    local params1, params2 = select(1,...)
    if params1 == 1 then
        fsm:GetOwner():GobackClick()
    elseif params1 == 2 then
        fsm:GetOwner():OnClaimReward(params2)
    end
end

function RegularlyAwardInfoExitState:OnLeave(fsm)

end
return RegularlyAwardInfoExitState