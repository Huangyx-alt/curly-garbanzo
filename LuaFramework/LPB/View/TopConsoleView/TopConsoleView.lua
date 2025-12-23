require "View/TopConsoleView/BaseTopConsoleView"

TopConsoleView = BaseTopConsoleView:New("TopConsoleView",nil,nil,false,nil,RedDotParam.city_top_shop)
local this = TopConsoleView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

function this:Exit()
    if not self:IsLifeStateDisable() then
        AnimatorPlayHelper.Play(self.anima,{"TopConsolePromoteViewexit","TopConsolePromoteViewenter"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end,0)
    end
end

return this
