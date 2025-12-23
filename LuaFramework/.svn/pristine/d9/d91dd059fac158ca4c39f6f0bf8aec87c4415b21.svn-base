--检查Resource是否足够，如果不够弹出商店
local Command = {}

function Command.Execute(notifyName,...)

    --tipCode:提示语表id 
    --resource:resource表id 
    --needCost:使用数量 
    --okCallback:回调 
    --shopTab:弹出商城定位显示的页签
    --parentView:父界面
    local tipCode,resource,needCost,okCallback,cancelCallback,openShopCallback,shopTab,parentView,viewType = select(1,...)

    needCost = tonumber(needCost)
    
    local resourceValue = 0
    if resource then
        resourceValue = ModelList.ItemModel.getResourceNumByType(resource)
    end
    if needCost and resourceValue >= needCost then
        if okCallback then
            okCallback()
        end
    else
        local name = Csv.GetData("resources",resource,"name")
        UIUtil.show_common_popup(tipCode or 8008,false,function()
            Facade.SendNotification(NotifyName.ShopView.PopupShop,PopupViewType.show,parentView,shopTab,nil,viewType)
            Event.Brocast(EventName.Event_Open_Shop_View,true)
            if openShopCallback then
                openShopCallback()
            end
        end,function()
            if cancelCallback then
                cancelCallback()
            end
        end,name,name)
    end
end

return Command