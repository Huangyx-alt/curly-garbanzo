
local QuickTaskDetailItem = BaseView:New("QuickTaskDetailItem")
local this = QuickTaskDetailItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_step",
    "img_lock",
    "img_hook",
    "img_reward",
    "text_step",
    "text_reward"
}

function QuickTaskDetailItem:New(taskdata,step)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._taskdata = taskdata
    o._step = step
    return o
end

function QuickTaskDetailItem:Awake()
    self:on_init()
end

function QuickTaskDetailItem:OnEnable()
    if self._taskdata then
        local rewardIcon = self._taskdata.reward_icon[1]
        Cache.load_sprite(AssetList[rewardIcon],rewardIcon,function(tex)
            if tex then
                self.img_reward.texture = tex.texture
            end
        end)
        self.text_step.text = tostring(self._step)
        self.text_reward.text = fun.NumInsertComma(self._taskdata.reward[1][2]) --tostring(self._taskdata.reward[1][2])
        local quickTask = ModelList.ActivityModel:GetQuickTaskActive()
        if quickTask then
            if self._taskdata.id < quickTask.id then
                --Cache.SetImageSprite("QuickTaskPromotedAtlas","xianGreenDi",self.img_step)
                fun.set_active(self.img_lock,false,false)
                fun.set_active(self.img_reward,false,false)
                fun.set_active(self.text_reward,false,false)
                fun.set_active(self.img_hook,true,false)
            elseif self._taskdata.id == quickTask.id then
                Cache.SetImageSprite("QuickTaskPromotedAtlas","xianpurpleDi",self.img_step)
                fun.set_active(self.img_lock,false,false)
            else
                Cache.SetImageSprite("QuickTaskPromotedAtlas","xianpurpleDiAn",self.img_step)
            end
        end
    end
end

function QuickTaskDetailItem:OnDisable()
    self._taskdata = nil
    self._step = nil
end

return this