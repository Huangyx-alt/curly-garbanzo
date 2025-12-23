
require "Sequence/BaseSequenceExecute"

OpenBoxSequence = BaseSequenceExecute:New()

function OpenBoxSequence:GetStepList()
    return {
        OpenBoxStolenStep:New(),
        OpenBoxCheckJackpotStep:New(),
        OpenBoxCheckTopRewardStep:New(),
        OpenBoxFlyRewardStep:New(),
        OpenBoxNextLayerStep:New(),
        OpenBoxShowTipsStep:New(),
        OpenBoxResetLayerStep:New()
    }
end