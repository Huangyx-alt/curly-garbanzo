local HallMainBaseState = require "State/HallMainView/HallMainBaseState"
local HallMainOriginalState = Clazz(HallMainBaseState,"HallMainOriginalState")

function HallMainOriginalState:OnEnter(fsm)
end

function HallMainOriginalState:OnLeave(fsm)
end

function HallMainOriginalState:EnterHallMain(fsm)
    if fsm then
        self:ChangeState(fsm,"HallMainEnterState")
    end
end

function HallMainOriginalState:PlayCardsClick(fsm,cardGenre, checkRes, cb)
    if fsm then
        fsm:GetOwner():DoPlayCardsClick(cardGenre, checkRes, cb)
    end
end

function HallMainOriginalState:GobackClick(fsm,exitType)
    if fsm then
        fsm:GetOwner():DoGobackClick(exitType)
    end
end

function HallMainOriginalState:ShowJackpot(fsm)
    if fsm then
        fsm:GetOwner():OnShowJackpot()
    end
end

function HallMainOriginalState:OnFunctionIconClick(fsm,view,params,...)
    if fsm then
        fsm:GetOwner():OnFunctionIconShowView(view,params,...)
    end
end

function HallMainOriginalState:OnFunctionIconClickSpecial(fsm,view,params)
    if fsm then
        fsm:GetOwner():OnFunctionIconShowViewSpecial(view,params)
    end
end

function HallMainOriginalState:OpenShopView(fsm)
    if  fsm then
        fsm:GetOwner():OnOpenShopView()
    end
end

function HallMainOriginalState:LobbyRequestWatchAd(fsm,viewState)
    if SDK then
        if SDK.IsRewardedAdReady() then
            self:RegisterAdEvent()
            if viewState == 1 then
                self.adEvent = AD_EVENTS.AD_EVENTS_HALL_COIN
                SDK.ShowRewardedAd("lobby_coins",AD_EVENTS.AD_EVENTS_HALL_COIN)
            else
                self.adEvent = AD_EVENTS.AD_EVENTS_HALL_DIAMOND
                SDK.ShowRewardedAd("lobby_diamond",AD_EVENTS.AD_EVENTS_HALL_DIAMOND)
            end
        end
    end
end

function HallMainOriginalState:RegisterAdEvent()
    Event.AddListener(Notes.RECEIVE_MAX_REWARD,self.AdCallBack,self)
end

function HallMainOriginalState:RemoveAdEvent()
    Event.RemoveListener(Notes.RECEIVE_MAX_REWARD,self.AdCallBack)
end

function HallMainOriginalState:AdCallBack(adInfo)
    self:RemoveAdEvent()
    if adInfo then
        local ad_id = adInfo.AdUnitIdentifier
        local ad_sp = adInfo.CreativeIdentifier

        --Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward,PopupViewType.show,ClaimRewardViewType.CollectReward,self._taskData.reward,function()
        --    local data = {{taskType = self._taskData.taskType, taskGroup =self._taskData.taskGroup,taskId =self._taskData.taskId,createTime =self._taskData.createTime}}
        --    ModelList.TaskModel.C2S_SubmitTask(data)
        --end)

        ModelList.AdModel:C2S_WathchAdResult(ad_id,ad_sp,ad_id,self.adEvent )
    end
end
return HallMainOriginalState