
MakeFoodRestaurantProductState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodRestaurantProductState")

function MakeFoodRestaurantProductState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodRestaurantProductState:OnEnter(fsm)
    fsm:GetOwner():OnGotoMakeFood()
end

function MakeFoodRestaurantProductState:OnLeave(fsm)
end

function MakeFoodRestaurantProductState:Accomplish(fsm)
    if fsm then
        if fsm:GetOwner():CheckTopReward() then
            self:ChangeState(fsm,"MakeFoodRestaurantCityRewardState")
        else
            self:ChangeState(fsm,"MakeFoodRestaurantOriginalState")
        end
    end
end