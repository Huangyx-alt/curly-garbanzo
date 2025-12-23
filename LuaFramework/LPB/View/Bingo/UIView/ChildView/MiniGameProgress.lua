
MiniGameProgress = BaseView:New()
local this = MiniGameProgress
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima",
    "progress",
    "icon",
}

function MiniGameProgress:Awake(obj)
    self:on_init()
end

function MiniGameProgress:OnEnable(params)
    local nowLevel = ModelList.PlayerInfoModel:GetLevel()
    local needLevel = Csv.GetLevelOpenByType(13,0)
    if nowLevel >= needLevel then
        self.card_sign_cell = {}
        self.signCount = 0
        local miniGameData = nil
        local minigame = ModelList.GameModel:GetBattleMiniGameInfo()
        if minigame then
            miniGameData = Csv.GetData("minigame",minigame.id)
        end
        if miniGameData and miniGameData.game_type == 1 then
            self.needCont = miniGameData.collect_type[2]
            self.isMiniGameAvailable = true
        end
    end
    if not self.isMiniGameAvailable then
        fun.set_active(self.transform,false)   
    end
end

function MiniGameProgress:OnDisable()
    self.card_sign_cell = nil
    self.signCount = nil
    self.needCont = nil
    self.isMiniGameAvailable = nil
    self.card_sign_cell = nil
end

function MiniGameProgress:RefreshMiniGameProgress(cardId,cellId)
    if not self.isMiniGameAvailable then
        return
    end
    if cardId and cellId then
        local cardid = tonumber(cardId)
        local cellid = tonumber(cellId)
        if not self.card_sign_cell[cardid] then
            self.card_sign_cell[cardid] = {}
        end
        if not self.card_sign_cell[cardid][cellid] then
            self.card_sign_cell[cardid][cellid] = 1
            self.signCount = self.signCount + 1
        end
        local target = math.min(1,self.signCount / self.needCont)
        if target then
            if self._tween and self._tween:IsActive() then
                self._tween:Kill()
            end
            self._tween = Anim.slide_to(self.progress, nil, target * 100, 0.35, function()
                if self.signCount >= self.needCont then
                    self.isMiniGameAvailable = false
                    AnimatorPlayHelper.Play(self.anima,{"full","MinigameProgress_full"},false,function()
                        Event.Brocast(EventName.cardBingoEffect_flyMiniGame,self.icon)
                    end)
                end
            end)
        end
    end
end