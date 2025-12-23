local BaseRedDot = require("RedDot/BaseRedDot")
local ClubRedDot = Clazz(BaseRedDot,"ClubRedDot")
local this = ClubRedDot
local private = {}

function ClubRedDot:Check(node, param)
    self:SetSingleNodeActive(node, ModelList.ClubModel:HaveReaDot())
    
    local isClubOpen = ModelList.ClubModel.IsClubOpen()
    if isClubOpen and node.param == "club_gift_tip" then
        local giftLevel = ModelList.ClubModel:GetClubGiftHighestLevel()
        if giftLevel > 0 then
            local image = private.OnResEnterGame(self, node)
            if fun.is_not_null(image) then
                fun.set_active(image, true)

                local iconName = "LH02"
                if giftLevel == 2 then
                    iconName = "LH01"
                elseif giftLevel == 1 then
                    iconName = "LH08"
                end
                Cache.SetImageSprite("ItemAtlas", iconName, image, true)
            end
        else
            local image = private.OnResEnterGame(self, node)
            fun.set_active(image, false)
        end
    end
end

function ClubRedDot:Refresh(nodeList, param)
    for key, value in pairs(nodeList) do
        self:Check(value,param)
    end
end

---------------------------------------------------------------

function private.OnResEnterGame(self, redNode)
    if fun.is_null(redNode.icon) then
        return
    end
    
    if fun.is_not_null(self.club_gift_tip) then
        return self.club_gift_tip
    end
    
    local image = redNode.icon.transform.parent:Find("club_gift_tip")
    if not image then
        if fun.is_null(redNode.icon) then
            return
        end
        image = UnityEngine.GameObject.Instantiate(redNode.icon)
        if not image then return end
        image.gameObject.name = "club_gift_tip"
        fun.set_parent(image, redNode.icon.transform.parent, true)
        fun.set_rect_local_pos(image, -36, -24.4, 0)
        fun.set_gameobject_scale(image.gameObject, 0.2, 0.2, 1)
    end
    image = fun.get_component(image, fun.IMAGE)
    self.club_gift_tip = image
    return self.club_gift_tip
end

return this