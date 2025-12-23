
BaseMakeFoodRestaurantState = Clazz(BaseFsmState,"BaseMakeFoodRestaurantState")

function BaseMakeFoodRestaurantState:Enter(fsm)
end

function BaseMakeFoodRestaurantState:Accomplish(fsm)
end

function BaseMakeFoodRestaurantState:Exit(fsm)
end

function BaseMakeFoodRestaurantState:OnChangeCuisinesItem(fsm,cuisine_id)
    if fsm then
        fsm:GetOwner():ChangeCuisineToggle(cuisine_id)
    end
end

function BaseMakeFoodRestaurantState:MakeFood(fsm)
end

function BaseMakeFoodRestaurantState:ClaimTopReward(fsm,rewards)
end