
local FunctionIconScrollView = Clazz()

LOBBY_ICON_POSITION = 
{
    LEFT = 1, --大厅左侧图标
    RIGHT = 2, -- 大厅右侧图标
}

LOBBY_ICON_TYPE =
{
    ACTIVITY = 1 , --活动类型图标
    SALE = 2 , --礼包类型图标
}

local topOffset = 200
local gridOffset = 200
local bottomOffset = 100


function FunctionIconScrollView:New(iconViewManager,scrollArea,iconPosition)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.iconViewManager = iconViewManager
    o.scrollArea = scrollArea
    o.iconPosition = iconPosition
    local ref = fun.get_component(scrollArea, fun.REFER)
    --部分机台独立UI 没有这个 屏蔽todo
    if not ref then
        o.todoList = true
        return
    else
        o.todoList = false
    end
    o.iconScrollView = ref:Get("iconScrollView")
    o.scrollContent = ref:Get("scrollContent")
    o.iconControlList = {}
    return o
end

function FunctionIconScrollView:RemoveIcon(name)
    local findIndex = nil
    for k , v in pairs(self.iconControlList) do
        if v.componentName == name then
            findIndex = k
            break
        end
    end
    if findIndex then
        table.remove(self.iconControlList , findIndex)
        self:OrderIcon()
    end
end

function FunctionIconScrollView:AddIcon(gameObject, funcentity , componentName , isSaleIcon)
    if self.todoList then
        return
    end
    self.isSaleIcon = isSaleIcon

    if isSaleIcon then
        table.insert(self.iconControlList ,
                {go = gameObject ,
                 funcentity = funcentity,
                 componentName = componentName,
                 iconWeight = iconWeight,
                 isSaleIcon = true
                })
    else
        local iconWeight = self.iconViewManager:GetIconWight(componentName)
        table.insert(self.iconControlList ,
                {go = gameObject ,
                 funcentity = funcentity,
                 componentName = componentName,
                 iconWeight = iconWeight,
                 isSaleIcon = false
                })
    end
    
    table.sort(self.iconControlList , function(a,b)
        if a.isSaleIcon and b.isSaleIcon  then
            return false
        elseif a.isSaleIcon and not b.isSaleIcon then
            return false
        elseif not a.isSaleIcon and b.isSaleIcon then
            return true
        else
            return a.iconWeight < b.iconWeight
        end
    end)
    fun.set_parent(gameObject , self.scrollContent)

    gameObject.transform.localScale = Vector3.New(1,1,1)
    
    self:OrderIcon()
end

function FunctionIconScrollView:OrderIcon()
    local index = 0
    for k ,v in pairs(self.iconControlList) do
        index = index + 1
        v.go.transform:SetSiblingIndex(index)
    end
    self:SetContentSize(index)
end

function FunctionIconScrollView:SetContentSize(iconNum)
    local height = self:GetContenHeight(iconNum)
    fun.set_recttransform_native_size(self.scrollContent ,  0 , height)
end


function FunctionIconScrollView:OnEnable()
end

function FunctionIconScrollView:Dispose()
    log.log("清除图标内容 ")
    for k ,v in pairs(self.iconControlList) do
        if v and v.funcentity  then
            v.funcentity:Close()
        end 
    end
    self.iconControlList = {}
end

function FunctionIconScrollView:GetContenHeight(iconNum)
    return topOffset + (iconNum - 1) * gridOffset + bottomOffset
end




return FunctionIconScrollView