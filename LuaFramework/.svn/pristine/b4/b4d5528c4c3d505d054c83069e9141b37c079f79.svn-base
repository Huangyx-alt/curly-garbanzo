
MakeFoodProductExitState = Clazz(BaseMakeFoodProductState,"MakeFoodProductExitState")

function MakeFoodProductExitState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodProductExitState:OnEnter(fsm)
    fsm:GetOwner():PlayExit()
end

function MakeFoodProductExitState:OnLeave(fsm)
end