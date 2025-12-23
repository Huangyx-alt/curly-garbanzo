BaseSequenceStep = {}

function BaseSequenceStep:New(name)
    local o = {}
    self.__index = self
    o.name = name
    setmetatable(o,self)
    return o
end

function BaseSequenceStep:Init(params)
end

function BaseSequenceStep:EnterCondition()
    return true
end

function BaseSequenceStep:OnEnter(params)
    
end

function BaseSequenceStep:LeaveCondition()
    return true
end

function BaseSequenceStep:OnLeave()
end

function BaseSequenceStep:Update()
end

function BaseSequenceStep:GetNextStep()
    return nil
end

function BaseSequenceStep:IsSequeceFinish()
    return false
end

function BaseSequenceStep:OnFinish()
end

function BaseSequenceStep:GetParams()
end