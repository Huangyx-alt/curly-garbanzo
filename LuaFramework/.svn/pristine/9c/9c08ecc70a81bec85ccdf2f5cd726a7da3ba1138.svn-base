
local AchievementItem = BaseView:New("AchievementItem","AchievementItemAtlas")
local this = AchievementItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items ={
    "icon",
    "textDes",
    "textNum",
}

function AchievementItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function AchievementItem:Awake()
    self:on_init()
end

function AchievementItem:OnEnable()
    self.init = true
    self:SetAchievementItemData(self.data, self.index)
end

function AchievementItem:OnDisable()
    self:OnDispose()
    self.init = false
    self.data = nil
    self.index = nil
end

function AchievementItem:SetAchievementItemData(data,index)
    self.data = data
    self.index = index
    if self.init and self.data then
        local iconName = data[3]
        local iconDesIndex = data[4]
        Cache.SetImageSprite("AchievementItemAtlas",iconName,self.icon)
        self.textDes.text = Csv.GetDescription(iconDesIndex)
        local achievementID = self.data[1]
        local params = ModelList.PlayerInfoSysModel.GetAchievementIconValue(achievementID)
        if params and params.iconValue then
            local iconValue = JsonToTable(params.iconValue)
            local title = iconValue[1][1]
            local value = iconValue[1][2]
            self:SetDes(title ,value )
        end
    end
end

function AchievementItem:SetDes(title, value)
    if title == "birthTime" then
        self.textNum.text = value
    else
        self.textNum.text = fun.format_money(value)
    end
end


function AchievementItem:OnDispose()

end

return this