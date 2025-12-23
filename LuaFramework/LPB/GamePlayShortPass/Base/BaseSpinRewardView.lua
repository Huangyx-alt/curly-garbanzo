--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local BaseSpinRewardView = class("BaseSpinRewardView",BaseViewEx)
local this = BaseSpinRewardView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole


function BaseSpinRewardView:ctor(id)
    self.id = id 
end


return this 