local HallofFameGoldStartView = BaseView:New("HallofFameGoldStartView","WinZoneHelperAtlas")

local this = HallofFameGoldStartView
this.isCleanRes = true
this._cleanImmediately = true
this.viewType = CanvasSortingOrderManager.LayerType.None
this.auto_bind_ui_items = {
    "btn_play",
    "btn_later",
    "text1",
    "text2",
    "text3",
    "winzonehuodongshuomingCard",
    "winzonehuodongshuomingCard02",
}

function HallofFameGoldStartView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function HallofFameGoldStartView:Awake()
    self:on_init()
    UISound.play("winzoneEntrance")
end

function HallofFameGoldStartView:OnEnable(params)
    self.closeType = params

    if fun.is_ios_platform() then
        self.winzonehuodongshuomingCard.sprite = AtlasManager:GetSpriteByName("WinZoneHelperAtlas", "winzonehuodongshuomingCardold")
        self.winzonehuodongshuomingCard02.sprite = AtlasManager:GetSpriteByName("WinZoneHelperAtlas", "winzonehuodongshuomingCard02old")
    else
        --self.winzonehuodongshuomingCard.sprite = AtlasManager:GetSpriteByName("WinZoneHelperAtlas", "winzonehuodongshuomingCard")
        --self.winzonehuodongshuomingCard02.sprite = AtlasManager:GetSpriteByName("WinZoneHelperAtlas", "winzonehuodongshuomingCard02")
    end
end


function HallofFameGoldStartView:on_btn_play_click()
    self:CloseView()
    ModelList.WinZoneModel:EnterSystem()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function HallofFameGoldStartView:on_btn_later_click()
    self:CloseView()
    Facade.SendNotification(NotifyName.CloseUI,self)
end

function HallofFameGoldStartView:CloseView()
    if self.closeType then
        if self.closeType == "hallofFamePosterView" then
            Event.Brocast(EventName.Event_HallofFame_PopEnd)
        end
    end
end

return this

