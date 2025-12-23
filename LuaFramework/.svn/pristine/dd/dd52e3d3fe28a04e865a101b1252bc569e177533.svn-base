local BubbleTipView = BaseView:New("BubbleTipView", "CommonAtlas")
local this = BubbleTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog
this.ArrowDirection = {left = 1, right = 2, top = 3, bottom = 4,}
this.defaultWidth = 600
this.defaultHeight = 140

this.auto_bind_ui_items = {
    "root",
    "background",
    "text_tip",
    "arrow_right",
    "arrow_left",
    "arrow_top",
    "arrow_bottom",
    "arrow_pos1",
}

local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

function BubbleTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function BubbleTipView:OnEnable(params)
    if params then
        self._exclude = params.exclude or {} --需要排除掉点击会弹出该tip的按钮本身

        self:InitContent(params)
    end
end

function BubbleTipView:OnDisable()
end

function BubbleTipView:InitContent(params)
    self.root.position = params.pos
    self.root.localPosition = self.root.localPosition + params.offset

    fun.set_active(self.arrow_right, false)
    fun.set_active(self.arrow_left, false)
    fun.set_active(self.arrow_top, false)
    fun.set_active(self.arrow_bottom, false)
    local dir = params.dir or self.ArrowDirection.bottom
    local curArrow, isHorizontal, isVertical
    if dir == self.ArrowDirection.right then
        curArrow = self.arrow_right
        isVertical = true
    elseif dir == self.ArrowDirection.left then
        curArrow = self.arrow_left
        isVertical = true
    elseif dir == self.ArrowDirection.top then
        curArrow = self.arrow_top
        isHorizontal = true
    elseif dir == self.ArrowDirection.bottom then
        curArrow = self.arrow_bottom
        isHorizontal = true
    end
    fun.set_active(curArrow, true)

    local width = params.width or self.defaultWidth
    local height = params.height or self.defaultHeight
    self.background.sizeDelta = Vector2.New(width, height)

    local arrowOffset = params.arrowOffset or 0
    if isHorizontal then
        curArrow.localPosition = Vector3.New(arrowOffset, curArrow.localPosition.y, 0)
    elseif isVertical then
        curArrow.localPosition = Vector3.New(curArrow.localPosition.x, arrowOffset, 0)
    end

    self.text_tip.text = params.text
end

function BubbleTipView:on_x_update()
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

return this