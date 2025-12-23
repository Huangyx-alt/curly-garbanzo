
MakeFoodKitchenOriginalState = Clazz(BaseMakeFoodKitchenState,"MakeFoodKitchenOriginalState")

function MakeFoodKitchenOriginalState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodKitchenOriginalState:OnEnter(fsm)

end

function MakeFoodKitchenOriginalState:OnLeave(fsm)

end

function MakeFoodKitchenOriginalState:Enter(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodKitchenEnterState")
    end
end

function MakeFoodKitchenOriginalState:Exit(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodKitchenExitState")
    end
end