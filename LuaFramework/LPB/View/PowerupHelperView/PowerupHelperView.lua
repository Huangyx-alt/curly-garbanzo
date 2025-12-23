local PowerupHelperItem = require "View/PowerupHelperView/PowerupHelperItem"

local PowerupHelperView = BaseView:New("PowerupHelperView","PowerupHelperAtlas")
local this = PowerupHelperView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "item",
    "btn_close",
    "text_tip",
    "content",
    "btn_right",
    "btn_left",
    "fanye01",
    "fanye02",
    "Title1",
    "Title2"
}

--key规则：普通小丑卡数量、黑金小丑卡数量 做拼接
local cardImg={
    ["30"] = "pPowerXC",
    ["40"] = "pPowerXC1",
    ["41"] = "pPowerXC2",
    ["42"] = "pPowerXC3",
    ["43"] = "pPowerXC4",
    ["34"] = "pPowerXC5",
    ["25"] = "pPowerXC6",
    ["16"] = "pPowerXC7",
    ["07"] = "pPowerXC8",
}

local _itemList = {}
function PowerupHelperView:Awake(obj)
    self:on_init()
end

function PowerupHelperView:OnEnable(params)

    if params then 
        self:ChangeArrow(false)
        fun.set_active(self.btn_left,false)
        fun.set_active(self.btn_right,false)
        fun.set_active(self.fanye01.transform.parent,false)
        fun.set_active(self.fanye02.transform.parent,false)
        fun.set_active(self.fanye02,false)
    else 
        self:ChangeArrow(true)
        
        local showKey, totalCount = self:GetJokerCardShowKey()
        local imageName = cardImg[showKey]
        local refer = fun.get_component(self.Title2,fun.REFER)
        local node = refer:Get("pClownBig")
        refer:Get("img_power").sprite  = AtlasManager:GetSpriteByName("PowerupHelperAtlas", imageName) 

        --pu的小丑卡数量
        for i =1,tonumber(totalCount)  do
            local signObj = fun.find_child(node, tostring(i))
            fun.set_active(signObj, true)
        end
    end 
   
end

function PowerupHelperView:OnDisable()

end

function PowerupHelperView:on_close()
    _itemList = {}
end

function PowerupHelperView:ClearMailList()
	for i, v in pairs(_itemList) do
	    v:Close()
	end
    _itemList ={}
end

function PowerupHelperView:OnUpDateMailList(flag)

    this:ClearMailList()

    local cards = nil
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if flag == false then        
        cards = DeepCopy(Csv.GetData("city_play",playId,"power_up_card"))
        self:RebuildCardList(cards)
        self.text_tip.text = Csv.GetData("description",1,"description")
    else      
     
        cards = Csv.GetData("city_play",playId,"joker")
        self.text_tip.text = Csv.GetData("description",23,"description")
    end 

   for _, value in ipairs(cards) do
        local go = fun.get_instance(self.item,self.content)
        local item = PowerupHelperItem:New(value)
        item:SkipLoadShow(go)
        fun.set_active(go.transform,true)
        table.insert(_itemList,item)
    end
end

function PowerupHelperView:RebuildCardList(cards)
    --赛季PU
    if ModelList.CityModel:CanCurPlayUsePuBuff() and ModelList.CityModel:GetPuBuffRemainTime() > 0 then
        local cardId = ModelList.CityModel:GetPuBuffCardId()
        --[[undo wait delete for test
        cardId = 801    
        --]]
        if cardId then
            table.insert(cards, 1, cardId)
        end
    end
end

function PowerupHelperView:OnDestroy()

end

function PowerupHelperView:on_btn_right_click()
    self:ChangeArrow(true)
end

function PowerupHelperView:on_btn_left_click()
    self:ChangeArrow(false)
end

function PowerupHelperView:ChangeArrow(flag)
    if flag then 
        fun.set_active(self.btn_right,false)
        fun.set_active(self.btn_left,true)
        fun.set_active(self.fanye01,false)
        fun.set_active(self.fanye02,true)
        fun.set_active( self.Title2,true)
        fun.set_active( self.Title1,false)
    else 
        fun.set_active(self.btn_right,true)
        fun.set_active(self.btn_left,false)
        fun.set_active(self.fanye01,true)
        fun.set_active(self.fanye02,false)
        fun.set_active( self.Title1,true)
        fun.set_active( self.Title2,false)
    end 

    self:OnUpDateMailList(flag)
end

function PowerupHelperView:on_btn_close_click()
    Facade.SendNotification(NotifyName.CloseUI,this)
end

function PowerupHelperView:GetJokerCardShowKey()
    local cityPlayID = ModelList.CityModel.GetPlayIdByCity()
    local cfg = ModelList.CityModel:GetPowerUpRange()
    cfg = cfg and cfg[cityPlayID][4]
    if not cfg then
        return "30", 3
    end
    
    local highLevelJokerCount, totalCount = cfg.joker_high_quantity, cfg.joker_quantity
    local normalJokerCardCount = totalCount - highLevelJokerCount
    local showKey = string.format("%s%s", normalJokerCardCount, highLevelJokerCount)
    return showKey, totalCount
end

this.NotifyList = 
{

}

return this