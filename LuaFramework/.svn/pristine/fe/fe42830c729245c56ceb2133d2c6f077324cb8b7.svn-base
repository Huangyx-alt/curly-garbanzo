--[[
Descripttion: 战斗内收集到的奖励展示
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年8月1日16:15:51
LastEditors: gaoshuai
LastEditTime: 2025年8月1日16:15:51
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local RewardCollectView2 = BaseView:New('RewardCollectView2')
local this = RewardCollectView2;
this.__index = this
this.auto_bind_ui_items = {
    "Default",
    "Active",
    "Items",
    "Bg",
    "Item",
    "Default2",
    "Active2",
    "Items2",
    "Bg2",
    "Item2",
}

this.collectedRewardList = {}

function RewardCollectView2:New()
    local o = {}
    o.__index = self
    setmetatable(o, this)
    return o
end

function RewardCollectView2:Awake()
    Facade.RegisterView(self)
    self:on_init()
end

function RewardCollectView2:OnEnable()
    this.collectedRewardList = {}
    fun.set_active(self.go, true)
    fun.set_active(self.Default, false)
    fun.set_active(self.Active, false)
    fun.set_active(self.Default2, true)
    fun.set_active(self.Active2, false)
end

function RewardCollectView2:OnDisable()

end

function RewardCollectView2:OnDestroy()
    Facade.RemoveView(self)
    self:Close()

    if self.bgAnim then
        self.bgAnim:Kill()
        self.bgAnim = nil
    end

    table.walk(self.collectedRewardList, function(v)
        destroy(v.obj)
    end)
    self.collectedRewardList = {}
end

function RewardCollectView2:AddReward(rewardItemID)
    local itemCfg = Csv.GetData("new_item", rewardItemID)
    if itemCfg.put_type ~= 1 then
        return
    end    
    if itemCfg.result[1] == 1 or itemCfg.result[1] == 0 then
        return
    end

    fun.set_active(self.Default2, false)
    fun.set_active(self.Active2, true)

    local target = this.collectedRewardList[rewardItemID]
    if not target then
        local childCount = fun.get_child_count(self.Items)
        local len, item = GetTableLength(this.collectedRewardList)
        if len < childCount then
            item = fun.get_child(self.Items2, len)
        else
            item = fun.get_instance(self.Item2, self.Items2)
        end
        local refer = fun.get_component(item, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")

        local itemType = itemCfg.result[1]
        this.collectedRewardList[rewardItemID] = {
            obj = item,
            CountText = Count,
            Icon = Icon,
            count = 0,
            needShowCount = itemType and itemType ~= 3 or false,
        }

        Icon.sprite = AtlasManager:GetSpriteByName("BingoBangBattleAtlas", itemCfg["icon"])
        fun.set_alpha(Icon, 0.5)

        fun.set_active(Count, false)
        fun.set_active(item, true)
        --else
        --    local nowCount = this.collectedRewardList[rewardItemID].count + count
        --    this.collectedRewardList[rewardItemID].count = nowCount
        --    this.collectedRewardList[rewardItemID].CountText.text = nowCount
    end
end

function RewardCollectView2:RewardShow(rewardItemID, cardId, cellIndex)
    local target = this.collectedRewardList[rewardItemID]
    if target then
        fun.set_alpha(target.Icon, 1)
        target.count = target.count + 1
        target.CountText.text = string.format("x%s", target.count)
        fun.set_active(target.CountText, target.needShowCount)

        if not target.needShowCount then
            local model = ModelList.BattleModel:GetCurrModel()
            model:RemoveCellGift(rewardItemID, cardId, cellIndex)
        end
    end
end

function RewardCollectView2.OnPutRewardToCell(cardId, cellIndex, rewardItemID)
    this:AddReward(rewardItemID)
end

function RewardCollectView2.SignCollectReward(cardId, cellIndex, rewards)
    table.walk(rewards, function(reward)
        this:RewardShow(reward, cardId, cellIndex)
    end)
end

this.NotifyList = {
    { notifyName = NotifyName.RewardCollect.OnPutRewardToCell, func = this.OnPutRewardToCell },
    { notifyName = NotifyName.RewardCollect.SignCollectReward, func = this.SignCollectReward },
}

return this