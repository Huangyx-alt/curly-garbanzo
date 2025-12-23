
RewardShowTipView = BaseView:New("RewardShowTipView","CommonAtlas")
local this = RewardShowTipView
this.viewType = CanvasSortingOrderManager.LayerType.Popup_Dialog

this.auto_bind_ui_items = {
    "reward_content",
    "reward_item",
    "root",
    "background",
    "img_arrow_r",
    "img_arrow_b",
    "img_arrow_l",
    "viewport",
    "img_background",
    "img_arrow_t",
    "reward_item2",
    "reward_content2",
    "scrollview",
    "img_arrow_left_up",
    "img_arrow_right_up",
	"img_arrow_left_down",
}

local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

function RewardShowTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function RewardShowTipView:OnEnable(params)
    if params then

        if params.pivot then
            local bg = fun.get_component(self.img_background, fun.RECT)
            bg.pivot = params.pivot
        end

        self.root.position = params.pos
        self.root.localPosition = self.root.localPosition + params.offset
        self._exclude = params.exclude or {} --需要排除掉点击会弹出该tip的按钮本身

        if params.bg_width then
            local size = self.img_background.sizeDelta
            self.img_background.sizeDelta = Vector2.New(params.bg_width,size.y)
        end

        if params.dir == RewardShowTipOrientation.up then
            fun.set_active(self.img_arrow_r,false,false)
            fun.set_active(self.img_arrow_l,false,false)
            fun.set_active(self.img_arrow_b,false,false)
            fun.set_active(self.img_arrow_left_up,false,false)
            fun.set_active(self.img_arrow_right_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
        elseif params.dir == RewardShowTipOrientation.down then
            fun.set_active(self.img_arrow_t,false,false)
            fun.set_active(self.img_arrow_l,false,false)
            fun.set_active(self.img_arrow_r,false,false)
            fun.set_active(self.img_arrow_left_up,false,false)
            fun.set_active(self.img_arrow_right_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
        elseif params.dir == RewardShowTipOrientation.left then
            fun.set_active(self.img_arrow_r,false,false)
            fun.set_active(self.img_arrow_t,false,false)
            fun.set_active(self.img_arrow_b,false,false)
            fun.set_active(self.img_arrow_left_up,false,false)
            fun.set_active(self.img_arrow_right_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
        elseif params.dir == RewardShowTipOrientation.right then
            fun.set_active(self.img_arrow_t,false,false)
            fun.set_active(self.img_arrow_l,false,false)
            fun.set_active(self.img_arrow_b,false,false)
            fun.set_active(self.img_arrow_left_up,false,false)
            fun.set_active(self.img_arrow_right_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
        elseif params.dir == RewardShowTipOrientation.leftUp then
            fun.set_active(self.img_arrow_r,false,false)
            fun.set_active(self.img_arrow_t,false,false)
            fun.set_active(self.img_arrow_l,false,false)
            fun.set_active(self.img_arrow_b,false,false)
            fun.set_active(self.img_arrow_right_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
        elseif params.dir == RewardShowTipOrientation.rightUp then
            fun.set_active(self.img_arrow_r,false,false)
            fun.set_active(self.img_arrow_t,false,false)
            fun.set_active(self.img_arrow_l,false,false)
            fun.set_active(self.img_arrow_b,false,false)
            fun.set_active(self.img_arrow_left_up,false,false)
			fun.set_active(self.img_arrow_left_down,false,false)
		elseif params.dir == RewardShowTipOrientation.leftDown then
			fun.set_active(self.img_arrow_r,false,false)
			fun.set_active(self.img_arrow_t,false,false)
			fun.set_active(self.img_arrow_l,false,false)
			fun.set_active(self.img_arrow_b,false,false)
			fun.set_active(self.img_arrow_left_up,false,false)
			fun.set_active(self.img_arrow_right_up,false,false)
        end

        local view = nil
        if params.rewards and params.item2 then
            view = require("View/RewardShowTip/RewardShowTipItem2")
            for key, value in pairs(params.rewards) do
                local go = fun.get_instance(self.reward_item2,self.reward_content2)
                local rewardView = view:New()
                rewardView:SetReward(value)
                rewardView:SkipLoadShow(go,true,nil)
            end
            self.scrollview.content = self.reward_content2.transform
        elseif params.rewards then
            view = require("View/RewardShowTip/RewardShowTipItem")
            for key, value in pairs(params.rewards) do
                local go = fun.get_instance(self.reward_item,self.reward_content)
                local rewardView = view:New()
                rewardView:SetReward(value)
                rewardView:SkipLoadShow(go,true,nil)
            end
            self.scrollview.content = self.reward_content.transform
        end
    end
end

function RewardShowTipView:OnDisable()

end

function RewardShowTipView:on_x_update()
    if input.GetKeyUp(keyCode.Mouse0) then
        local curSelectGo = evntsystem.current.currentSelectedGameObject
        local camera = ProcedureManager:GetCamera()
        local exclude = false
        if  Util.IsTopGraphic(camera,self.viewport) then
            exclude = true
        else
            for key, value in pairs(self._exclude) do
                if curSelectGo == value then
                    exclude = true
                    break
                end
            end
        end
        if not exclude then
            Facade.SendNotification(NotifyName.CloseUI,this)
        end
    end
end

return this