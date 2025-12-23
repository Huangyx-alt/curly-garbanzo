
MakeFoodKitchenExitState = Clazz(BaseMakeFoodKitchenState,"MakeFoodKitchenExitState")

function MakeFoodKitchenExitState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodKitchenExitState:OnEnter(fsm)
    fsm:GetOwner():PlayExit()

end

function MakeFoodKitchenExitState:OnLeave(fsm)

end