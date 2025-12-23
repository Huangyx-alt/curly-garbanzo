
WatchADUtility = {}
local this = WatchADUtility

function WatchADUtility:New(adEvent,adType)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._adEvent = adEvent
    o._adType = adType
    return o
end

function WatchADUtility:ChangeAdEvent(adEvent)
    self._adEvent = adEvent
end

function WatchADUtility:IsAdCountAvailable(adEvent)
    return ModelList.AdModel.GetAdCount(adEvent or self._adEvent) > 0
end

function WatchADUtility:IsAbleWatchAd(adEvent)
    local ad_num = ModelList.AdModel.GetAdCount(adEvent or self._adEvent)
    local ad_ready = SDK.IsRewardedAdReady()
    if ad_num > 0 and ad_ready then
        return true
    end
    return false
end

function WatchADUtility:IsAbleWatchAdCount(adEvent)
    local ad_num = ModelList.AdModel.GetAdCount(adEvent or self._adEvent)
    if ad_num > 0 then
        return true
    end
    return false
end


function WatchADUtility:WatchVideo(owner,callback, event_report,params)
    self._callback = callback
    self._params = params
    self._owner = owner
    self:RegisterAdEvent()
    SDK.ShowRewardedAd(event_report or "WatchAd",self._adEvent)
end

function WatchADUtility:AdCompleteCallBack(adInfo)
    self:RemoveAdEvent()
    if adInfo then
        local ad_id = adInfo.AdUnitIdentifier
        local ad_sp = adInfo.CreativeIdentifier
        local params = self._params
        if self._params and type(self._params) == "table" then
            local json = require "cjson"
            params = json.encode(self._params)
        end
        ModelList.AdModel:C2S_WathchAdResult(ad_id,ad_sp,ad_id, self._adEvent,self._adType or AD_TYPE.AD_TYPE_ENCOURAGE,params)
        if self._callback then
            self._callback(self._owner,false)
            self._callback = nil
            self._owner = nil
        end
    end
end

function WatchADUtility:AdBreakCallBack()
    if self._callback then
        self._callback(self._owner,true)
        self._callback = nil
        self._owner = nil
    end
end

function WatchADUtility:RegisterAdEvent()
    Event.AddListener(Notes.RECEIVE_MAX_REWARD,self.AdCompleteCallBack,self)
    Event.AddListener(Notes.RECEIVE_MAX_REWARD_ADMISS,self.AdBreakCallBack,self)
end

function WatchADUtility:RemoveAdEvent()
    Event.RemoveListener(Notes.RECEIVE_MAX_REWARD,self.AdCompleteCallBack,self)
    Event.RemoveListener(Notes.RECEIVE_MAX_REWARD_ADMISS,self.AdBreakCallBack,self)
end