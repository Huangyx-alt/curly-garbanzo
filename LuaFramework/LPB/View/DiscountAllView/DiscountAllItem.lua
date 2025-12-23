local DiscountAllItem = BaseView:New("DiscountAllItem")

local this = DiscountAllItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
   "itemIcon",
   "tipIcon",
   "title",
   "saleIcon",
   "timetxt",
   "countText",
   "countTip",
   "tipIcon2",
   "tipIcon1",
   "SaleIcon2Text",
   "SaleIcon2",
   "SaleIcon3",
} 

function DiscountAllItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function DiscountAllItem:Awake()
    self:on_init()
end

function DiscountAllItem:OnEnable(data)
    self.data = data
    self:BuildFsm()
    fun.set_active(self.SaleIcon3, false)
end

function DiscountAllItem:BuildFsm()
    self:DisposeFsm()
    -- 有限状态机
end

function DiscountAllItem:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function DiscountAllItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function DiscountAllItem:UpdateData(data)
    self.data = data 
    local itemCfg = Csv.GetData("item", self.data.id)
    self.title.text = Csv.GetData("description", tonumber(itemCfg.description) , "description")    --设置名字
    self.timetxt.text = fun.TransformTimeToTxt(math.max(0,self.data.value - os.time()))
    Cache.SetImageSprite("ItemAtlas",itemCfg.icon,self.itemIcon) --设置icon 
    if (itemCfg.item_type ~= ItemType.rofy) then 
        fun.set_active(self.countTip,false)
    else 
        fun.set_active(self.countTip, true)
        self.countText.text =data.count  --数量 
    end 
    
    fun.set_active(self.SaleIcon3, false)
    --换算折扣比例
    if (itemCfg.item_type ==ItemType.rofy) then --如果是天降奇遇得用 coupon 
        local saleoff = Csv.GetData("coupon",self.data.id,nil)
        if saleoff.saleoff == 100 then
            fun.set_active(self.saleIcon,true)
            fun.set_active(self.SaleIcon2,false)
        else 
            fun.set_active(self.saleIcon,false)
            fun.set_active(self.SaleIcon2,true)
            self.SaleIcon2Text.text = saleoff.saleoff
        end 
    elseif itemCfg.item_type == ItemType.pu_Buff then
        fun.set_active(self.saleIcon, false)
        fun.set_active(self.SaleIcon2, false)
        fun.set_active(self.SaleIcon3, true)
        self.SaleIcon2Text.text = ""
    else 
        local result = Csv.GetData("item",self.data.id, "result")
        local disCount =  result[2] or 0
        if disCount == 100 then
            fun.set_active(self.saleIcon,true)
            fun.set_active(self.SaleIcon2,false)
        else 
            fun.set_active(self.saleIcon,false)
            fun.set_active(self.SaleIcon2,true)
            self.SaleIcon2Text.text = disCount
        end 
    end

    if itemCfg.item_type == ItemType.Tournament_DisCount then 
        fun.set_active(self.saleIcon,false)
        fun.set_active(self.SaleIcon2,false)
    end 

    --判断是否是无限
    if (itemCfg.item_type == ItemType.rofy) then
        fun.set_active(self.tipIcon2,true)
        fun.set_active(self.tipIcon1,false)
    elseif itemCfg.item_type == ItemType.pu_Buff then
        fun.set_active(self.tipIcon2,false)
        fun.set_active(self.tipIcon1,true)
    else
        fun.set_active(self.tipIcon2,false)
        fun.set_active(self.tipIcon1,true)
    end 
 end 

function DiscountAllItem:UpdateTime()
    local time = math.max(0,self.data.value - os.time())
    self.timetxt.text = fun.TransformTimeToTxt(time)
    return time
end

function DiscountAllItem:OnDisable()
   
end

return this