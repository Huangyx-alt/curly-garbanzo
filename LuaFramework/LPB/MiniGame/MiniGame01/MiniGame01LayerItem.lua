MiniGame01LayerItem = BaseView:New("MiniGame01LayerItem")
local this = MiniGame01LayerItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local extraLayerData = nil

this.auto_bind_ui_items = {
    "circle1",
    "circle2",
    "circle3",
    "bg",
    "text_level"
}

function MiniGame01LayerItem:New(index)
    local o = {}
    self.__index = self
    o._number = index
    setmetatable(o,self)
    return o
end

function MiniGame01LayerItem:Awake()
    self:on_init()
end

function MiniGame01LayerItem:OnEnable()
    self:SetLayerInfo()
end

function MiniGame01LayerItem:OnDisable()
    self._number = nil
    self.extraReward = nil
    extraLayerData = nil
end

function MiniGame01LayerItem:SetLayerInfo()
    self.text_level.text = tostring(self._number)
    local curLayerNum = ModelList.MiniGameModel:GetCurrentLayerNum()
    local layerData = ModelList.MiniGameModel:GetLayerInfo(self._number)
    if layerData then
        fun.set_active(self.circle1,layerData.layNo < curLayerNum)
        fun.set_active(self.circle2,layerData.layNo > curLayerNum)
        fun.set_active(self.circle3,layerData.layNo == curLayerNum)
        self.text_level.color = (layerData.layNo < curLayerNum and {Color.New(0.784,0.784,0.784,1)} or {Color.New(0.196,0.196,0.196,1)})[1]
        local bg_name = nil
        if 0 == layerData.background then
            bg_name = "MiniJinduYellow"
        elseif 1 == layerData.background then
            bg_name = "MiniJinduGreen"
        elseif 2 == layerData.background then
            bg_name = "MiniJinduBlue"
        elseif 3 == layerData.background then
            bg_name = "MiniJinduPurple"
        end
        Cache.SetImageSprite("MiniGame01Atlas",bg_name,self.bg)
        extraLayerData = ModelList.MiniGameModel:GetExtraLayer(extraLayerData)
        if layerData.layNo == extraLayerData[2] then
            if not self.extraReward then
                local go = MiniGame01View:GetExtraReward()
                local pos = self.transform.localPosition
                fun.set_gameobject_pos(go,pos.x,pos.y,pos.z,true)
                self.extraReward = ExtraRewardView:New(layerData.extraReward[1])
                self.extraReward:SkipLoadShow(go)
            else
                fun.set_active(self.extraReward.transform,true)
            end
        elseif self.extraReward then
            fun.set_active(self.extraReward.transform,false)
        end
    end
end

function MiniGame01LayerItem:GetLocalPosition()
    if self.transform then
        return self.transform.localPosition
    end
    return Vector3.New(0,0,0)
end

function MiniGame01LayerItem:GetGlobalPosition()
    if self.transform then
        return self.transform.position
    end
    return Vector3.New(0,0,0)
end

function MiniGame01LayerItem:IsShowlayerTips()
    local layerData = ModelList.MiniGameModel:GetLayerInfo(self._number)
    return layerData and 0 == layerData.background
end

function MiniGame01LayerItem:IsShowStageTips()
    local layerData = ModelList.MiniGameModel:GetLayerInfo(math.max(self._number - 1,1))
    return layerData and 0 == layerData.background
end