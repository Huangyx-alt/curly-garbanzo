--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-12-23 10:03:33
]]

BaseGobalView = BaseView:New('BaseGobalView')
local this = BaseGobalView
this.__index = this;


function BaseGobalView:New(viewName, atlasName)
    return setmetatable({viewName = viewName, atlasName = atlasName, isShow = false, isLoaded = false,changeSceneClear = false}, this);
end


function BaseGobalView:GetRootView()
	if  SceneViewManager.gobal_layer == nil then
		SceneViewManager.gobal_layer = UnityEngine.GameObject.FindWithTag("GlobalUiRoot")
	end
	local parent =   SceneViewManager.gobal_layer
	return parent
end

