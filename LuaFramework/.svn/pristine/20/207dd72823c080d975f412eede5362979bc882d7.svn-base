local RewardShowTipItem = require "View/RewardShowTip/RewardShowTipItem"
local RewardShowTipItem2 = RewardShowTipItem:New()
local this = RewardShowTipItem2
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_item",
    "text_num"
}

function RewardShowTipItem2:SetReward(data)
    self.cacheData = data
    if self._init then
        if data.id then
            local icon = Csv.GetItemOrResource(data.id,"more_icon")
            if fun.is_ios_platform() then
                if icon == "ZBJL" then
                    icon = "ZBJLold"
                elseif icon == "ZBDwJl" then
                    icon = "ZBDwJlold"
                end
            end
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            if fun.CheckIsAmazonCard(data.id) then
                self.text_num.text = fun.GetAmazonCardDescription(data.id)
            else
                self.text_num.text = self:GenNumberText({id = data.id,value = data.value})
            end
        else
            local icon = Csv.GetItemOrResource(data[1],"more_icon")
            if fun.is_ios_platform() then
                if icon == "ZBJL" then
                    icon = "ZBJLold"
                elseif icon == "ZBDwJl" then
                    icon = "ZBDwJlold"
                end
            end
            Cache.SetImageSprite("ItemAtlas",icon,self.icon_item)
            if fun.CheckIsAmazonCard(data[1]) then
                self.text_num.text = fun.GetAmazonCardDescription(data[1])
            else
                self.text_num.text = self:GenNumberText({id = data[1],value = data[2]})
            end
        end
    end
end

return this