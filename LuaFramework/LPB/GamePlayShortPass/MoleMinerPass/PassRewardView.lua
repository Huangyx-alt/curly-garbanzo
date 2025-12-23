--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

local base = require "GamePlayShortPass/Base/BasePassRewardView"
local PassRewardView = class("PassRewardView",base ) 
local this = PassRewardView
this.viewName = "PassRewardView"
this.atlasName = "MoleMinerPopupAtlas"

 

return this 