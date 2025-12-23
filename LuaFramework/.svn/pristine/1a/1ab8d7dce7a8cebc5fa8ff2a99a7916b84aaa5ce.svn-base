local VolcanoMissionOpenBoxView = BaseDialogView:New('VolcanoMissionOpenBoxView')
local this = VolcanoMissionOpenBoxView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "Panel1",
    "Panel2",
    "txtNum",
    "btn_open",
    "rewardPanel",
    "rewardItem",
    "row1",
    "row2",
    "btn_continue",
    "anima",
}

function VolcanoMissionOpenBoxView:Awake()

end

function VolcanoMissionOpenBoxView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function VolcanoMissionOpenBoxView:on_after_bind_ref()
    self:InitData()
    self:InitView()
end
function VolcanoMissionOpenBoxView:InitData()
    self.boxData = ModelList.VolcanoMissionModel:GetAllStepBoxData()

    --[[测试数据
    self.boxData = {
        {step = 1, reward = {id = 1, value = 200}},
        {step = 1, reward = {id = 1, value = 2000}},
        {step = 1, reward = {id = 1, value = 20000}},
        -- {step = 1, reward = {id = 1, value = 200}},
        -- {step = 1, reward = {id = 1, value = 200}},
        -- {step = 1, reward = {id = 1, value = 200}},
    }
    --]]
end
 
function VolcanoMissionOpenBoxView:InitView()
    fun.set_active(self.Panel1, true)
    fun.set_active(self.Panel2, false)
    fun.set_active(self.row1, true)
    fun.set_active(self.row2, false)
    fun.set_active(self.rewardItem, false)

    self:InitBoxNum()
    self:InitReward()
end

function VolcanoMissionOpenBoxView:GetBoxNum()
    if self.boxData then
        return #self.boxData
    end

    return 0
end

function VolcanoMissionOpenBoxView:GetRewardNum()
    return self:GetBoxNum()
end

function VolcanoMissionOpenBoxView:GetTotalRewardRowNum()
    if self:GetRewardNum() > 4 then
        return 2
    else
        return 1
    end
end

--两行划分策略
function VolcanoMissionOpenBoxView:GetRewardRowNum(rewardCount, idx)
    if self:GetTotalRewardRowNum() < 2 then
        return 1
    end

    if idx > 4 then
        return 2
    end

    return 1
end

function VolcanoMissionOpenBoxView:InitBoxNum()
    self.txtNum.text = "x" .. self:GetBoxNum()
end

function VolcanoMissionOpenBoxView:InitReward()
    self.rewardItemList = {}
    --fun.clear_all_child(self.rewardPanel)
    fun.clear_all_child(self.row1)
    fun.clear_all_child(self.row2)
    fun.set_active(self.row2, self:GetTotalRewardRowNum() == 2)
    if self.boxData then
        local totalRewardCount = self:GetRewardNum()
        for i, v in ipairs(self.boxData) do
            local row = self:GetRewardRowNum(totalRewardCount, i)
            local item = self:CreateRewardItem(v.reward)
            fun.set_parent(item, self["row" .. row], true)
            local rewardItem = {}
            rewardItem.go = item
            rewardItem.data = v
            table.insert(self.rewardItemList, rewardItem)
        end
    end
end

function VolcanoMissionOpenBoxView:CreateRewardItem(rewardData)
    local go = fun.get_instance(self.rewardItem)
    local ref = fun.get_component(go, fun.REFER)
    local icon = ref:Get("icon")
    local value = ref:Get("value")
    local id = rewardData.id
    local count = rewardData.value
    local iconName = Csv.GetItemOrResource(id, "more_icon")
    icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas", iconName)
    --value.text = fun.format_money(count)
    value.text = fun.format_reward(rewardData)
    fun.set_active(go, true)
    return go
end

function VolcanoMissionOpenBoxView:OnDisable()
    Facade.RemoveViewEnhance(self)
    Facade.SendNotification(NotifyName.VolcanoMission.OpenBoxEnd)
end

function VolcanoMissionOpenBoxView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("VolcanoMissionOpenBoxView:CloseSelf play anima 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "VolcanoMissionOpenBoxView_end"}, false, function() 
                log.log("VolcanoMissionOpenBoxView:CloseSelf play anima 3")
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        log.log("VolcanoMissionOpenBoxView:CloseSelf play anima 1")
        self:DoMutualTask(task)
    else
        log.log("VolcanoMissionOpenBoxView:CloseSelf without anima")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function VolcanoMissionOpenBoxView:on_btn_open_click()
    -- fun.set_active(self.Panel1, false)
    -- fun.set_active(self.Panel2, true)

    fun.play_animator(self.go,"open")
    UISound.play("missionopenchest")
end

function VolcanoMissionOpenBoxView:on_btn_continue_click()
    --Facade.SendNotification(NotifyName.CloseUI,self)
    self:CloseSelf()
end

this.NotifyEnhanceList = {
    -- {notifyName = NotifyName.VolcanoMission.OpenBox, func = this.OnBoxDataRec}, 
}

return this