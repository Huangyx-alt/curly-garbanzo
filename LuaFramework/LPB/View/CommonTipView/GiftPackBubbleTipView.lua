
local GiftPackBubbleTipView = BaseView:New("GiftPackBubbleTipView", "CommonAtlas")
local this = GiftPackBubbleTipView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.defaultWidth = 139
this.defaultHeight = 131

this.auto_bind_ui_items = {
    "root",
    "background",
    "text_tip",
}

local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

function GiftPackBubbleTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function GiftPackBubbleTipView:OnEnable(params)
    if params then
        self._exclude = params.exclude or {} --需要排除掉点击会弹出该tip的按钮本身

        self:InitContent(params)
    end
end

function GiftPackBubbleTipView:OnDisable()
    Facade.SendNotification(NotifyName.CloseUI, this)
end

function GiftPackBubbleTipView:on_x_update()
    if input.GetKeyUp(keyCode.Mouse0) then
        local curSelectGo = evntsystem.current.currentSelectedGameObject
        local exclude = false
        for key, value in pairs(self._exclude) do
            if curSelectGo == value then
                exclude = true
                break
            end
        end
        if not exclude then
            Facade.SendNotification(NotifyName.CloseUI, this)
        end
    end
end


function GiftPackBubbleTipView:InitContent(params)
    self.root.position = params.pos
    self.root.localPosition = self.root.localPosition + params.offset

    local width = params.width or self.defaultWidth
    local height = params.height or self.defaultHeight
    self.background.sizeDelta = Vector2.New(width, height) 
    self.text_tip.text = params.text
    fun.set_parent(self.go,params.parent)
    if(params.isAutoClose)then  
        self:register_timer(3,function()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    else

         
        self:stop_x_update()
    end

end



return this