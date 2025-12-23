
IngredientItemView = BaseView:New("IngredientItemView")
local this = IngredientItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_ingredient",
    "text_num",
    "anima"
}

function IngredientItemView:New(info)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._itemInfo = info
    return o
end

function IngredientItemView:Awake()
    self:on_init()
end

function IngredientItemView:OnEnable()
    self._firstInit = true
    self:UpdataInfo()
    Event.AddListener(EventName.Event_UpdateItems,self.UpdataInfo,self)

    self:PlayEnter(self._enter_callback)
end

function IngredientItemView:PlayEnter(callback)
    self._enter_callback = callback
    if self._firstInit then
        AnimatorPlayHelper.Play(self.anima,{"efingredients","efingredientsenter"},true,function()
            if callback then
                callback()
            end
        end)
    end
end

function IngredientItemView:PlayExit(callback)
    if self._firstInit then
        AnimatorPlayHelper.Play(self.anima,{"efingredientsexit","efingredientsexit"},false,function()
            if callback then
                callback()
            end
        end)
    end
end

function IngredientItemView:UpdataInfo()
    if self._itemInfo then
        self:Refresh()
    end
end

function IngredientItemView:Refresh()
    self:SetData(self._itemInfo)
end

function IngredientItemView:SetData(info)
    self._itemInfo = info
    if self._firstInit and info then
        local itemData = Csv.GetData("item",info[1])
        if itemData then
            Cache.load_sprite(AssetList[itemData.icon],itemData.icon,function(sp)
                if not self:IsLifeStateDisable() then
                    self.icon_ingredient.sprite = sp
                end
            end)
            local itemsNum = ModelList.ItemModel:GetItemNumById(info[1])
            local needNum = info[2]
            self._isActive = itemsNum >= needNum
            if self._isActive then
                self.text_num.text = string.format("<color=#058204ff>%s/%s</color>",itemsNum,needNum)
            else
                self.text_num.text = string.format("<color=#9b0505ff>%s</color>/%s",itemsNum,needNum)
            end
            Util.SetUIImageGray(self.icon_ingredient.gameObject, not self._isActive)
        end
    end
end

function IngredientItemView:GetIngredientIcon()
    if self.img_icon then
        return self.img_icon.sprite
    end
    return nil
end

function IngredientItemView:GetIngredientIconPos()
    if self.img_icon then
        return self.img_icon.transform.position
    end
    return nil
end

function IngredientItemView:IsActive()
    return self._isActive or false
end

function IngredientItemView:OnDisable()
    Event.RemoveListener(EventName.Event_UpdateItems,self.UpdataInfo,self)
end

function IngredientItemView:on_close()
    -- body
end

function IngredientItemView:OnDestroy()
    self:Close()
    self._firstInit = nil
    self._enter_callback = nil
    self._itemInfo = nil
end