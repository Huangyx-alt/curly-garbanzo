
CityLevelProgressView = BaseView:New("CityLevelProgressView")
local this = CityLevelProgressView
this.viewType = CanvasSortingOrderManager.LayerType.None

local lv_img = nil
local _cache = nil

this.auto_bind_ui_items = {
    "canvasGroup",
    "img_lv1",
    "img_lv2",
    "img_lv3",
    "img_lv4",
    "img_lv5",
    "img_lv6",
    "img_lv7",
}

function CityLevelProgressView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CityLevelProgressView:Awake()
    self:on_init()
end    

function CityLevelProgressView:OnEnable()
    lv_img = {
        self.img_lv1,
        self.img_lv2,
        self.img_lv3,
        self.img_lv4,
        self.img_lv5,
        self.img_lv6,
        self.img_lv7
    }
    _cache = {}
    self._init = true
    self:ChangeCity(ModelList.CityModel:GetCity(),true)

    Event.AddListener(EventName.Event_UpdateItems,self.OnLevelUpdata,self)
end

function CityLevelProgressView:OnLevelUpdata(city)
    local cityId = city or ModelList.CityModel:GetCity()
    local level = ModelList.CityModel:GetCityLevel(cityId)
    --log.r("=====================================>>cityId " .. cityId .. "  level " .. level)
    local levelInfo = Csv.city_level
    local levelData = nil
    for key, value in pairs(levelInfo) do
        if value.city == cityId and value.level == level then
            levelData = value.show_icon
            break
        end
    end
    if levelData then
        if 0 == levelData[1] then
            for i = 1, 7 do
                if not (_cache[i] == 10) then
                    _cache[i] = 10
                    --lv_img[i].sprite = AtlasManager:GetSpriteByName("CityAtlas","cs_level10")
                    Cache.SetImageSprite("CityAtlas","cs_level10",lv_img[i])
                end
            end
        else
            for i = 1, 7 do
                local dataNil = math.min(1,levelData[i] or 0)
                local dataValue = math.max(levelData[1],levelData[i] or 0)
                if not (_cache[i] == dataValue * 10 + dataNil) then
                    _cache[i] = dataValue * 10 + dataNil
                    --lv_img[i].sprite = AtlasManager:GetSpriteByName("CityAtlas",string.format("cs_level%s%s",dataValue,dataNil))
                    Cache.SetImageSprite("CityAtlas",string.format("cs_level%s%s",dataValue,dataNil),lv_img[i])
                end
            end
        end
    end
end

function CityLevelProgressView:ChangeCity(cityId,isFirst)
    if self._init then
        if isFirst then
            Cache.Load_Atlas(AssetList["CityAtlas"],"CityAtlas",function()
                self:OnLevelUpdata(cityId)
            end)
        else
            self:OnLevelUpdata(cityId)
        end
    end
end

function CityLevelProgressView:OnDisable()
    lv_img = nil
    _cache = nil
    self._init = nil
    Event.RemoveListener(EventName.Event_UpdateItems,self.OnLevelUpdata,self)
end

function CityLevelProgressView:on_close()

end

function CityLevelProgressView:OnDestroy()
    self:Close()
end