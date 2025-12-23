

KitchenIngredientView = BaseView:New("KitchenIngredientView")
local this = KitchenIngredientView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "btn_item",
    "anima",
    "icon_item",
    "item",
    "alpha"
}

function KitchenIngredientView:New(info,index)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._itemInfo = info
    o._keyIndex = index
    return o
end

function KitchenIngredientView:Awake()
    self:on_init()
end

function KitchenIngredientView:OnEnable()
    self._firstInit = true
    self:SetData(self._itemInfo)
    self:PlayEnter()
    self:RandomShake()
end

function KitchenIngredientView:RandomShake()
    local randomValue = math.random(2,10)
    self._timer = Invoke(function()
        AnimatorPlayHelper.Play(self.anima,{"efingredientitemidle","efingredientitemidle"},false,function()
            self:RandomShake()
        end)
    end,randomValue)
end

function KitchenIngredientView:OnDisable()
    self._firstInit = nil
    self._itemInfo = nil
    self.isFly = nil
    self:DisposeTimer()
end

function KitchenIngredientView:DisposeTimer()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
end

function KitchenIngredientView:PlayEnter()
    AnimatorPlayHelper.Play(self.anima,{"ingredient_item1","efingredientitementer"},false,nil)
end

function KitchenIngredientView:PlayExit(callback)
    if not self.isFly then
        self:DisposeTimer()
        AnimatorPlayHelper.Play(self.anima,{"efingredientitemexit","efingredientitemexit"},false,function()
            if callback then
                callback()
            end
        end)
    elseif callback then
        callback()
    end
end

function KitchenIngredientView:SetData(info)
    if self._firstInit and info then
        self._itemInfo = info
        local itemData = Csv.GetData("item",info[1])
        if itemData then
            Cache.load_sprite(AssetList[itemData.icon],itemData.icon,function(sp)
                self.icon_item.sprite = sp
            end)
        end
    end
end

function KitchenIngredientView:on_btn_item_click()
    if not self.isFly then
        self:DisposeTimer()
        self.isFly = true
        self.anima.enabled = false
        local item_go_list = {}
        table.insert(item_go_list,self.item)
        local num = math.random(1,2)
        for i = 1, num do
            local go = fun.get_instance(self.item.transform,self.go)
            table.insert(item_go_list,go)
        end
    
        Facade.SendNotification(NotifyName.FoodIngredientView.FlyIngredient,self._itemInfo[1],self.go.transform,item_go_list)
    end
    Event.Brocast(EventName.ApplicationGuide_ResetFinger,true)
end

function KitchenIngredientView:GetPosition()
    if self.go then
        return self.go.transform.position
    end
end