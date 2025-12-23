local PuzzleView = BaseDialogView:New("PuzzleView")
local this = PuzzleView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "GainRewardRoot",
    "Item",
    "RewardBox",
    "SpRoot",
    "btn_close",
    "btn_mask",
    "btn_open_box",
    "btn_claim_reward",
    "BgImage",
    "GainRewardItem",
}

function PuzzleView:CloseView(callback)
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function PuzzleView:Awake(obj)
    self:on_init()
end

function PuzzleView:OnEnable(params)
    Facade.RegisterView(self)
    self.params = params or {}
    self.sceneId = ModelList.CityModel:GetCity()
    self:ShowView()
end

function PuzzleView:ShowView()
    fun.set_active(self.GainRewardRoot, false)
    --背景图
    local cfg = Csv.GetData("new_city_play_scene", self.sceneId)
    self.BgImage.sprite = AtlasManager:GetSpriteByName("BingoBangPuzzleBgAtlas", cfg.res_name)
    
    self:InitPuzzleShow()
    self:InitRewardShow()
    self:CheckShowGainReward()
end

function PuzzleView:InitPuzzleShow()
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(self.sceneId)
    self.curPuzzleData = curPuzzleData
    local puzzlePieces = curPuzzleData and curPuzzleData.puzzlePieces
    --指定位置拼图解锁
    table.walk(puzzlePieces, function(v)
        local puzzlePartId = v.id
        local pos = string.sub(puzzlePartId, 7, 9)
        pos = tonumber(pos)
        local piece = fun.find_child(this.SpRoot, string.format("Sp%s", pos))
        if not IsNull(piece) then
            local animator = fun.get_animator(piece, fun.ANIMATOR)
            animator:Play("end", -1, 1)
        end
    end)


    --local sceneName  =  fun.get_active_scene().name
    local progress = curPuzzleData.collectNum / curPuzzleData.puzzleNum
    Http.report_event("activity_puzzle_open",{sceneid = self.sceneId,progress = progress})
end

function PuzzleView:InitRewardShow()
    local rewardData = Csv.GetData("new_city_play_scene", self.sceneId, "reward_description")
    if not rewardData then
        return
    end
    
    local itemRoot = self.Item.transform.parent
    table.walk(rewardData, function(v, k)
        local itemID, count = v[1], v[2]
        --local itemCfg = Csv.GetData("new_item", itemId)
        --local tempItem = fun.get_instance(self.Item, self.Item.transform.parent)
        local tempItem = fun.get_child(itemRoot, k - 1)
        fun.set_active(tempItem, true)
        local refer = fun.get_component(tempItem, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")
        Count.text = count
    end)

    local gainRewardItemRoot = self.GainRewardItem.transform.parent
    table.walk(rewardData, function(v, k)
        local itemID, count = v[1], v[2]
        --local itemCfg = Csv.GetData("new_item", itemId)
        --local tempItem = fun.get_instance(self.GainRewardItem, self.GainRewardItem.transform.parent)
        local tempItem = fun.get_child(gainRewardItemRoot, k - 1)
        fun.set_active(tempItem, true)
        local refer = fun.get_component(tempItem, fun.REFER)
        local Icon = refer:Get("Icon")
        local Count = refer:Get("Count")
        Count.text = count
    end)
end

function PuzzleView:CheckShowGainReward()
    local curPuzzleData = self.curPuzzleData
    if not curPuzzleData then
        return
    end    
    if not curPuzzleData.isUnlock or not curPuzzleData.isCompleted then
        return
    end    
    if curPuzzleData.isRewarded then
        return
    end
    
    LuaTimer:SetDelayFunction(1, function()
        fun.set_active(self.GainRewardRoot, true)
        fun.set_active(self.RewardBox, false)
    end)
end

function PuzzleView:on_btn_close_click()
    Facade.SendNotification(NotifyName.HideDialog, this)
end

function PuzzleView:on_btn_mask_click()
    this:on_btn_close_click()
end

function PuzzleView:on_btn_open_box_click()
    fun.enable_button(this.btn_open_box, false)
    ModelList.NewPuzzleModel:C2S_BingoGamePuzzleReward(this.sceneId)
end

function PuzzleView:on_btn_claim_reward_click()
    fun.enable_button(this.btn_claim_reward, false)
    
    fun.play_animator(this.GainRewardRoot, "end", true)
    
    --获得道具效果
    local startPos = fun.get_gameobject_pos(this.Items)
    Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts, startPos, 2, function()
        Event.Brocast(EventName.Event_currency_change)

        LuaTimer:SetDelayFunction(0.3, function()
            local topbar_view = GetCurrentTopBarView()
            if topbar_view then
                topbar_view:CloseTopBarParent(BingoBangEntry.exitMachineLobbyType.PuzzleRewardExit)
            else
                Facade.SendNotification(NotifyName.Common.GoBackClick)
            end
        end)
    end, nil, false)

    this:on_btn_close_click()
end

function PuzzleView.OnReceivePuzzleReward(data)
    log.r("[PuzzleView] ReceivePuzzleReward:", data)
    if not data or not data.reward then
        fun.enable_button(this.btn_open_box, true)
        return
    end

    fun.play_animator(this.GainRewardRoot, "open", true)
end

this.NotifyList = {
    {notifyName = NotifyName.PuzzleView.ReceivePuzzleReward,func = this.OnReceivePuzzleReward},
}

return this