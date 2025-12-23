
require "View/ShopView/ShopChildItemBaseView"
require "View/ShopView/ShopNormalChildItemcRuledi"
require "View/ShopView/ShopNormalChildItemcRuledi2"
require "View/ShopView/ShopNormalChildItemcRuledi3"
require "View/ShopView/ShopNormalChildItemcRuledi4"
require "View/ShopView/ShopNormalChildItemcRuledi5"
require "View/ShopView/ShopNormalChildItemcRuledi6"
local  _cPackTitile3 = require "View/ShopView/ShopNormalChildItemcPackTitile3"

ShopNormalItemView = BaseView:New("ShopNormalItemView")
local this = ShopNormalItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "content",
    "img_placeholder"
}

function ShopNormalItemView:New(shopItem1,shopItem2)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._shopItem1 = shopItem1
    o._shopItem2 = shopItem2
    return o
end

function ShopNormalItemView:Awake()
    self:on_init()
end

function ShopNormalItemView:OnEnable()
    if self.ViewList == nil then
        self:CreatChild(self._shopItem1)
        if self._shopItem2 then
            self:CreatChild(self._shopItem2)
        else
            fun.set_active(self.img_placeholder,true,false)
            self.img_placeholder.transform:SetSiblingIndex(1)
        end
    end
end

function ShopNormalItemView:CreatChild(itemData)
    if itemData then
        if self.ViewList == nil then
            self.ViewList = {}
        end
        local data = Csv.GetData("shop",itemData.id,nil)
        local entityName = nil
        if data then
            entityName = string.format("ShopNormalChildItem%s",data.icon)
        end
        if entityName then
            local scripte = require(string.format("View/ShopView/%s",entityName))
            --log.r("========================>>scripte " .. string.format("View/CommonView/%s",entityName))
            Cache.load_prefabs(AssetList[entityName],entityName,function(objs)
                if objs then
                    local go = fun.get_instance(objs)
                    if go then
                        fun.set_parent(go,self.content,true)
                        local shopItem = scripte:New(itemData)
                        shopItem:SkipLoadShow(go)
                        table.insert(self.ViewList,shopItem)
                        --self.go.transform.sizeDelta = Vector2.New(go.transform.sizeDelta.x,go.transform.sizeDelta.y)
                    end
                end
            end)
        end
    end
end

function ShopNormalItemView:UpdateCountdown()
    if self.ViewList then
        for key, value in pairs(self.ViewList) do
            value:UpdateCountdown()
        end
    end
end

function ShopNormalItemView:OnDisable()
    
end

function ShopNormalItemView:on_close()
    self._shopItem1 = nil
    self._shopItem2 = nil
    self.ViewList = nil
end

function ShopNormalItemView:OnDestroy()
    self:Close()
end