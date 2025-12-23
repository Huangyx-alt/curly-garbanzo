
MakeFoodKitchenEnterState = Clazz(BaseMakeFoodKitchenState,"MakeFoodKitchenEnterState")

function MakeFoodKitchenEnterState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodKitchenEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function MakeFoodKitchenEnterState:OnLeave(fsm)

end

function MakeFoodKitchenEnterState:Accomplish(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodKitchenOriginalState")
    end
end