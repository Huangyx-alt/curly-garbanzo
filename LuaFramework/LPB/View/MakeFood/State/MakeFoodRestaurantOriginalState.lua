
MakeFoodRestaurantOriginalState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodRestaurantOriginalState")

function MakeFoodRestaurantOriginalState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodRestaurantOriginalState:OnEnter(fsm)

end

function MakeFoodRestaurantOriginalState:OnLeave(fsm)

end

function MakeFoodRestaurantOriginalState:Enter(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodRestaurantEnterState")
    end
end

function MakeFoodRestaurantOriginalState:Exit(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodRestaurantExitState")
    end
end

function MakeFoodRestaurantOriginalState:OnChangeCuisinesItem(fsm,cuisine_id)
    if fsm then
        self:ChangeState(fsm,"MakeFoodChangeCuisinesState",cuisine_id)
    end
end

function MakeFoodRestaurantOriginalState:MakeFood(fsm)
    if fsm then
        self:ChangeState(fsm,"MakeFoodRestaurantProductState")
    end
end

function MakeFoodRestaurantOriginalState:ClaimTopReward(fsm,rewards)
    if fsm then
        self:ChangeState(fsm,"MakeFoodRestaurantCityRewardState",rewards)
    end
end