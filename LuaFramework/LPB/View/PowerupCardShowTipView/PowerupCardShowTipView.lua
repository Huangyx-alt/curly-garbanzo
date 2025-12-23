
PowerupCardShowTipView = BaseView:New("PowerupCardShowTipView","PowerupHelperAtlas")
local this = PowerupCardShowTipView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

local evntsystem = UnityEngine.EventSystems.EventSystem
local input = UnityEngine.Input
local keyCode = UnityEngine.KeyCode

local isEnable = nil

this.auto_bind_ui_items = {
    "img_icon",
    "img_quality",
    "text_name",
    "text_describe",
    "img_panel",
    "anima"
}

function PowerupCardShowTipView:Awake()
    self.update_x_enabled = true
    self:on_init()
end

function PowerupCardShowTipView:OnEnable(params)
    if params then
        self:SetPowerupCardInfo(params.cardId,params.pos)
        isEnable = true
    end
end

function PowerupCardShowTipView:Promote(params)
    if params and isEnable then
        self:SetPowerupCardInfo(params.cardId,params.pos)
    end
end

function PowerupCardShowTipView:on_x_update()
    if input.GetKeyUp(keyCode.Mouse0) then
        local curSelectGo = evntsystem.current.currentSelectedGameObject
        if curSelectGo == nil or curSelectGo.name ~= "btn_card" then
            Facade.SendNotification(NotifyName.CloseUI,this)
        end
    end
end

function PowerupCardShowTipView:SetPowerupCardInfo(cardId,pos)
    if cardId then
        local powerCard = Csv.GetData("new_powerup",cardId)
        if powerCard then
            self.img_icon.sprite = AtlasManager:GetSpriteByName("ItemAtlas",powerCard.icon)
            self.text_name.text = powerCard.name
            self.text_describe.text = Csv.GetData("description",powerCard.description,"description")
            if powerCard.level == 1 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pGood")
            elseif powerCard.level == 2 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pGreat")
            elseif powerCard.level == 3 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas","pEpic")
            elseif powerCard.level == 6 then
                self.img_quality.sprite = AtlasManager:GetSpriteByName("PowerupHelperAtlas", "pLegend")
            end
        end
    end
    self:SetPosition(pos)

    AnimatorPlayHelper.Play(self.anima,"PowerupCardShowTipViewenter",false,nil)
end

function PowerupCardShowTipView:OnDisable()
    isEnable = nil
end

function PowerupCardShowTipView:on_close()

end

function PowerupCardShowTipView:OnDestroy()

end

function PowerupCardShowTipView:SetPosition(pos)
 
    if self.img_panel and pos then
  
        fun.set_gameobject_pos(self.go,pos.x,pos.y + 1,pos.z,false)
    end
end

this.NotifyList = 
{

}

return this;