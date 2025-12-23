
local CollectRewardsItem = BaseView:New("CollectRewardsItem")
local this = CollectRewardsItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = 
{
    "icon_item",
    "text_num",
    "text_title",
    "new"
}

function CollectRewardsItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CollectRewardsItem:Awake()
    self:on_init()
end

function CollectRewardsItem:OnEnable()
    self._init = true
    if self.cacheData then
        self:SetReward(self.cacheData,self.isMoreIcon)
    end
end

function CollectRewardsItem:OnDisable()
    self._init = nil
    self.cacheData = nil
	self.isMoreIcon = nil;
end

function CollectRewardsItem:SetReward(data,isMoreIcon)
    self.cacheData = data
	self.isMoreIcon = isMoreIcon;
    if self._init then
        local iconStr = "icon";
		if (data.id and data.id <100 ) or  (data[1] and data[1]<100) then
            local icon = Csv.GetItemOrResource(data.id or data[1],iconStr)
            self.icon_item.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", icon)
            
            if (data.id and data.id  == Resource.hintTime ) or  (data[1] and data[1] == Resource.hintTime) or (data.id and data.id == RESOURCE_TYPE.RESOURCE_TYPE_VICTORY_BEATS_DOUBLE_NOTE_BUFF) or (data[1] and data[1] == RESOURCE_TYPE.RESOURCE_TYPE_VICTORY_BEATS_DOUBLE_NOTE_BUFF) then
                ---放大镜数量转化成时间
                local ti = data.value or data[2]
                local hrs = math.floor(ti / 3600)
                if hrs > 0 then
                    self.text_num.text = fun.NumInsertComma(hrs) .. "HRS" --tostring(data.value)
                else
                    local min = math.floor(ti / 60)
                    self.text_num.text = fun.NumInsertComma(min) .. "Min" --tostring(data.value)
                end
            elseif (data.id and data.id  == Resource.dailycoins_bonus ) or  (data[1] and data[1] == Resource.dailycoins_bonus) then
                self:SetDailyCoinsBonus()
                self.text_num.text = fun.FormatText(data)
            else
                self.text_num.text = fun.format_number(data.value or data[2]) --tostring(data.value)
            end
        elseif (data.id and fun.CheckIsAmazonCard(data.id) ) or  (data[1] and fun.CheckIsAmazonCard(data[1])) then
            local icon = Csv.GetItemOrResource(data.id or data[1],iconStr)
            self.icon_item.sprite = AtlasManager:GetSpriteByName("BingoBangItemAtlas", icon)
            self.text_num.text = fun.GetAmazonCardDescription(data.id or data[1])
        else
            local itemAtlas = "BingoBangItemAtlas"
            local item_type = Csv.GetData("new_item",data.id or data[1],"item_type")
            if self:IsShortPassItem(item_type)  then
                local name_description = Csv.GetData("new_item",data.id or data[1],"name_description")
                local description = Csv.GetData("description",name_description,"description")
                fun.set_active(self.new,true)
                self.text_num.text = description
                itemAtlas = self:GetItemAtlas()
                if item_type == 44 then
                    fun.set_gameobject_scale(self.icon_item.gameObject, 1.3, 1.15, 1)
                end
            elseif item_type == 17 then
                local ti = data.value or data[2]
                local hrs = math.floor(ti / 60)
                if hrs > 0 then
                    self.text_num.text = fun.NumInsertComma(hrs) .. "HRS" --tostring(data.value)
                else
                    local min = math.floor(ti)
                    self.text_num.text = fun.NumInsertComma(min) .. "Min" --tostring(data.value)
                end
            else
                self.text_num.text = fun.NumInsertComma(data.value or data[2]) --tostring(data.value)
            end
            local icon = Csv.GetItemOrResource(data.id, "icon")

            self.icon_item.sprite = AtlasManager:GetSpriteByName("itemAtlas", icon)
        end
        
    end
end

function CollectRewardsItem:GetRewardItemId()
    if self.cacheData then
        return self.cacheData.id and self.cacheData.id or self.cacheData[1]
    end
    return nil
end

function CollectRewardsItem:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function CollectRewardsItem:GetIconItem()
    if self.icon_item then
        return self.icon_item
    end
    return nil
end


function CollectRewardsItem:SetDailyCoinsBonus()
    if self.text_title then
        fun.set_active(self.text_title, true)
        self.text_title.text =  Csv.GetDescription(529)
    end
end


--- flag:短令牌 每次增加新的短令牌都要修改
function CollectRewardsItem:IsShortPassItem(itemType)
    return (itemType == 36 or itemType == 34 or itemType == 37 or itemType == 39 or itemType == 40 or itemType == 41
            or itemType == 42 or itemType == 43 or itemType == 44 or itemType == 46) and
        true or false
end

function CollectRewardsItem:GetItemAtlas()
    local id = ModelList.GameActivityPassModel.GetCurrentId()
    local view = ModelList.GameActivityPassModel.GetViewById(id,"PassTaskView")
    if view then
        return view.longTaskAtlasName or "BingoBangItemAtlas"
    end
    return "BingoBangItemAtlas"
end




return this
