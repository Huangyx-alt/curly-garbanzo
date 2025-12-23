require "State/Common/CommonState"

DiscountAllView = BaseView:New("DiscountAllView","DiscountAtlas")
local this = DiscountAllView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local ItemEntityCache = {}

this.auto_bind_ui_items = {
    "btn_close",
    "Content",
    "item",
    "anima",
}

function DiscountAllView:Awake(obj)
    self:on_init()
end

function DiscountAllView:OnEnable(params)
    fun.set_active(self.item, false)
    this:UpdataAllItem()
    AnimatorPlayHelper.Play(self.anima,"TaskViewenter",false,function()     

    end)
end

function DiscountAllView:UpdataAllItem() 
    for _, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache ={}
    this:StopCountdown()

    local tb = ModelList.CouponModel.get_DiscountOfIitem()
    local tmpb = {}

    for i =1,#tb do 
        if not tmpb[tb[i].id] then 
            local item = {
                id = tb[i].id,
                value = tb[i].value,
                count = 1,
            }
            local type = Csv.GetData("item", tb[i].id, "item_type")
            if type == 6 then --如果是天降奇遇得道具那就 加上cd时间
                --则在 别的地方取
                local coupon_data = ModelList.CouponModel.getCouponforId(tb[i].id)
                item.value = not coupon_data and 0 or  coupon_data.cTime;
                item.count = tb[i].value;
            end 

            tmpb[tb[i].id] = item
        else 
            tmpb[tb[i].id].count =  tmpb[tb[i].id].count +1
        end 
    end

    self:RebuildItemDataList(tmpb)

    local count = 0;
    for _,v in pairs(tmpb)  do 
        if math.max(0,v.value - os.time()) > 0 then 
            count = count +1 
            local view =  self:GetItemViewInstance(count)
            if view then 
                view:UpdateData(v)
            end 
        end
    end 

    self.TimeLoop = LuaTimer:SetDelayLoopFunction(1, 1,-1, function()
        for _,v in ipairs(ItemEntityCache) do 
            if v then 
               local time =  v:UpdateTime()
               if time == 0 then 
                    this:UpdataAllItem()
                break;
               end
            end 
        end 
    end,function ()
            
    end,nil,LuaTimer.TimerType.UI)
end 

function DiscountAllView:RebuildItemDataList(itemDataList)
    if not itemDataList then
        return
    end
    ---[[pu buff
    if ModelList.CityModel:GetPuBuffRemainTime() > 0 then
        local resourceId = 39
        local itemId = 6034
        local expireTime = ModelList.ItemModel.getResourceNumByType(resourceId) or 0 --截止时间戳
        if not itemDataList[itemId] then
            itemDataList[itemId] = {
                count = 0,
                id = itemId,
                value = expireTime
            }
        else
            log.log("DiscountAllView:RebuildItemDataList(itemDataList) item already existed", itemId, itemDataList)
        end
    end
    --]]
end

function DiscountAllView:StopCountdown()
    if self.TimeLoop then
        LuaTimer:Remove(self.TimeLoop)
        self.TimeLoop = nil
    end
end

function DiscountAllView:GetItemViewInstance(index)
    local view = require "View/DiscountAllView/DiscountAllItem"
    local view_instance = nil
    
    if ItemEntityCache[index] == nil then
        local item = fun.get_instance(self.item,self.Content)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        ItemEntityCache[index] = view_instance
    else
        view_instance = ItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)

    return view_instance
end 

function DiscountAllView:OnDisable()
    Facade.RemoveView(self)
    
    for _, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache ={}
    this:StopCountdown()
end

function DiscountAllView:OnDestroy()
    for _, v in pairs(ItemEntityCache) do
        --删除
        v:Close()
     end
 
     ItemEntityCache ={}
     this:StopCountdown()
end

function DiscountAllView:on_close()

end

function DiscountAllView:RegisterRedDotNode()
  
end

function DiscountAllView:UnRegisterRedDotNode()
 
end



function DiscountAllView:on_btn_close_click()
    AnimatorPlayHelper.Play(self.anima,"TaskViewexit",false,function()     
        Facade.SendNotification(NotifyName.CloseUI,this)
    end)
    --Facade.SendNotification(NotifyName.CloseUI,this)
end

this.NotifyList = {
--   {notifyName = NotifyName.TaskView.Click_go_button, func = this.OnClickGoButton}
}

return this

