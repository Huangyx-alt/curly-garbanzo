require "Sequence/BaseSequenceExecute"

EnterGameSequence = BaseSequenceExecute:New()

local isResetLayer = nil

function EnterGameSequence:GetStepList()
    return {
        EnterGameStolenStep:New(),
        EnterGamekJackpotStep:New(),
        EnterGameTopRewardStep:New(),
        EnterGameShowTipsStep:New(),
        EnterGameResetLayerStep:New()
    }
end

function EnterGameSequence:SetResetLayer(isReset)
    isResetLayer = isReset
end

function EnterGameSequence:IsResetLayer()
    return isResetLayer
end