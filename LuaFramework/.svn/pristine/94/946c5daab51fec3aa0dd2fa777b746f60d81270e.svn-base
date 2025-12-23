--活动选择界面
local CarQuestConst = require "View/CarQuest/CarQuestConst"
local ActivitesChoiceView = BaseDialogView:New('ActivitesChoiceView')
local this = ActivitesChoiceView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)
--this.isCleanRes = true
local anniversaryBuff = require "View/Anniversary/AnniversaryBuff"

this.auto_bind_ui_items = {
    "btn_claimCompetition",
    "btn_claimCar",
    "anima",
    "btn_claimCarLock",
    "btn_claimCompetitionLock",
    "btn_CompetitionHelp",
    "btn_CarHelp",
    ------------buff---------------
    "carbuffParent",
    "carBuff",
    "CompetitionbuffParent",
    "competitionBuff"
}
local clickInterval = 1

function ActivitesChoiceView:Awake()

    self.productIdParam = nil
    self.payType = nil
end

function ActivitesChoiceView:OnEnable()
    ModelList.GiftPackModel:ClearCupCompetionCD()
    Facade.RegisterView(self)

    self.btnClaimCarLastClickTime = 0
    self.isClosing = false
end

function ActivitesChoiceView:on_after_bind_ref()
    -- 需要判断竞赛是否开启
    -- 满足条件等
    local data = ModelList.CompetitionModel:GetPlayerOptions()
    --local selfLevel = ModelList.PlayerInfoModel:GetLv()
    local IsAnniversary  = ModelList.FixedActivityModel:IsAnniversary()
    --local needLevel = 0 -- Csv.GetLevelOpenByType(19,0)
    --local myLabel = ModelList.PlayerInfoModel:GetUserType()
    --if myLabel and myLabel > 0 then
    --    needLevel = Csv.GetData("level_open",29,"pay_openlevel")
    --else
    --    needLevel = Csv.GetData("level_open",29,"openlevel")
    --end

    if true then
        --if selfLevel < needLevel then
        --    fun.set_active(self.btn_claimCarLock,true)
        --    fun.set_active(self.btn_claimCar,false)
        --
        --    local text = fun.find_child(self.btn_claimCarLock,"Text")
        --    local txt = fun.get_component(text,fun.TEXT)
        --    txt = "LV."..tostring(v.unlockLevel)
        --else
        --    fun.set_active(self.btn_claimCarLock,false)
        --    fun.set_active(self.btn_claimCar,true)
        --end
        fun.set_active(self.btn_claimCarLock,false)
        fun.set_active(self.btn_claimCar,true)
        local isShowAnniversaryBuff = false
        local v = {  {id = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF, value = ModelList.CarQuestModel:GetMoreItemBuffTime()},
                     {id = RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_REWARD_BUFF, value = ModelList.CarQuestModel:GetMoreRewardBuffTime()}
        }

        for _,vv in pairs( v ) do
            if vv.value >0 then
                if IsAnniversary and vv.id == RESOURCE_TYPE.RESOURCE_TYPE_RACING_CAR_MORE_OIL_BUFF then
                    anniversaryBuff:CheckAnniversaryBuff(self.carBuff.transform.parent,nil,2)
                    isShowAnniversaryBuff = true
                else
                    local buffitem = fun.get_instance(self.carBuff,self.carbuffParent)
                    self:SetBuffData(buffitem,vv)
                end
            end
        end
        if IsAnniversary and not isShowAnniversaryBuff then
            anniversaryBuff:CheckAnniversaryBuff(self.carBuff.transform.parent,nil,2)
        end
    elseif v.id == COMPETITION_TYPE.COMPETITION_CUP then
        fun.set_active(self.btn_claimCompetitionLock,false)
        fun.set_active(self.btn_claimCompetition,true)
        local isShowAnniversaryBuff = false
        for _,vv in pairs( v.leftBuff ) do
            if vv.value >0 then
                if IsAnniversary and vv.id == RESOURCE_TYPE.RESOURCE_TYPE_DOUBLE_COMPETITION then
                    anniversaryBuff:CheckAnniversaryBuff(self.competitionBuff.transform.parent,nil,1)
                    isShowAnniversaryBuff = true
                else
                    local buffitem = fun.get_instance(self.competitionBuff,self.CompetitionbuffParent)
                    self:SetBuffData(buffitem,vv)
                end
            end
        end
        if IsAnniversary and not isShowAnniversaryBuff then
            anniversaryBuff:CheckAnniversaryBuff(self.competitionBuff.transform.parent,nil,1)
        end
    end



    for _,v in pairs(data)do

    end

    --anniversaryBuff:CheckDuringBuff(self.btn_CompetitionHelp.transform.parent,self.btn_CompetitionHelp,-100,-100,1)
    --anniversaryBuff:CheckDuringBuff(self.btn_CarHelp.transform.parent,self.btn_CarHelp,-100,-100,2)
end

function ActivitesChoiceView:SetBuffData(buffitem,data)
    fun.set_active(buffitem,true)
    local refer = fun.get_component(buffitem,fun.REFER)
    local icon = Csv.GetItemOrResource(data.id)
    local iconImg = refer:Get("icon")
    local Text = refer:Get("Text")
    log.g("icon.icon"..tostring(icon.icon).." data")
    Cache.SetImageSprite("ItemAtlas",icon.icon,iconImg)
    Text.text = fun.SecondToStrFormat2( data.value)

end

function ActivitesChoiceView:OnDisable()
    self.isClosing = false
    Facade.RemoveView(self)
end

function ActivitesChoiceView:CloseSelf(cloeMethod)
    self.isClosing = true
    AnimatorPlayHelper.Play(self.anima, {"end", "ActivitesChoiceViewend"}, false, function()
        if cloeMethod then
            cloeMethod()
        end

        Facade.SendNotification(NotifyName.CloseUI, self)

    end)

end

function ActivitesChoiceView:on_btn_claimCompetition_click()

    ModelList.CompetitionModel.ReqCompetitionChoose(COMPETITION_TYPE.COMPETITION_CUP)

end

function ActivitesChoiceView:on_btn_claimCar_click()
    if self.isClosing then
        log.log("ActivitesChoiceView:on_btn_claimCar_click X view is closing")
        return
    end

    local curTime = os.time()
    if curTime - self.btnClaimCarLastClickTime < clickInterval then
        log.log("ActivitesChoiceView:on_btn_claimCar_click X click too fast")
        return
    end

    self.btnClaimCarLastClickTime = curTime

    --ModelList.CompetitionModel.ReqCompetitionChoose(COMPETITION_TYPE.COMPETITION_RACING)
    ModelList.CarQuestModel.ReqRacingFetch(function(code)
        ---判断是否当日首次
        local isDayFirst = false
        local popDay = fun.read_value("carquest_popday", "")
        local currentDate = os.date("%Y-%m-%d")
        if (popDay == "" or popDay ~= currentDate) then
            isDayFirst = true
        end

        if code == RET.RET_SUCCESS and isDayFirst then
            local Const = require "View/CarQuest/CarQuestConst"
            ViewList.CarQuestMainView:SetEnterMode(Const.EnterMode.afterAlternative)
            local cb = function()
                Event.Brocast(EventName.Event_popup_car_quest_finish)
                log.r("EventName.Event_popup_competition_finish")
            end
            ViewList.CarQuestMainView:SetFinishCb(cb)
            Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestMainView)
            --Event.Brocast(EventName.Event_popup_car_choice_finishFinish)
            this:CloseSelf();
        else
            Event.Brocast(EventName.Event_popup_car_quest_finish)
            this:CloseSelf();
        end
    end,1)

end

function ActivitesChoiceView:on_btn_claimCompetitionLock_click()
    -- local fun = function()
    --     ModelList.CompetitionModel.ReqCompetitionChoose(COMPETITION_TYPE.COMPETITION_RACING)
    -- end 
    -- self:CloseSelf(fun)
end

function ActivitesChoiceView:on_btn_CarHelp_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestHelpView)
end

function ActivitesChoiceView:on_btn_CompetitionHelp_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.CompetitionHelperView)
end

function ActivitesChoiceView:OnActivateGoldenPassPayResult()

    if ModelList.CompetitionModel:GetPlayerChooseId() == COMPETITION_TYPE.COMPETITION_RACING then
        -- 调用赛车zhu'jie
        local cb = function()
            Event.Brocast(EventName.Event_popup_car_quest_finish)
            log.r("EventName.Event_popup_competition_finish")
        end
        this:CloseSelf();

        ViewList.CarQuestMainView:SetEnterMode(CarQuestConst.EnterMode.afterAlternative)
        ViewList.CarQuestMainView:SetFinishCb(cb)
        Facade.SendNotification(NotifyName.ShowUI, ViewList.CarQuestMainView)

    else
        local fun = function()
            log.r("EventName.Event_popup_competition_finish")
            Event.Brocast(EventName.Event_popup_car_quest_finish)
        end
        this:CloseSelf(fun);
    end

end

this.NotifyList = {
    {notifyName = NotifyName.CarQuest.ChoiceActiveResult, func = this.OnActivateGoldenPassPayResult}
}

return this
