require "View/TopConsoleView/BaseTopConsoleView"

TopConsolePromoteView2 = BaseTopConsoleView:New("TopConsolePromoteView",nil,nil,false,nil,RedDotParam.city_top_shop)
local this = TopConsolePromoteView2
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog

this.auto_bind_ui_items = {
    "btn_buy",
    "text_coin_value",
    "text_dimond_value",
    "left_icon",
    "right_icon",
    "buy_bg_img",
    "buy_letter_img",
    "img_reddot",
    "btn_goback",
--------------------------头像-----------------    
    "btn_head",
    "img_head_frame",
    "img_head_icon",
    "slid_exp",
    "text_exp",
    "text_level",
    "text_leaf",
--------------------------头像-----------------
    "rocket",
    "btn_vip",
    "text_rocket_value",

    "anima",
    "ShowHead",
}

function TopConsolePromoteView2:New(viewName, atlasName, parentView,disable,owner,reddot)
    local o = {}
    self.__index = self
    setmetatable(o, self)
    o.viewName = viewName
    o.atlasName = atlasName
    o._parentView = parentView
    o._disable = disable
    o._owner = owner
    o._reddot = reddot or RedDotParam.city_top_shop
    return o
end

function TopConsolePromoteView2:Exit()
    if not self:IsLifeStateDisable() then
        AnimatorPlayHelper.Play(self.anima,{"TopConsolePromoteViewexit","TopConsolePromoteViewenter"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end,0)
    end
end

function TopConsolePromoteView2:override_OnEnable()
    AnimatorPlayHelper.Play(self.anima,"TopConsolePromoteViewenter",false,nil)
end


function TopConsolePromoteView2:on_btn_buy_click()
end

function TopConsolePromoteView2:on_btn_goback_click()
    AnimatorPlayHelper.Play(self.anima,{"TopConsolePromoteViewexit","TopConsolePromoteViewenter"},false,function()
        Facade.SendNotification(NotifyName.CloseUI,self)
        self:GOBack()
    end,0)
end

return this
