--- 切换卡牌界面
---@class GameBingoSwitchView
local GameBingoSwitchView = BaseChildView:New();
local this = GameBingoSwitchView;
GameBingoSwitchView.__index = GameBingoSwitchView

this.auto_bind_ui_items = {
    "btn_switch",
    "btn_mask",
    "MapRoot1",
    "MapRoot2",
}

--- 创建新switchView
function GameBingoSwitchView:New(name )
    local o = {name = name}
    setmetatable(o,{__index = GameBingoSwitchView})
    return o
end

function GameBingoSwitchView:Init(switchViewObj, parentView)
    if not switchViewObj then
        return
    end
    self:on_init(switchViewObj,parentView)
    self:RegisterEvent()
end

function GameBingoSwitchView:OnDestroy()
    if self then
        self.mapOriginData = nil
        self.isChanging = nil
        self:UnRegisterEvent()
        self:Close()
        self:Destroy()
    end
end

function GameBingoSwitchView:RegisterEvent()
    Event.AddListener(EventName.Switch_View_Start_Show, self.ShowView, self)
    Event.AddListener(EventName.Switch_View_End_Show, self.EndShowView, self)
end

function GameBingoSwitchView:UnRegisterEvent()
    Event.RemoveListener(EventName.Switch_View_Start_Show, self.ShowView, self)
    Event.RemoveListener(EventName.Switch_View_End_Show, self.EndShowView, self)
end

function GameBingoSwitchView:ShowView(cb)
    local onlyShow2Card = fun.read_value(BingoBangEntry.selectGameCardNumString, BingoBangEntry.selectGameCardNum.FourCard)
    onlyShow2Card = onlyShow2Card == BingoBangEntry.selectGameCardNum.TwoCard
    if not onlyShow2Card then
        --未开启只显示2卡
        return fun.SafeCall(cb)
    end

    self:CacheMapOriginPos()
    
    fun.set_active(self.go, true)
    self:ChangeMapRoot(1, 3)
    self:ChangeMapRoot(2, 4)
    fun.SafeCall(cb)
end

function GameBingoSwitchView:EndShowView()
    Event.Brocast(EventName.Switch_View_Before)
    
    fun.set_active(self.MapRoot1, false)
    fun.set_active(self.MapRoot2, false)
    
    table.walk(self.mapOriginData, function(mapData)
        --还原
        --fun.set_parent(mapData.mapObj, mapData.mapOriginRoot)
        fun.set_gameobject_pos(mapData.mapObj, mapData.OriginPos.x, mapData.OriginPos.y, mapData.OriginPos.z)
        fun.set_gameobject_scale(mapData.mapObj, mapData.mapOriginScale.x, mapData.mapOriginScale.y, mapData.mapOriginScale.z)
    end)
end

function GameBingoSwitchView:CacheMapOriginPos()
    self.mapOriginData = {}
    for i = 1, 6 do
        local mapObj = self.parentView["BingoMap"..i]
        if not IsNull(mapObj) then
            fun.set_active(mapObj, true)
            fun.SetAsLastSibling(mapObj.gameObject)
            self.mapOriginData[i] = {
                mapObj = mapObj,
                OriginPos = fun.get_gameobject_pos(mapObj),
                mapOriginScale = fun.get_gameobject_scale(mapObj, true),
                mapOriginRoot = mapObj.transform.parent,
            }
        end
    end
    self.map1OriginPos = fun.get_gameobject_pos(self.parentView.BingoMap1)
    self.map2OriginPos = fun.get_gameobject_pos(self.parentView.BingoMap2)
    
    self.mapRoot = self.parentView.MapRootPos
end

---将第maxIndex张卡，移动到小地图的第root个位置
function GameBingoSwitchView:ChangeMapRoot(root, maxIndex)
    log.r("[GameBingoSwitchView] ChangeMapRoot1 maxIndex:", maxIndex)
    if not maxIndex then
        return
    end
    
    local variableName = string.format("root%sMapIndex", root)  --小地图第n个位置显示的哪个卡片
    local rootCtrlName = string.format("MapRoot%s", root)       --小地图第n个位置的对象
    local mapOriginPos = string.format("map%sOriginPos", root)
    log.r("[GameBingoSwitchView] ChangeMapRoot1 variableName:", variableName)
    log.r("[GameBingoSwitchView] ChangeMapRoot1 rootCtrlName:", rootCtrlName)
    log.r("[GameBingoSwitchView] ChangeMapRoot1 mapOriginPos:", mapOriginPos)
    if not self[rootCtrlName] then
        return
    end
    
    self.isChanging = true
    
    --1->3, 3->1, 2->4, 4->2
    local mapData = self.mapOriginData[self[variableName]]
    if mapData and self[mapOriginPos] then
        --还原到初始位置
        --if not IsNull(self.mapRoot) then
            --fun.set_parent(mapData.mapObj, self.mapRoot)
        --else
        --    fun.set_parent(mapData.mapObj, mapData.mapOriginRoot)
        --end
        fun.set_gameobject_pos(mapData.mapObj, self[mapOriginPos].x, self[mapOriginPos].y, self[mapOriginPos].z)
        fun.set_gameobject_scale(mapData.mapObj, mapData.mapOriginScale.x, mapData.mapOriginScale.y, mapData.mapOriginScale.z)
        
        --LuaTimer:SetDelayFunction(0.5, function()
            Event.Brocast(Notes.CARD_COLLIDER_OPEN_BY_ID, self[variableName], true)
        --end)
    end

    Event.Brocast(Notes.CARD_COLLIDER_OPEN_BY_ID, maxIndex, false)
    self[variableName] = maxIndex
    mapData = self.mapOriginData[maxIndex]
    if mapData then
        fun.set_active(mapData.mapObj, true)
        --fun.set_parent(mapData.mapObj, self[rootCtrlName], true)
        fun.set_same_position_with(mapData.mapObj, self[rootCtrlName])
        fun.set_gameobject_scale(mapData.mapObj, 0.25, 0.25, 1)
    end

    self.isChanging = false
end

function GameBingoSwitchView:on_btn_mask_click()
    self:on_btn_switch_click()
end

local temp = false
function GameBingoSwitchView:on_btn_switch_click()
    if self.isChanging then
        log.r("[GameBingoSwitchView] on_btn_switch_click, isChanging")
    end
    
    if BingoBangEntry.IsInBattleSettle then
        log.r("[GameBingoSwitchView] on_btn_switch_click, IsInBattleSettle return")
        return
    end
    
    UISound.play("cardswitch")
    
    Event.Brocast(EventName.Switch_View_Before)
    if temp then
        self:ChangeMapRoot(1, 3)
        self:ChangeMapRoot(2, 4)
        temp = false
    else
        self:ChangeMapRoot(1, 1)
        self:ChangeMapRoot(2, 2)
        temp = true
    end
    Event.Brocast(EventName.Switch_View_After)
end

return this
