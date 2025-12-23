
MakeFoodRestaurantExitState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodRestaurantExitState")

function MakeFoodRestaurantExitState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodRestaurantExitState:OnEnter(fsm)
    fsm:GetOwner():PlayExit()
end

function MakeFoodRestaurantExitState:OnLeave(fsm)
end