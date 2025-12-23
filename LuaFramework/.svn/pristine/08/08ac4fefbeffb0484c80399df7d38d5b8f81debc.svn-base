local MainShopBaseState = require("View/PeripheralSystem/MainShopView/State/MainShopBaseState")
local  MainShopDailyRewardState = Clazz(MainShopBaseState,"MainShopDailyRewardState")

function MainShopDailyRewardState:OnEnter(fsm,previous ,dailyReward)
    --fsm:GetOwner():ShopTypeView()
    log.log("请求领取商店每日奖励 OnEnter" , dailyReward)
    ModelList.PlayerInfoModel:ReqDailyReward(dailyReward)
end

function MainShopDailyRewardState:OnLeave(fsm)
end

function MainShopDailyRewardState:OnClickDailyFreeRewardRespone(fsm)
    fsm:GetOwner():SendDailyReward()
    self:ChangeState(fsm,"MainShopIdleState")
end
--
--function MainShopDailyRewardState:OnShopTypeFinish(fsm,isSuccess)
--    --self:ChangeState(fsm,"MainShopDailyRewardState")
--    --if ModelList.MainShopModel:CheckMainShopDataExist(shopType) then
--    --
--    --else
--    --    self:ChangeState(fsm,"MainShopDailyRewardState")
--    --end
--end

return MainShopDailyRewardState