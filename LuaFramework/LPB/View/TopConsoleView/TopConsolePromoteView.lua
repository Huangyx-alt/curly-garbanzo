require "View/TopConsoleView/TopConsolePromoteView2"

TopConsolePromoteView = TopConsolePromoteView2:New("TopConsolePromoteView",nil,nil,false,nil,RedDotParam.city_top_shop)
local this = TopConsolePromoteView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

--[[
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
    "vip",
    "text_rocket_value",

    "anima"
}

function TopConsolePromoteView:Exit()
    AnimatorPlayHelper.Play(self.anima,{"TopConsolePromoteViewexit","TopConsolePromoteViewenter"},false,function()
        self:Close()
    end,0)
end

function TopConsolePromoteView:override_OnEnable()
    AnimatorPlayHelper.Play(self.anima,"TopConsolePromoteViewenter",false,nil)
end


function TopConsolePromoteView:RegisterEvent_Override()
    Event.AddListener(EventName.Event_topbar_change,self.OnTopBarChange,self)
end

function TopConsolePromoteView:RemoveEvent_Override()
    Event.RemoveListener(EventName.Event_topbar_change,self.OnTopBarChange,self)
end
--]]

function TopConsolePromoteView:OnTopBarChange(...)

end

function TopConsolePromoteView:on_btn_goback_click()
end

function TopConsolePromoteView:on_btn_buy_click()
end

function TopConsolePromoteView:on_btn_head_click()
end

return this
