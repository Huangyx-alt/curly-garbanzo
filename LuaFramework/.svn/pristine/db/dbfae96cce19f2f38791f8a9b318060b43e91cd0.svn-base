
MakeFoodChangeCuisinesState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodChangeCuisinesState")

function MakeFoodChangeCuisinesState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodChangeCuisinesState:OnEnter(fsm,previous,...)
    fsm:GetOwner():ChangeCuisineInteractive(false)
    fsm:GetOwner():CurrentCuisinesItem(...,true)
end

function MakeFoodChangeCuisinesState:OnLeave(fsm)
end

function MakeFoodChangeCuisinesState:Accomplish(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodRestaurantOriginalState")
        fsm:GetOwner():ChangeCuisineInteractive(true)
    end
end