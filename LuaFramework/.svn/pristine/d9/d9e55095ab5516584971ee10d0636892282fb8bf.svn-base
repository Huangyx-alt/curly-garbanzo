
local hallMainMiniGameView = require "View/PeripheralSystem/HallMainViewMiniGame/HallMainMiniGameView"
local MiniGamePiggySlotsView = hallMainMiniGameView:New()
local this = MiniGamePiggySlotsView

this.auto_bind_ui_items = {
    "progressSlider",
    "title",
    "btn_icon",
    "redPoint",
    "textRedPoint",
    "textProgress",
    "btn_close_tip",
    "popTip",
}

function MiniGamePiggySlotsView:Awake()
    self:on_init()
end

function MiniGamePiggySlotsView:on_btn_close_tip_click()
    fun.set_active(self.popTip, false)
end

function MiniGamePiggySlotsView:OnClickMiniGame()
    if ModelList.MiniGameModel:CheckMiniGameOpen(BingoBangEntry.miniGameType.PiggySlots) then
        local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
        if ticketNum > 0 then
            local piggySlotsGameId = ModelList.MiniGameModel:GetMiniGameId(BingoBangEntry.miniGameType.PiggySlots)
            log.log("获取的小游戏id" , piggySlotsGameId)
            ModelList.MiniGameModel:RaqUseMiniGameTick(piggySlotsGameId,function()
                Facade.SendNotification(NotifyName.ShowUI, ViewList.PiggySlotsGameView)
            end)
        else
            fun.set_active(self.popTip, true)
            log.log("小猪slots:小猪门票不足")
        end
    else
        log.log("小猪slots:小猪活动未开始或已结束")
    end
end

function MiniGamePiggySlotsView:RefreshItem()
    self:RefreshRedPoint()
    self.title.text = "GAME"
    local target = ModelList.MiniGameModel:GetMiniGameTicketTarget(BingoBangEntry.miniGameType.PiggySlots)
    local progress = ModelList.MiniGameModel:GetMiniGameTicketProgress(BingoBangEntry.miniGameType.PiggySlots)
    local value = progress / target
    self.textProgress.text = string.format("%s%s", value * 100 , "%")
    self.progressSlider.value = value
end

function MiniGamePiggySlotsView:RefreshRedPoint()
    local ticketNum = ModelList.MiniGameModel:GetMiniGameTicketNum(BingoBangEntry.miniGameType.PiggySlots)
    if ticketNum > 0 then
        fun.set_active(self.redPoint , true)
        self.textRedPoint.text = ticketNum        
    else
        fun.set_active(self.redPoint , false)
    end
end

function MiniGamePiggySlotsView:RegEvent()
    Event.AddListener(EventName.ExitPiggySlotsMiniGameRefresh,self.RefreshItem,self)
end

function MiniGamePiggySlotsView:UnRegEvent()
    Event.RemoveListener(EventName.ExitPiggySlotsMiniGameRefresh,self.RefreshItem)
end


function MiniGamePiggySlotsView:OnDestroy()
    self:Close()
end

function MiniGamePiggySlotsView:GetMiniGameName()
    return "MiniGamePiggySlotsView"
end

return MiniGamePiggySlotsView