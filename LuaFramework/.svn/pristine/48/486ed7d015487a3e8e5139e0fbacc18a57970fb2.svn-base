require "Sequence/BaseSequenceStep"

BaseSequenceExecute = {}

local cache_params = nil

function BaseSequenceExecute:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function BaseSequenceExecute:Start(params,callback)
    self._callback = callback
    self:CreateSteps(params)
    self:SetNextStep()
    self:StopUpdate()
    self.update_handler = UpdateBeat:CreateListener(xp_call(function()
		self:Update()
	end))
    UpdateBeat:AddListener(self.update_handler)
end

function BaseSequenceExecute:Stop()
    self:StopUpdate()
    if self._callback then
        self._callback()
        self._callback = nil
    end
    self._current_step = nil
    self._queue = nil
    cache_params = nil
end

function BaseSequenceExecute:StopUpdate()
    if self.update_handler then
		UpdateBeat:RemoveListener(self.update_handler)
		self.update_handler = nil
	end
end

function BaseSequenceExecute:GetStepList()
    return {}
end

function BaseSequenceExecute:CreateSteps(params)
    local stepList = self:GetStepList()
    self._queue = Queue:New()
    for index, value in ipairs(stepList) do
        self._queue:push(value)
        value:Init(params)
    end
end

function BaseSequenceExecute:GetCurrentStep()
    return self._current_step
end

function BaseSequenceExecute:SetNextStep()
    if self._current_step then
        local name = self._current_step:GetNextStep()
        self._current_step = nil
        local stepList = self:GetStepList()
        for key, value in pairs(stepList) do
            if value.name == name then
                self._current_step = value
                break
            end
        end
    end
    if self._current_step == nil and self._queue then
        self._current_step = self._queue:pop()
    end
end

function BaseSequenceExecute:Update()
    local step = self:GetCurrentStep()
    if step then
        step:Update()
        if step.state == nil then
            if step:EnterCondition() then
                step.state = 1
                step:OnEnter(cache_params)
            end
        elseif step.state == 1 then
            if step:LeaveCondition() then
                cache_params = step:GetParams()
                step.state = nil
                if step:IsSequeceFinish() then
                    step:OnFinish()
                    self:Stop()
                else
                    self:SetNextStep()
                end
                step:OnLeave()
            end   
        end
    else
        self:Stop()
    end
end