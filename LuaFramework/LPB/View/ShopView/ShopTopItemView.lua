
ShopTopItemView = BaseView:New("ShopTopItemView")
local this = ShopTopItemView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "content",
    --"items",
    "checkbox_page",
    "toggle",
    "scrollView"
}

function ShopTopItemView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.instance = o
    return o
end

function ShopTopItemView:Awake()
    self:on_init()
end

function ShopTopItemView:OnEnable()
    self._init = true
    self:SetChildItemInfo(self._info)
    Util.SetVariantScrollRectCallBack(self.scrollView,function(pos)
        self:ScrollViewCallBack(pos)
    end)
end

function ShopTopItemView:OnDisable()
    self._init = nil
    self._info = nil
end

function ShopTopItemView:on_close()

end

function ShopTopItemView:OnDestroy()
    self:Close()
    self.toggleList = nil
    self.ViewList = nil
end

function ShopTopItemView:ScrollViewCallBack(pos)
    local index = math.floor(math.ceil(math.abs(pos)) / 1032) + 1
    if self.toggleList[index] then
        self.toggleList[index].isOn = true
    end
end

function ShopTopItemView:SetChildItemInfo(info)
    self._info = info
    if not self._init then
        return
    end
    if self._info then
        local index = 1
        local count = 0
        --local itemEntitys = {}
        self.toggleList = {}
        self.ViewList = {}
        for key, value in pairs(self._info) do
            local data = Csv.GetData("shop",value.id,nil)
            local entityName = nil
            if data then
                entityName = string.format("ShopTopChildItem%s",data.icon)
            end
            if entityName then
                --local scripte = require(string.format("View/ShopView/%s",entityName))
                Cache.load_prefabs(AssetList[entityName],entityName,function(objs)
                    if objs then
                        local go = fun.get_instance(objs)
                        if go then
                            fun.set_parent(go,self.content,true)
                            local view = ShopTopItemChildView:New(value)
                            view:SkipLoadShow(go)
                            table.insert(self.ViewList,view)
                        end
                        if index == 1 then
                            local toggle = fun.get_component(self.toggle,fun.TOGGLE)
                            table.insert(self.toggleList,toggle)
                        else
                            go = fun.get_instance(self.toggle)
                            fun.set_parent(go,self.checkbox_page,true)
                            local toggle = fun.get_component(go,fun.TOGGLE)
                            table.insert(self.toggleList,toggle)
                        end
                        if index == count then
                            fun.set_active(self.toggleList[1],true)
                            self.toggleList[1].isOn = true
                        end
                        index = index + 1
                    end
                end)
                count = count + 1
            end
        end

        --[[
        for key, value in pairs(self._info) do
            local view = ShopTopItemChildView:New(value)
            view:SkipLoadShow(itemEntitys[key])
        end
        if #self.toggleList == 1 then
            fun.set_active(self.toggleList[1],false)
        else
            fun.set_active(self.toggleList[1],true)
            self.toggleList[1].isOn = true
        end
        --]]
    end
end

function ShopTopItemView:UpdateCountdown()
    if self.ViewList then
        for key, value in pairs(self.ViewList) do
            value:UpdateCountdown()
        end
    end
end