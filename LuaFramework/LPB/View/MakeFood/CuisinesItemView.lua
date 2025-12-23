
CuisinesItemView = BaseView:New("CuisinesItemView")
local this = CuisinesItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "toggle",
    "icon_product",
    "text_cuisines",
    "anima",
    "img_reddot",
    "slider"
}

function CuisinesItemView:New(data,index)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._cuisinesId = data
    o._index = index
    return o
end

function CuisinesItemView:Awake()
    self:on_init()
end

function CuisinesItemView:OnEnable()
    self._init = true
    self:SetInfo()
    self:SetInteractive(false)
    self.luabehaviour:AddToggleChange(self.toggle.gameObject, function(go,check)
        self:OnToggleValueChange(go,check)
        if check then
            self.anima:SetTrigger("Selected")
        else
            self.anima:SetTrigger("Normal")
        end
    end)

    self:RegisterRedDotNode()
end

function CuisinesItemView:RegisterRedDotNode()
    RedDotManager:RegisterNode(RedDotEvent.cuisines_reddot_event,"cuisines_item",self.img_reddot,self._cuisinesId)
end

function CuisinesItemView:UnRegisterRedDotNode()
    RedDotManager:UnRegisterNode(RedDotEvent.cuisines_reddot_event,"cuisines_item",self._cuisinesId)
end

function CuisinesItemView:Refresh()
    self:SetInfo()
end

function CuisinesItemView:SetInfo()
    if self._cuisinesId then
        local data = Csv.GetData("city_recipe",self._cuisinesId)
        if data then
            Cache.load_sprite(AssetList[data.icon],data.icon,function(sp)
                if not self:IsLifeStateDisable() then
                    self.icon_product.sprite = sp
                end
            end)
            local cuisine_name = Csv.GetData("description",data.name_description,"description")
            self.text_cuisines.text = cuisine_name

            local count = 0
            local available = 0
            for key, value in pairs(data.item) do
                count = count + value[2]
                available = available + math.min(ModelList.ItemModel:GetItemNumById(value[1]), value[2])
            end
            self.slider.value = available / count
        end
    end
end

function CuisinesItemView:OnToggleValueChange(go,check)
    --log.r("======================================>>CuisinesItemView:OnToggleValueChange " .. tostring(check))
    if check then
        --log.r("=====================>>self._cuisinesId " .. self._cuisinesId)
        Facade.SendNotification(NotifyName.FoodIngredientView.ChangeCuisinesItem,self._cuisinesId)
        UISound.play("food_switch")
    end
end

function CuisinesItemView:GetCuisinesIcon()
    if self.icon_product then
        return self.icon_product.sprite
    end
    return nil
end

function CuisinesItemView:GetCuisinesId()
    return self._cuisinesId or 0
end

function CuisinesItemView:GetCuisinesIndex()
    return self._index or 1
end

function CuisinesItemView:GetIsLock()
    return self._isLock or false
end

function CuisinesItemView:SetInteractive(interactive)
    --self.toggle.interactable = interactive --去掉了，会影响toggle响应点击
end

function CuisinesItemView:ChangeCuisines(interactive)
    if not self.toggle.isOn then
        self:SetInteractive(interactive)
    end
end

function CuisinesItemView:ToggleOn()
    if self.toggle then
        self.toggle.isOn = true
    end
end

function CuisinesItemView:OnDisable()
    self.luabehaviour:RemoveClick(self.toggle.gameObject)
    self:UnRegisterRedDotNode()
    self._cuisinesId = nil
end

function CuisinesItemView:on_close()
    -- body
end

function CuisinesItemView:OnDestroy()
    self:Close()
end