-- 折扣券 带轮播功能、
require "View/CommonView/RemainTimeCountDown"
local FunctionIconBaseView = require "View/CommonView/FunctionIconBaseView"
local FunctionIconDiscountAllView = FunctionIconBaseView:New("FunctionIconDiscountAll","DiscountAtlas")
local this = FunctionIconDiscountAllView

this.viewType = CanvasSortingOrderManager.LayerType.None
local ItemEntityCache = {}
this.index = 0
this.decFlag = true 

this.auto_bind_ui_items = {
    "btn_task", --点击出现
    "scrollView", --轮播
    "text_countdown",
    "Content",
    "itemIcon" -- 图片
}

function FunctionIconDiscountAllView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.remainTimeCountDown = RemainTimeCountDown:New()
    return o
end

function FunctionIconDiscountAllView:Awake()
    self:on_init()
end

function FunctionIconDiscountAllView:OnEnable()
    self:RegisterRedDotNode()
    self:RegisterEvent()
   
    self:UpdateDiscountInfo()
  
end

function FunctionIconDiscountAllView:OnDisable()
    self:UnRegisterRedDotNode()
    self:UnRegisterEvent()
    this:StopCountdown()
    self.remainTimeCountDown:StopCountDown()
    for _,v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache ={}
end

function FunctionIconDiscountAllView:OnDestroy()
    this:StopCountdown()
    self:Close()
    for _, v in pairs(ItemEntityCache) do
	   --删除
       v:Close()
	end

    ItemEntityCache ={}
end

function FunctionIconDiscountAllView:on_close()
    
end

function FunctionIconDiscountAllView:UpdateDiscountInfo()
    this:StopCountdown()
    for _,v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache ={}


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
                item.value = not coupon_data and 0 or coupon_data.cTime; 
                item.count = tb[i].value;
            end 

            tmpb[tb[i].id] = item
        else 
            tmpb[tb[i].id].count =  tmpb[tb[i].id].count +1
        end 
    end 
    ViewList.DiscountAllView:RebuildItemDataList(tmpb)
    local count = 0;
    for _,v in pairs(tmpb) do 

        if math.max(0,v.value - os.time()) > 0 then 
            count = count +1 
            local view =  self:GetItemViewInstance(count)
            if view then 
                view:UpdateData(v)
            end 
        end 
    end 

    if GetTableLength(tmpb) > 0 then --if #tb > 0 then --原条件
        --开启定时器轮播图片
        this.TimeLoop = LuaTimer:SetDelayLoopFunction(0, 2,-1, function()
            
            if (not self.Content) then 
                this:StopCountdown()
                return 
            end 

        
            if #ItemEntityCache == 1 then 
                this.index = 0 
                self.Content.transform.localPosition =  Vector3.New(0, 0, 0)
                if ItemEntityCache[1] then 
                    local data =  ItemEntityCache[1]:GetData()   
                    local time =  math.max(0,data.value - os.time())

                    if time == 0 then 
                        self:UpdateDiscountInfo()
                    else 
                        self.text_countdown.text = fun.TransformTimeToTxt(time)
                    end 
               end 
            else 
                this.index = this.index  +1;
                local index = this.index; 
                if this.index > #ItemEntityCache then 
                    this.index =0 
                    self.Content.transform.localPosition =  Vector3.New(0, 0, 0)
                    index = 1

                    if ItemEntityCache[ index] then 
                        local data =  ItemEntityCache[index]:GetData()
                        local time =  math.max(0,data.value - os.time())

                        if time == 0 then 
                            self:UpdateDiscountInfo()
                        else 
                            self.text_countdown.text = fun.TransformTimeToTxt(time)
                        end 
                    end 
                else 
                    if this.index -1 ~= 0 then 
                        self.text_countdown.text =""
                    end 
                  
                    index = this.index
                    Anim.move_to_xy_local_ease( self.Content.gameObject,(this.index-1) * -158,0,1,function ()
                        
                        if ItemEntityCache[ index] then 
                            local data =  ItemEntityCache[index]:GetData()
                            local time =  math.max(0,data.value - os.time())

                            if time == 0 then 
                                self:UpdateDiscountInfo()
                            else 
                                self.text_countdown.text = fun.TransformTimeToTxt(time)
                            end 
                        end 
                    end)
                end 
               
            end 
   
           -- fun.set_transform_pos(self.Content,this.index * -112 ,0,0,false)
          --  self.Content.transform.localPosition =  Vector3.New(this.index * -100, 0, 0)
            -- Anim.move_to_x( self.Content.gameObject,this.index * -100,4,function ()
                
            -- end)
        end,function ()
        
        end,nil,LuaTimer.TimerType.UI)
    end 
end

function FunctionIconDiscountAllView:StopCountdown()
    if this.TimeLoop then
        LuaTimer:Remove(this.TimeLoop)
        this.TimeLoop = nil
    end
end

function FunctionIconDiscountAllView:GetItemViewInstance(index)
    local view = require "View/CommonView/IconDisscount/IconDiscount"
    local view_instance = nil
    
    if ItemEntityCache[index] == nil then
        local item = fun.get_instance(self.itemIcon,self.Content)
        view_instance = view:New()
        view_instance:SkipLoadShow(item)
        ItemEntityCache[index] = view_instance
    else
        view_instance = ItemEntityCache[index]
    end 
    
    fun.set_active(view_instance:GetTransform(),true,false)

    return view_instance
end 
  
function FunctionIconDiscountAllView:RegisterEvent()
 --   Event.AddListener(EventName.Event_coupon_change,self.UpdateDiscountInfo,self)
 --   Event.AddListener(EventName.Event_UpdateItems,self.UpdateDiscountInfo,self)
end

function FunctionIconDiscountAllView:UnRegisterEvent()
  --  Event.RemoveListener(EventName.Event_coupon_change,self.UpdateDiscountInfo,self)
 --   Event.RemoveListener(EventName.Event_UpdateItems,self.UpdateDiscountInfo,self)
end

function FunctionIconDiscountAllView:RegisterRedDotNode()
    
end

function FunctionIconDiscountAllView:UnRegisterRedDotNode()
    
end


--是否过期
function FunctionIconDiscountAllView:IsExpired()
 
    local tb = ModelList.CouponModel.get_DiscountOfIitem()
    local flag = true
    for _,v in ipairs(tb) do 
        local time = v.value 
        local type = Csv.GetData("item", v.id, "item_type")
        if type == 6 then --如果是天降奇遇得道具那就 加上cd时间
            local coupon_data = ModelList.CouponModel.getCouponforId(v.id)

            time = not coupon_data and 0 or coupon_data.cTime;
        end 

        if math.max(0,time - os.time()) > 0 then 
            flag = false
            break
        end 
    end 

    if ModelList.CityModel:GetPuBuffRemainTime() > 0 then
        flag = false
    end

    return flag
end


function FunctionIconDiscountAllView:on_btn_task_click()
    --弹出折扣券列表  
    Facade.SendNotification(NotifyName.HallCity.Function_icon_click, "DiscountAllView", false)
end

return this