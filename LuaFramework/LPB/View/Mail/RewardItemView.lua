
local RewardItemView = BaseView:New("RewardItemView")

local this = RewardItemView

this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",         --物品icon 图片
    "text_num",         --文本
}   

function RewardItemView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function RewardItemView:Awake()
    self:on_init()
end

function RewardItemView:OnEnable()

end

function RewardItemView:UpdateData(data)
    if data ~= nil then 
        if (data.id and data.id <100 ) or  (data[1] and data[1]<100) then
            local icon = Csv.GetItemOrResource(data.id or data[1],"icon")
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            if (data.id and data.id  == Resource.hintTime ) or  (data[1] and data[1] == Resource.hintTime) then
                ---放大镜数量转化成时间
                local ti = data.value or data[2]
                local hrs = math.floor(ti / 3600)
                if hrs > 0 then
                    self.text_num.text = fun.NumInsertComma(hrs) .. " HRS" --tostring(data.value)
                else
                    local min = math.floor(ti / 60)
                    self.text_num.text = fun.NumInsertComma(min) .. " Min" --tostring(data.value)
                end
            else
                self.text_num.text = fun.format_number(data.value or data[2]) --tostring(data.value)
            end
        else
            local icon = Csv.GetItemOrResource(data.id or data[1],"icon")
        
            --判断是否是卡牌如果是卡牌则显示1 ，如果不是，是否
            --local itemInfo = Csv.GetData("season_card_box",data.id)
            if ModelList.SeasonCardModel:IsCardPackage(data.id) then
                local itemInfo = ModelList.SeasonCardModel:GetCardPackageInfo(data.id,0)
                if itemInfo ~= nil then
                    self.text_num.text = "1" --tostring(data.value)
                    Cache.SetImageSprite("ItemAtlas",itemInfo.icon,self.icon_item)
                else
                    Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
                    self.text_num.text = fun.NumInsertComma(data.value or data[2]) --tostring(data.value)
                end
            else
                Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
                self.text_num.text = fun.NumInsertComma(data.value or data[2]) --tostring(data.value)
            end
        end  
    end 
end 

function RewardItemView:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

return this