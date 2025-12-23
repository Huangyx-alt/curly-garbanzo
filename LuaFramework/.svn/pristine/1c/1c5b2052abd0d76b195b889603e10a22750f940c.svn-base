--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2021-11-12 10:16:48
]]

--local Singleton = class(Object)
Singleton = class("Singleton", Object)

local super = Object
function Singleton:new()
    return nil
end 

function Singleton:Instance()
    if self._instance == nil then
	    self._instance = super.new(self)
    end 
    return self._instance	
end 
