
local DoubleCookiesRewards = Clazz()
local this = DoubleCookiesRewards

function DoubleCookiesRewards:CheckCookiesQuickTask(parent,quickTask)
    self._transformParent = parent
    self._quickTask = quickTask
    Event.AddListener(EventName.Event_Check_Double_Activity,self.CheckDoubleCookiesActive,self)
    self:CheckDoubleCookiesActive()
end

function DoubleCookiesRewards:DisposeCookiesQuickTask()
    self._transformParent = nil
    self._quickTask = nil
    Event.RemoveListener(EventName.Event_Check_Double_Activity,self.CheckDoubleCookiesActive,self)
end

function DoubleCookiesRewards:IsDoubleReward()
    --return ModelList.ActivityModel:IsActivityAvailable(ActivityTypes.doubleCookies)
    return ModelList.ItemModel.getResourceNumByType(RESOURCE_TYPE.RESOURCE_TYPE_DOUBLE_COMPETITION) > os.time()
end

function DoubleCookiesRewards:CheckDoubleCookiesActive()
    --if self:IsDoubleReward() then
    --    if self._effect_go == nil then
    --        Cache.load_prefabs(AssetList["doubleRewardCompetiton"],"doubleRewardCompetiton",function(obj)
    --            if obj then
    --                self._effect_go = fun.get_instance(obj,self._transformParent)
    --                self._effect_go.transform:SetSiblingIndex(1)
    --            end
    --        end)
    --    else
    --        fun.set_active(self._effect_go.transform,true)
    --    end
    --    self._quickTask:SetDoubleRewardSkin(true)
    --elseif self._effect_go then
    --    fun.set_active(self._effect_go.transform,false)
    --    self._quickTask:SetDoubleRewardSkin(false)
    --end
end

function DoubleCookiesRewards:CheckCookiesBetRate(parent)
    self._transformParent = parent
    Event.AddListener(EventName.Event_Check_Double_Activity,self.CheckCookiesBetRateDoubleActive,self)
    self:CheckCookiesBetRateDoubleActive()
end

function DoubleCookiesRewards:DisposeCookiesBetRate()
    self._transformParent = nil
    Event.RemoveListener(EventName.Event_Check_Double_Activity,self.CheckCookiesBetRateDoubleActive,self)
end

function DoubleCookiesRewards:CheckCookiesBetRateDoubleActive()
    if self:IsDoubleReward() then
        if self._effect_go == nil or self._effect_go.transform == nil then
            Cache.load_prefabs(AssetList["doubleRewardBetRate"],"doubleRewardBetRate",function(obj)
                if obj then
                    self._effect_go = fun.get_instance(obj,self._transformParent)
                end
            end)
        else
            fun.set_active(self._effect_go.transform,true)
        end
    elseif self._effect_go then
        fun.set_active(self._effect_go.transform,false)
    end
end

function DoubleCookiesRewards:OnDisable()
    self:DisposeCookiesQuickTask()
    self:DisposeCookiesBetRate()
end

function DoubleCookiesRewards:Dispose()
    self._effect_go = nil
end

return this
