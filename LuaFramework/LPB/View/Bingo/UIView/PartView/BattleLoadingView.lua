--[[
Descripttion: 新流程 进战斗时的Loading界面
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月16日11:22:12
LastEditors: gaoshuai
LastEditTime: 2025年7月16日11:22:12
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@class BattleLoadingView : BaseDialogView
local BattleLoadingView = BaseDialogView:New("BattleLoadingView", "BingoBangLoadingAtlas")
local this = BattleLoadingView
this.__index = this
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.auto_bind_ui_items = {
    "view"
}

function BattleLoadingView:GetRootView()
    if SceneViewManager.gobal_layer == nil then
        SceneViewManager.gobal_layer = UnityEngine.GameObject.FindWithTag("GlobalUiRoot")
    end
    local parent = SceneViewManager.gobal_layer
    return parent
end

function BattleLoadingView.New()
    local o = {}
    setmetatable(o, BattleLoadingView)
    o.__index = o
    return o;
end

function BattleLoadingView.Awake()
    this:on_init()
end

function BattleLoadingView.OnEnable(self, params)
    this.params = params or {}
end

function BattleLoadingView.OnAnimEnd()
    AnimatorPlayHelper.Play(
        this.view,
        { "end", "cityReadyloading_end" }, false,
        function()
            this:Close()
        end)
end

return this
