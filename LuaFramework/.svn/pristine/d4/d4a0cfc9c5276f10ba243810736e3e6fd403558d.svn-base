local HallExplainHelpView = BaseView:New('HallExplainHelpView' );

local this = HallExplainHelpView
this.isCleanRes = true
function HallExplainHelpView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end


this.auto_bind_ui_items = {
  "btn_mask",
  "btn_close",
  "btn_claim",
  "Toggle",
  "Text", --说明1 
  "Text1",--说明2
  "Text2",--说明3
  "Text2",--说明4
  "Text3",--说明4

  -----------城市说明特有
  "CityTitle",
--   "GuangBg2",
--   "GuangBg3",
  "BingoImg",
  "JokeImg",
  "GetImg",
  "guang3",
  "guang1",
  "guang2"
}

function HallExplainHelpView.Awake(obj, obj2)
    this:on_init()
end

function HallExplainHelpView.OnEnable()
    this:initData()
    --this:RebindSprite()
    this:SetMask()
end

function HallExplainHelpView:initData()
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local playType = Csv.GetData("new_city_play", playid, "play_type")
    local playerInfo = ModelList.PlayerInfoModel:GetUserInfo()
    local helpSetting = Csv.GetData("new_game_help_setting", playid)

    table.each(helpSetting and helpSetting.help_text_id, function(desID, k)
        if desID == 0 then return end
        k = k == 1 and "" or k - 1
        local textCtrlName = string.format("Text%s", k)
        if self[textCtrlName] then
            self[textCtrlName].text = Csv.GetDescription(desID)
        end
    end)
    
    if playType == PLAY_TYPE.PLAY_TYPE_NORMAL then
        --self:ChangeCityHelp()
    --elseif playType == PLAY_TYPE.PLAY_TYPE_COCKTAIL then
    --    ModelList.GuideModel:OpenUI("HawaiiHelpView")
    end

    self.luabehaviour:AddToggleChange(self.Toggle.gameObject, function(go, check)
        self:SetHelpToggle(check)
    end)
    local value = fun.read_value("howHallHelp" .. tostring(playid) .. "uid" .. playerInfo.uid, nil)
    if not value or value == 0 then
        self.Toggle.isOn = false
    else
        self.Toggle.isOn = true
    end
end 

function HallExplainHelpView.OnDisable()
    Event.Brocast(EventName.Event_popup_GameHallHelp_finish)
end

function HallExplainHelpView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function HallExplainHelpView:on_btn_claim_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function HallExplainHelpView:on_btn_mask_click()
    if os.time() - this.openTime > 2 then
        Facade.SendNotification(NotifyName.CloseUI,this)
    end
end

function HallExplainHelpView:SetHelpToggle(check)
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local playType =  Csv.GetData("new_city_play",playid,"play_type")
    local playerInfo =  ModelList.PlayerInfoModel:GetUserInfo()
    if check then 
        fun.save_value("howHallHelp"..tostring(playid) .."uid"..playerInfo.uid,1)
    else 
        fun.save_value("howHallHelp"..tostring(playid).."uid"..playerInfo.uid,0)
    end 
end

--function HallExplainHelpView:RebindSprite()
--    if self.btn_claim then
--        local img = fun.get_component(self.btn_claim,fun.IMAGE)
--        if img then
--            img.sprite = AtlasManager:GetSpriteByName("TaskAtlas","rButton")
--        end
--    end
--end

function HallExplainHelpView:ChangeCityHelp()
    local playid = ModelList.CityModel.GetPlayIdByCity()
    local helpSetting = Csv.GetData("new_game_help_setting", playid)
    local playJokerCardsNum = Csv.GetPlayJokerCardsNum(playid)
    if not helpSetting then
        --默认配置
        helpSetting = {
            tile="CityTitle01",
            img = "CityBingo01",
            joke = "CityJN01",
            bingo = "CityJoker02",
            guang = "CityBG01",
            tc = {r=235,g=236,b=255},
            oc = {r=104,g=15,b=252},
        }
    end
    
    self.Text.text = string.format("<color=#ffe956><size=90>%s</size></color> JOKER CARDS!", playJokerCardsNum)
    
    local outline = fun.get_component(self.Text1,fun.OUT_LINE)
    local outline2 = fun.get_component(self.Text2,fun.OUT_LINE)
    local effectColor = Color.New(helpSetting.oc[1]/255, helpSetting.oc[2]/255, helpSetting.oc[3]/255, 1)
    outline.effectColor = effectColor
    outline2.effectColor = effectColor
    
    local textColor = Color.New(helpSetting.tc[1]/255, helpSetting.tc[2]/255, helpSetting.tc[3]/255, 1)
    self.Text2.color = textColor
    self.Text1.color = textColor

    Cache.Load_Atlas(AssetList["HallMainHelpAtlas"],"HallMainHelpAtlas",function() 
        --设置图片
        self.CityTitle.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.title)
        self.CityTitle:SetNativeSize()
        fun.set_gameobject_scale(self.CityTitle.gameObject, 2, 2, 1, true)
        self.BingoImg.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.img)
        self.BingoImg:SetNativeSize()
        fun.set_gameobject_scale(self.BingoImg.gameObject, 1.8, 1.8, 1, true)
        self.JokeImg.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.bingo)
        self.JokeImg:SetNativeSize()
        fun.set_gameobject_scale(self.JokeImg.gameObject, 1.8, 1.8, 1, true)
        self.GetImg.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.joke)
        self.GetImg:SetNativeSize()
        fun.set_gameobject_scale(self.GetImg.gameObject, 1.5, 1.5, 1, true)

        self.guang3.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.guang)
        self.guang1.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.guang)
        self.guang2.sprite = AtlasManager:GetSpriteByName("HallMainHelpAtlas",helpSetting.guang)
    end )
  
end

function HallExplainHelpView:OnDestroy()
    this:Destroy()
end

function HallExplainHelpView:SetMask()
    fun.set_active(this.btn_close, false)
    this.openTime = os.time()
    
end

return this 