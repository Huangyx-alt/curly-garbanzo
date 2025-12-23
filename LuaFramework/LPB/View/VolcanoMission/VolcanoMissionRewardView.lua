local VolcanoMissionRewardView = BaseDialogView:New('VolcanoMissionRewardView')
local this = VolcanoMissionRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "Panel1",
    "btn_continue",
    "txt_desc",
    "selfHead",
    "rewardPanel",
    "playerPanel",
    "rewardItem",
    "playerItem",
    "anima",
}

function VolcanoMissionRewardView:Awake()

end

function VolcanoMissionRewardView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
    UISound.play("missionwin")
end

function VolcanoMissionRewardView:on_after_bind_ref()
    self:InitData()
    self:InitView()
end

function VolcanoMissionRewardView:InitData()
    ---[[
    self.rewardData = nil
    self.npcIds = ViewList.VolcanoMissionMainView:GetLivingNpcId()
    local mapId = ModelList.VolcanoMissionModel:GetMapId() or 1
    local groudId = ModelList.VolcanoMissionModel:GetGroupId() or 1
    
    if Csv.volcano_round then
        for i, v in ipairs(Csv.volcano_round) do
            if v.map == mapId and v.player_group == groudId then
                if v.reward_final and #v.reward_final > 0 and type(v.reward_final[1]) == "table" and #v.reward_final[1] == 2 then
                    self.rewardData = v.reward_final
                    break
                end
            end
        end
    end
    --]]

    --[[测试数据
        self.npcIds = {13662, 42081, 13662, 13662}
        self.rewardData =  {
            [1] = {
                [1] = 2,
                [2] = 10000},
            [2] = {
                [1] = 1,
                [2] = 100}
        }
    --]]
end


function VolcanoMissionRewardView:InitView()
    fun.set_active(self.rewardItem, false)
    fun.set_active(self.playerItem, false)

    self:InitSelfAvatarInfo()
    self:InitOtherAvatarInfo()
    self:InitReward()

    local descId = 8071
    if not self.npcIds or #self.npcIds == 0 then
        fun.set_active(self.txt_desc, false)
    else
        fun.set_active(self.txt_desc, true)
        self.txt_desc.text = string.format(Csv.GetDescription(descId), #self.npcIds)
    end
end

function VolcanoMissionRewardView:InitSelfAvatarInfo()
    local ref = fun.get_component(self.selfHead, fun.REFER)
    local imgHead = ref:Get("imgHead")
    local imageFrame = ref:Get("imageFrame")
    --头像图片
    ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
end

function VolcanoMissionRewardView:InitOtherAvatarInfo()
    fun.clear_all_child(self.playerPanel)
    if self.npcIds then
        for i, id in ipairs(self.npcIds) do
            if i > 3 then --最多显示3个头像
                break
            end

            local go = fun.get_instance(self.playerItem, self.playerPanel)
            fun.set_active(go, true)
            self:SetAvatarInfo(go, id)
        end
    end
end

function VolcanoMissionRewardView:SetAvatarInfo(gameObject, uid)
    local ref = fun.get_component(gameObject, fun.REFER)
    local imgHead = ref:Get("imgHead")
    local imageFrame = ref:Get("imageFrame")

    --头像图片, 玩家名称
    if fun.is_not_null(imgHead) then
        local avatar = fun.get_strNoEmpty(Csv.GetData("robot_name", tonumber(uid), "icon"), "xxl_head01")
        Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
    end
end

function VolcanoMissionRewardView:InitReward()
    self.rewardItemList = {}
    fun.clear_all_child(self.rewardPanel)
    if self.rewardData then
        for i, v in ipairs(self.rewardData) do
            local item = self:CreateRewardItem({id = v[1], value = v[2]})
            fun.set_parent(item, self.rewardPanel, true)
            local rewardItem = {}
            rewardItem.go = item
            rewardItem.data = v
            table.insert(self.rewardItemList, rewardItem)
        end
    end
end

function VolcanoMissionRewardView:CreateRewardItem(rewardData)
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

function VolcanoMissionRewardView:OnDisable()
    Facade.RemoveViewEnhance(self)
    Facade.SendNotification(NotifyName.VolcanoMission.RewardEnd)
end

function VolcanoMissionRewardView:CloseSelf()
    if fun.is_not_null(self.anima) then
        local task = function()
            log.log("VolcanoMissionRewardView:CloseSelf play anima 2")
            AnimatorPlayHelper.Play(self.anima, {"end", "VolcanoMissionRewardView_end"}, false, function() 
                log.log("VolcanoMissionRewardView:CloseSelf play anima 3")
                self:MutualTaskFinish()
                Facade.SendNotification(NotifyName.CloseUI, self)
            end)
        end
        log.log("VolcanoMissionRewardView:CloseSelf play anima 1")
        self:DoMutualTask(task)
    else
        log.log("VolcanoMissionRewardView:CloseSelf without anima")
        Facade.SendNotification(NotifyName.CloseUI, self)
    end
end

function VolcanoMissionRewardView:on_btn_continue_click()
    --Facade.SendNotification(NotifyName.CloseUI, self)
    self:CloseSelf()
end

return this