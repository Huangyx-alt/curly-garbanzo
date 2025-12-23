
MakeFoodRestaurantCityRewardState = Clazz(BaseMakeFoodRestaurantState,"MakeFoodRestaurantCityRewardState")

function MakeFoodRestaurantCityRewardState:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MakeFoodRestaurantCityRewardState:OnEnter(fsm,previous,...)
    fsm:GetOwner():OnEnterClaimTopReward()
end

function MakeFoodRestaurantCityRewardState:OnLeave(fsm)

end

function MakeFoodRestaurantCityRewardState:Accomplish(fsm)
    if fsm then
        --self:ChangeState(fsm,"MakeFoodRestaurantOriginalState")
        if fsm:GetOwner():CheckTopReward() then
            fsm:GetOwner():OnEnterClaimTopReward()
        else
            self:ChangeState(fsm,"MakeFoodRestaurantOriginalState")
        end
    end
end