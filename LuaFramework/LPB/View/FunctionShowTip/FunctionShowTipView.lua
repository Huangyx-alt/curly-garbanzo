TipArrowDirection = {left = 1,right = 2,top = 3,bottom = 4,bottomleft = 5,bottomright = 6,topleft = 7,topright = 8}

FunctionShowTipView = BaseView:New("FunctionShowTipView","CommonAtlas")
local this = FunctionShowTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "root",
    "background",
    "arrow_bottom_right",
    "arrow_right",
    "text_tip"
}

local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

function FunctionShowTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function FunctionShowTipView:OnEnable(params)
    if params then
        self.text_tip.text = params.text
        self.root.position = params.pos
        self.root.localPosition = self.root.localPosition + params.offset
        self._exclude = params.exclude or {} --需要排除掉点击会弹出该tip的按钮本身

        local dir = params.dir or TipArrowDirection.bottomright
        if dir == TipArrowDirection.right then
            fun.set_active(self.arrow_bottom_right,false,false)
        elseif dir == TipArrowDirection.bottomright then
            fun.set_active(self.arrow_right,false,false)
        else
            ---待后续添加    
        end
    end
end

function FunctionShowTipView:OnDisable()

end

function FunctionShowTipView:on_x_update()
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
            Facade.SendNotification(NotifyName.CloseUI,this)
        end
    end
end

return this