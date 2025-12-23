local GameJackpotView = require("View.Bingo.UIView.PartView.JackpotView.GameJackpotView")

local HangUpJackpotView = GameJackpotView:New()
local this = HangUpJackpotView
--setmetatable(this,{__index = GameJackpotView})
--[[
this.auto_bind_ui_items = {
    "B1",
    "I1"
}
--]]

--this.jackpotList = nil
--this.jackpotRoot = nil
--this.itemList ={}
--this.jackpotType = 0

--function HangUpJackpotView.Init(jackpotRef,jackpotTypeData,jackPar)
--    this.jackpotList = jackpotRef
--    this.jackpotType = jackpotTypeData
--    this.jackpotRoot = jackPar
--    this:CollectItem()
--    this:Show()
--end

--function HangUpJackpotView:CollectItem()
--    for i =1,25,1 do
--        local item = fun.find_child(this.jackpotList,tostring(i-1))
--        item.gameObject:SetActive(false)
--        table.insert(this.itemList,item)
--    end
--end

--function HangUpJackpotView:Show()
--    if this.jackpotType >0 then
--        --city表获取jackpot
--        local city  = Csv.GetData("city",ModelList.CityModel:GetCity(),"jackpot")
--        --读jackpot表
--        local coordinate  = Csv.GetData("jackpot",city[2],"coordinate")
--        --local coordinate = {0,4,6,8,12,16,18,20,24}
--
--        for k,v in pairs(coordinate) do
--            this.itemList[v].gameObject:SetActive(true)
--        end
--    else
--        fun.set_active(this.jackpotRoot ,false)
--    end
--
--
--end
--
--function HangUpJackpotView:OnDisable()
--    this.jackpotList = nil
--    this.itemList ={}
--    this.jackpotType = 0
--end

return this
