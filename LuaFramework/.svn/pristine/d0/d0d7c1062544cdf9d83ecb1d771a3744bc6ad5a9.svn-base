

MakeFoodProductWaitRewardState = Clazz(BaseMakeFoodProductState,"MakeFoodProductWaitRewardState")

function MakeFoodProductWaitRewardState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodProductWaitRewardState:OnEnter(fsm)
    fsm:GetOwner():OnClaimReward()
    self._timer = Invoke(function()
        self:Accomplish(fsm)
    end,3)
end

function MakeFoodProductWaitRewardState:OnLeave(fsm)
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function MakeFoodProductWaitRewardState:OnDispose()
    self:OnLeave(nil)
end

function MakeFoodProductWaitRewardState:Accomplish(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodProductOriginalState")
    end
end