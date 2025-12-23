local ClubGiftPacketHelpView = BaseView:New('ClubGiftPacketHelpView',"ClubAtlas");

local this = ClubGiftPacketHelpView

function ClubGiftPacketHelpView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


this.auto_bind_ui_items = {
  "btn_close",
  "btn_claim",
  "Toggle",
  "Text", --说明1 
  "Text1",--说明2
  "Text2",--说明3
  "Text2",--说明4
  "Text3",--说明4
}

function ClubGiftPacketHelpView.Awake(obj, obj2)
    this:on_init()
end

function ClubGiftPacketHelpView.OnEnable()
   this:initData()
    --this:RebindSprite()
   
end

function ClubGiftPacketHelpView:initData()

    self.Text.text = Csv.GetDescription(30069)
    self.Text1.text = Csv.GetDescription(30070)
    self.Text2.text = Csv.GetDescription(30071)

end 

function ClubGiftPacketHelpView.OnDisable()
    Event.Brocast(EventName.Event_popup_GameHallHelp_finish)
end

function ClubGiftPacketHelpView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end


function ClubGiftPacketHelpView:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end


--function ClubGiftPacketHelpView:RebindSprite()
--    if self.btn_claim then
--        local img = fun.get_component(self.btn_claim,fun.IMAGE)
--        if img then
--            img.sprite = AtlasManager:GetSpriteByName("TaskAtlas","rButton")
--        end
--    end
--end


function ClubGiftPacketHelpView.OnDestroy()
    this:Destroy()
end

return this 