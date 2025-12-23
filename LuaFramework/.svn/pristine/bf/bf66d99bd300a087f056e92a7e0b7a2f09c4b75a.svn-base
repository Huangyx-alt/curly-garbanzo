local IconDisscount = BaseView:New("IconDisscount")
local this = IconDisscount
this.viewType = CanvasSortingOrderManager.LayerType.None


this.auto_bind_ui_items = {  
    "img",          --上锁得文本
    "noBg",
    "Text",
    "saleIcon",
    "SaleIcon2",
    "SaleIcon2Text",
    "SaleIcon3",
} 


function IconDisscount:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function IconDisscount:Awake()
    self:on_init()
end
function IconDisscount:OnEnable(ID)
    -- Facade.RegisterView(this)
    self.id = ID
    fun.set_active(self.SaleIcon3, false)
end

function IconDisscount:UpdateData(data)
    self.data = data
    local icon = Csv.GetItemOrResource(self.data.id)
    local itemCfg = Csv.GetData("item", self.data.id)
    Cache.SetImageSprite("ItemAtlas",icon.icon,self.img)
    fun.set_recttransform_native_size(self.img,158,136)

    local type = Csv.GetData("item", self.data.id, "item_type")
    fun.set_active(self.SaleIcon3, false)
    if (type == 6) then 
        fun.set_active(self.noBg, false)
        fun.set_active(self.Text,true)
        self.Text.text =data.count  --数量 
    else 
        fun.set_active(self.noBg,true)
        fun.set_active(self.Text,false)
    end 

    --出现free
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
    elseif itemCfg.item_type == ItemType.pu_Buff then
        fun.set_active(self.saleIcon, false)
        fun.set_active(self.SaleIcon2, false)
        fun.set_active(self.SaleIcon3, true)
    end 
    
end

function IconDisscount:GetData()
    return self.data 
end 

function IconDisscount:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

function IconDisscount:OnDisable()
   
end

return this