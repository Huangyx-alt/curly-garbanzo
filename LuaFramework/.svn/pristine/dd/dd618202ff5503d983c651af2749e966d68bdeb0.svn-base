

MakeFoodProductOriginalState = Clazz(BaseMakeFoodProductState,"MakeFoodProductOriginalState")

function MakeFoodProductOriginalState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodProductOriginalState:OnEnter(fsm)
end

function MakeFoodProductOriginalState:OnLeave(fsm)
end

function MakeFoodProductOriginalState:Enter(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodProductEnterState")
    end
end

function MakeFoodProductOriginalState:Exit(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodProductExitState")
    end
end

function MakeFoodProductOriginalState:ClaimReward(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodProductWaitRewardState")
    end
end