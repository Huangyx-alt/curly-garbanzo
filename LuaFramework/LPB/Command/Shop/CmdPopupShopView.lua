
local Command = {}
PopupViewType = {show = 1,hide = 2}
local previousView = nil

--弹出商城，可以定位到指定页签，可以关闭父界面完成再打开
function Command.Execute(notifyName,...)

    --1表示打开商城
    --2表示关闭商城
    local popupType,parent,tab,callback,viewType = select(1,...)
    if popupType == PopupViewType.show then

        --parent:父界面
        --tab 商城显示的页签
        --callback 回调
        --local parent,tab,callback,viewType = select(2,...)

        previousView = parent

        if ViewList.MainShopView.isShow then
            ViewList.MainShopView:SwitchToTab(tab)
        else
            ViewList.MainShopView:SetShowTab(tab)
            --ViewList.ShopView.viewType = viewType or CanvasSortingOrderManager.LayerType.Shop_Dialog
            Facade.SendNotification(NotifyName.ShowUI,ViewList.MainShopView,function()
                if previousView then
                    previousView:CloseView()
                end
                if callback then
                    callback()
                end
                SDK.open_buy_shop(ProcedureManager.GetCurrentSceneName())
            end)
            --if viewType then
            --    Facade.SendNotification(NotifyName.ShowUI,ViewList.TopConsolePromoteView2)
            --end
        end
    elseif popupType == PopupViewType.hide then
        if previousView then
            previousView:OpenView(function()
                Facade.SendNotification(NotifyName.CloseUI,ViewList.MainShopView)
                previousView = nil
            end,true)
        else
            Facade.SendNotification(NotifyName.CloseUI,ViewList.MainShopView)
        end
    end
end

return Command;