local FlyRewardEffectsView = require "View/FlyRewardEffectsView/FlyRewardEffectsView"
local FlyCommonEffectsView = FlyRewardEffectsView:New(nil,nil)
local this = FlyCommonEffectsView
this.__index = this
this.viewType = CanvasSortingOrderManager.LayerType.PackageDialog
this.NeedSetIcon = true

function FlyCommonEffectsView:New(flyItemId,flyTargetPos)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o.viewName = "FlyCommonEffectsView"
    o._flyItemId = flyItemId
    o._flyTargetPos = flyTargetPos
    return o
end

function FlyCommonEffectsView:InitFly()
    self:SetCommonIcon2(self._icon)
end

function FlyCommonEffectsView:GetFlyTargetPos()
    if self._flyItemId == Resource.taskpoint then
        return ModelList.GameActivityPassModel.GetIconPos()
    end
    return self._flyTargetPos or GetShowHeadIconPos()
end

function FlyCommonEffectsView:SetCommonIcon(icon)
    self:SetCommonIcon2(icon.sprite)
end

function FlyCommonEffectsView:SetCommonIcon2(icon)
    self._icon = icon
    if self._init then
        if self._icon then
            for i = 1, 16 do
                local img = fun.get_component(self["flyitem"..i],fun.IMAGE)
                if img then
                    img.sprite = self._icon
                end
            end
            self._icon = nil
        elseif self._flyItemId then
            self:SetCommonIcon3(self._flyItemId)
        end
    end
end

function FlyCommonEffectsView:SetCommonIcon3(itemId)
    if itemId then
        local icon = nil
        local needGetSprite = true  --是否从ItemAtlas图集加载资源
        if itemId == 39 then
            local cardId = ModelList.CityModel:GetPuBuffCardId()
            local powerCard = Csv.GetData("new_powerup", cardId)
            icon = powerCard[6]
        --elseif itemId == 40 then
        --    ---super match 券
        --    needGetSprite = false
        --    icon = Csv.GetItemOrResource(itemId, "icon")
        --    Cache.load_sprite(AssetList[icon], icon, function(tex)
        --        if self and fun.is_not_null(tex) then
        --            self:SetCommonIcon2(tex)
        --        end
        --    end)
        else
            icon = Csv.GetItemOrResource(itemId, "icon")
        end

        --log.r("itemId = "..itemId.." icon = "..icon)
        if icon and icon ~= "" and needGetSprite then
            Cache.GetSpriteByName("ItemAtlas", icon, function(sprite)
                if sprite and self then
                    self:SetCommonIcon2(sprite)
                end
            end)
        end
    end
end

function FlyCommonEffectsView:GetAnimationName()
    return "shopbuycoin"
    --return "shopbuyCommon"
end

function FlyCommonEffectsView:GetDurations()
    return {0.35,0.383,0.5,0.6,0.5,0.5,0.383,0.4,0.62,0.5,0.383,0.5,0.61,0.45,0.37,0.5,0.5}
end

return FlyCommonEffectsView
