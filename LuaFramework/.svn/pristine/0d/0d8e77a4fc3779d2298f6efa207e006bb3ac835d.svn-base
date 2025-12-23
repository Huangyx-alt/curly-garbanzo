
MakeFoodProductEnterState = Clazz(BaseMakeFoodProductState,"MakeFoodProductEnterState")

function MakeFoodProductEnterState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodProductEnterState:OnEnter(fsm)
    fsm:GetOwner():PlayEnter()
end

function MakeFoodProductEnterState:OnLeave(fsm)
end

function MakeFoodProductEnterState:Accomplish(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodProductOriginalState")
    end
end