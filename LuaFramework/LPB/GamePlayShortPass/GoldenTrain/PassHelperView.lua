--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

local base = require "GamePlayShortPass/Base/BasePassHelperView"



local PassHelperView =  class("PassHelpView",base )--Clazz(BasePassHelpView, "PassHelpView")
local this = PassHelperView
this.viewName = "PassHelperView"

return this 