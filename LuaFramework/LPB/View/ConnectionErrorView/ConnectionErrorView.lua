--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-11-16 14:29:47
]]

ConnectionErrorView = BaseDialogView:New('ConnectionErrorView');
local this = ConnectionErrorView;
this.viewType = CanvasSortingOrderManager.LayerType.ErrorDialog

this.auto_bind_ui_items = {
    "txt_tip",
    "btn_relogin"
}

function ConnectionErrorView:GetRootView()
	if  SceneViewManager.gobal_layer == nil then
		SceneViewManager.gobal_layer = UnityEngine.GameObject.FindWithTag("GlobalUiRoot")
	end
	local parent =   SceneViewManager.gobal_layer
	return parent
end

function ConnectionErrorView.Awake(obj)
    this:on_init() 
end

function ConnectionErrorView.OnDestroy()
 
    this:Destroy()
end
 
function ConnectionErrorView:on_btn_relogin_click()
    UIUtil.reconnect()
end

 
return this








