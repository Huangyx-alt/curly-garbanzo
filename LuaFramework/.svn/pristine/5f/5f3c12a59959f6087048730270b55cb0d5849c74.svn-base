
MakeFoodRestaurantEnterState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodRestaurantEnterState")

function MakeFoodRestaurantEnterState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodRestaurantEnterState:OnEnter(fsm)
    fsm:GetOwner():ChangeCuisineInteractive(false)
    fsm:GetOwner():PlayEnter()
end

function MakeFoodRestaurantEnterState:OnLeave(fsm)
    fsm:GetOwner():CheckTopReward()
end

function MakeFoodRestaurantEnterState:Accomplish(fsm)
    if fsm then
        fsm:GetOwner():ChangeCuisineInteractive(true)
        if fsm:GetOwner():CheckTopReward() then
            self:ChangeState(fsm,"MakeFoodRestaurantCityRewardState")
        else
            self:ChangeState(fsm,"MakeFoodRestaurantOriginalState")
        end
    end
end