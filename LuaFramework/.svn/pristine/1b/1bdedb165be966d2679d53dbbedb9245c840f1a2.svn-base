
local TopQuickTaskExtraTipView = BaseView:New("TopQuickTaskExtraTipView")
local this = TopQuickTaskExtraTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

local Input = UnityEngine.Input
local KeyCode = UnityEngine.KeyCode

local time_interval = nil

this.auto_bind_ui_items = {
    "img_reward",
    "text_addbonus",
    "text_countdown"
}

function TopQuickTaskExtraTipView:Awake()
    self:on_init()
end

function TopQuickTaskExtraTipView:OnEnable(params)
    if params then
        local pos = params.pos
        fun.set_gameobject_pos(self.go,pos.x,pos.y,pos.z,false)
        pos = self.go.transform.localPosition
        fun.set_gameobject_pos(self.go,pos.x - 35,pos.y - 100,0,true)
    end

    local quickTask = ModelList.CompetitionModel:GetQuickTaskActive()
    if quickTask and quickTask.extraReward then
        local data = Csv.GetData("activity_round",tonumber(quickTask.id))
        local extra_reward =  Csv.GetData("resources",quickTask.extraReward[1].id)
        if extra_reward then
            self.img_reward.sprite = AtlasManager:GetSpriteByName("ItemAtlas",extra_reward.icon)
        end

        --self.extra_leftTime = math.max(0,(quickTask.createTime + ((data.reward_extra[2] or {})[1] or 0)) - os.time())
    end
    
    self.extra_leftTime = params.time

    self.update_x_enabled = true
    self:start_x_update()

    local currHallView = GetCurHallView()
    if currHallView and currHallView._hallFunction  and currHallView._hallFunction._topCompetition then
        currHallView._hallFunction._topCompetition:RefreshExtraRewardTime()
    elseif HallCityView and HallCityView:GetCompetitionView() then
        HallCityView:GetCompetitionView():RefreshExtraRewardTime()
    end
end

function TopQuickTaskExtraTipView:OnDisable()
    time_interval = nil
    self.extra_leftTime = nil
end

function TopQuickTaskExtraTipView:on_x_update()
    if Input and Input.GetKeyUp(KeyCode.Mouse0) then
        Facade.SendNotification(NotifyName.CloseUI,self)
    end
end

function TopQuickTaskExtraTipView:setTime(time)
    if self and fun.is_not_null(self.extra_leftTime) then
        self.text_countdown.text = fun.format_time(time)
    end
end

return this