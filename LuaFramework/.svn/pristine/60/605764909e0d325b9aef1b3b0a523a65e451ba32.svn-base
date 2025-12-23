
local HallMainMiniGameView = BaseView:New("HallMainMiniGameView")
local this = HallMainMiniGameView

this.auto_bind_ui_items = {
    "progressSlider",
    "title",
    "btn_icon",
    "redPoint",
    "textRedPoint",
}


function HallMainMiniGameView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function HallMainMiniGameView:Awake()
    self:on_init()
end

function HallMainMiniGameView:OnEnable()
    self:RegEvent()
    self:RefreshItem()
    Facade.RegisterViewEnhance(self)
end

function HallMainMiniGameView:OnDisable()
    Facade.RemoveViewEnhance(self)
end

function HallMainMiniGameView:RefreshItem()
end

function HallMainMiniGameView:OnClickMiniGame()
end

function HallMainMiniGameView:on_btn_icon_click()
    if self.owner and self.owner.isInCityPopupState then
        return
    end
    
    self:OnClickMiniGame()
end

function HallMainMiniGameView:GetMiniGameName()
end

function HallMainMiniGameView:OnDestroy()
    self:UnRegEvent()
    self:Close()
end

function HallMainMiniGameView:RegEvent()
end

function HallMainMiniGameView:UnRegEvent()
end

return HallMainMiniGameView