--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2021-02-20 10:26:12


    机台区
    机台顶  1000+ 
    机台 0-100   机台内范围不能超过100,主要是为了不大范围修改,
        icon功能区   90+  干涉UI
        spine动画区  50+  目前暂时不干涉UI
        转轴区   0+  目前暂时不干涉UI
    机台底  1000+


    机台内弹窗 2000
    全屏转场 3000
    Tips  4000
    ErrorDialog  5000
]]

CanvasSortingOrderManager = {}

local this = CanvasSortingOrderManager
local layerMaxOrder = {}
local layerOrderMapping = {}
local ExclusionList = {
    "FlyCoinEffectsView",
    "FlyGemsEffectsView",
    "FlyItemEffectsView",
    "FlyVipExpView",
    "FlyVipExpEffectsView",
    "FlyCommonEffectsView",
    "FlyRocketEffectsView",
}

CanvasSortingOrderManager.LayerType = {
    None = "None",   --子节点,不需要处理,比如像TopView里面嵌入了CladdingPanelView,及SettingListView,这两个是已经 处理过了,只需要将ViewType设置成None
    Machine_Dialog = "Machine_Dialog",
    Shop_Dialog = "Shop_Dialog",
    TopConsole = "TopConsole",
    PackageDialog = "PackageDialog",
    Popup_Dialog = "Popup_Dialog",
    ErrorDialog = "ErrorDialog",
    DebugDialog = "DebugDialog",
    Tips = "Tips",
}

CanvasSortingOrderManager.LayerBaseOrder = {
    Machine_Dialog = 0,
    Shop_Dialog = 9900,
    TopConsole    = 10000,
    PackageDialog = 22000,       --推销礼包层级
    Popup_Dialog = 23000,        --通用弹窗层级
    ErrorDialog = 24000,         -- 错误提示层级
    DebugDialog = 25000,         --Debug层级
    Tips = 32000,                --tip
}

function CanvasSortingOrderManager.Clean()
    layerMaxOrder = {}
    layerOrderMapping = {}
end

function CanvasSortingOrderManager.RecycleLayerOrder(LayerType,obj)
    --log.r("===============================>>RecycleLayerOrder " .. obj.name)
    if(fun.is_null(obj) or LayerType == this.LayerType.None)then
        return 
    end
    if(obj and not fun.is_null(obj) and obj.name and layerOrderMapping[obj.name])then  
          --local order = layerOrderMapping[obj.name]
          layerOrderMapping[obj.name] = nil
    end
    --关闭不需要调整了，一直往上增加吧，每个层2000够用了，切换场景再设置回初始值
end


function CanvasSortingOrderManager.SetLayerOrder(LayerType,obj)
    
    if(fun.is_null(obj) or LayerType == this.LayerType.None)then 
        return 
    end
    -- 不支持同时多个相同特效，屏蔽掉
    if(obj and obj.name and layerOrderMapping[obj.name]~=nil)then
        if not fun.is_include(obj.name,ExclusionList) then
            return
        end
    end
    local curValue = layerMaxOrder[LayerType] or this.LayerBaseOrder[LayerType]
    curValue = fun.set_sorting_order_relative(obj,curValue)
    layerOrderMapping[obj.name] = curValue
    layerMaxOrder[LayerType] = math.min(curValue,this.LayerBaseOrder[LayerType] + 1999)
    --log.y("SetLayerOrder")
    ModelList.ApplicationGuideModel:ChangeViewSortLayer()
end


function CanvasSortingOrderManager.IsViewBackGround(LayerType,obj)

    if(fun.is_null(obj) or LayerType == this.LayerType.None)then
        return false
    end
    local viewValue = layerOrderMapping[obj.name]
    if not viewValue then return false end
    for k,v in pairs(layerOrderMapping) do
        if v > viewValue and k~= "TopConsoleView" and k~="FunctionShowTipView" then
            if ViewList[k] and ViewList[k].go and fun.get_active_self(ViewList[k].go) then
                return true
            end
        end
    end
    return false
end
   