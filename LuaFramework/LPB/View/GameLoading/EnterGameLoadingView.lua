local BaseSceneLoadingView = require("View/GameLoading/BaseSceneLoadingView")
EnterGameLoadingView = BaseSceneLoadingView:New("EnterGameLoadingView");
local this = EnterGameLoadingView;
---@diagnostic disable
this.process_move_speed = ArtConfig.EnterGameLoading_Process_Move_Speed
this.auto_bind_ui_items = {
    "game_lider",
    "txt_percent",
    "btn_feedback",
    "txt_uid",
    "Canvas",
    "btn_PrivacyPolicy",
    "txt_version",
    "txt_tips",
    "btn_exit_select_url",
    "selectUrl",
    "selectUrlItem",
    "selectUrlItemParent",
}

local IsLoadingNextScene = false
local isShowChangeUrlView = false

function EnterGameLoadingView:Awake(obj)
    self:on_init()
    math.randomseed(now_millisecond())
end

function EnterGameLoadingView:OnEnable()
    Facade.RegisterView(this)
    IsLoadingNextScene = false
    -- self.txt_version.text = "v" .. UIUtil.get_client_version()
    SDK.login_event("login_loading_view")
    this.curProcess = 0.1
    if (not this.can_next_step) then
        this.percent = 0.9
    end
    this.update_x_enabled = true
    self:start_x_update()
    this:on_init_ctrl()
    this.isLoad = false
    isShowChangeUrlView = false
    this:user_login()
end

function EnterGameLoadingView:update_process()
    if this.curProcess < this.game_lider.value then
        this.curProcess = this.game_lider.value
    end
    if this.curProcess < this:getTargetProcess() then
        if (this.curProcess > 0.95) then
            if this.HotFix then
                this.process_move_speed = ArtConfig.EnterGameLoading_Process_Move_Speed
            else
                if this.process_move_speed < ArtConfig.EnterGameLoading_Process_Move_Speed then
                    this.process_move_speed = ArtConfig.EnterGameLoading_Process_Move_Speed
                else
                    this.process_move_speed = this.process_move_speed * 0.3
                end
            end
        else
            this.process_move_speed = this.process_move_speed * 1.5
        end
        this.curProcess = this.curProcess + 0.01 * this.process_move_speed

        if (this.curProcess > this:getTargetProcess()) then
            this.curProcess = this:getTargetProcess()
        end
    end
    if this.curProcess >= 0.9 then
        this:SetParentToGlobalUICamera()
    end
    this:setProcess(this.curProcess)
end

function EnterGameLoadingView:on_x_update()
    --不用等待场景返回
    -- if this.operation == nil then
    --     return
    -- end
    this:update_process()
    local absProcess = math.abs(1 - this.curProcess) * 100

    if (absProcess <= 0.01 or (this.HotFix and this.curProcess >= this:getTargetProcess())) and this.can_next_step == true then
        this:setProcess(this.curProcess)
        this:stop_x_update()

        this:register_invoke(function()
            this:load_scene()
        end, 0.5)
    end
end

function EnterGameLoadingView:getTargetProcess()
    return this.percent
end

function EnterGameLoadingView:load_scene()
    if (this.isLoad == nil) then this.isLoad = false end
    if (not this.isLoad) then
        this.isLoad = true
        -- this.operation.allowSceneActivation = true
        this.operation:UnSuspend()
        this:SetParentToGlobalUICamera()
    end
end

function EnterGameLoadingView:on_init_ctrl()
    -- by LwangZg 这里标记了要跳的场景
    this.next_scene_name = "SceneHome"
    this.can_next_step = false
    this.curProcess = this.game_lider.value
    this:setProcess(this.curProcess)
end

function EnterGameLoadingView:setProcess(value)
    this.game_lider.value = value
    this.txt_percent.text = tostring(math.floor(value * 100)) .. "%"
end

function EnterGameLoadingView:SetParentToGlobalUICamera()
    if SceneViewManager.gobal_layer == nil then
        SceneViewManager.gobal_layer = UnityEngine.GameObject.FindWithTag("GlobalUiRoot")
    end

    local parent = SceneViewManager.gobal_layer
    fun.set_child_layer(this.go, "FakeUI")
    this.go.transform:SetParent(parent.transform)
    this.go.transform.localScale = Vector3.New(1, 1, 1)
    this.go.transform.localPosition = Vector3.New(0, 0, 0)
    local rect = fun.get_component(this.go, fun.RECT)
    if rect then
        rect.offsetMin = Vector2.New(0, 0)
        rect.offsetMax = Vector2.New(0, 0)
    end
end

function EnterGameLoadingView.FadeOut()
    Anim.canvas_group_do_fade_loop(this["Canvas"], 1, 0, 0.5, 1, 0, function()
        this:Close();
    end)
end

function EnterGameLoadingView.OnLoadSceneComplete(cb)
    this:register_invoke(function()
        this.FadeOut()
    end, 0.5)
end

function EnterGameLoadingView:LoadSceneHome()
    log.log("第一个")
    if ModelList.GuideModel:IsGuideMainView() then
        --local empty = UnityEngine.GameObject.New()
        --Facade.SendNotification(NotifyName.SkipLoadShowUI, ViewList.GuideSceneLoadingGameView, empty)
        --ModelList.GameModel:ReqEnterGame()
        
        this.OnLoadSceneComplete()
        ModelList.CityModel.C2S_ChangeCity(1)
        ModelList.CityModel.SetPlayId(1)
        
        local CmdEnterGuideBattle = require "Logic.Command.Guide.CmdEnterGuideBattle"
        local cmd = CmdEnterGuideBattle.New()
        cmd:Execute()
    else
        --TODO 切换场景时,加载资源 by LwangZg
        --lpb这样做,封装为全局方法了
        LoadSceneAsync(this.next_scene_name, ProcedureCityHome:New(), function(handle)
            this.operation = handle
            -- this.operation.allowSceneActivation = false
            require "Logic.AssetManager"
            AssetManager.load_common_res(function()    --加载通用ab资源
                AssetManager.load_lobby_res(function() --加载大厅资源和音效
                    --Facade.RegisterCommand(NotifyName.DownloadHallData,CmdCommonList.CmdLoadHallData)
                    --Facade.SendNotification(NotifyName.DownloadHallData,function()
                    this.percent = 1
                    this.can_next_step = true
                    this:PlayAudio()
                    UISound.play("load_fireworks_1")
                    LuaTimer:SetDelayFunction(1,function()
                        Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleLoadingView)
                    end)
                    --Facade.RemoveCommand(NotifyName.DownloadHallData)
                    --end)
                end)
            end)
        end, true)
    end
end

function EnterGameLoadingView:LoadSceneLogin()
    LoadSceneAsync("SceneLogin", ProcedureLogin:New(), function(operation)
        this.operation = operation
        -- this.operation.allowSceneActivation = false
        require "Logic.AssetManager"
        AssetManager.load_common_res(function()
            this.can_next_step = true
            this.percent = 1
            -- this.operation.allowSceneActivation = true
            this.operation:UnSuspend()
            this.OnLoadSceneComplete()
        end)
    end)
end

function EnterGameLoadingView:ChangeUrlBase()
    local urlDefault = Http.get_url_default()
    fun.set_active(self.selectUrl, true)
    local selectUrl = fun.read_value("test_select_url_data", urlDefault)
    local configDataNum = Csv.GetDataLength("test_select_server")
    self.selectUrlItemBtnList = {}
    self.selectUrlItemList = {}
    for i = 1, configDataNum do
        local data = Csv.GetData("test_select_server", i)
        local item = fun.get_instance(self.selectUrlItem, self.selectUrlItemParent)
        fun.set_active(item, true)
        local ref = fun.get_component(item, fun.REFER)
        local btn_select = ref:Get("btn_select")
        local textUrl = ref:Get("textUrl")
        local textServer = ref:Get("textServer")
        local selectBg = ref:Get("selectBg")
        local normalBg = ref:Get("normalBg")
        local url = data["url"]
        local server = data["toserver"]
        textUrl.text = url
        textServer.text = server
        if url == selectUrl then
            self.selectUrlIndex = i
            fun.set_active(selectBg, true)
            fun.set_active(normalBg, false)
        else
            fun.set_active(selectBg, false)
            fun.set_active(normalBg, true)
        end
        self.luabehaviour:AddClick(btn_select, function()
            Http.change_url_default(url)
            if self.selectUrlIndex and self.selectUrlIndex ~= i then
                self:RefreshSelectUrlItem(self.selectUrlIndex, url)
            end
            self:RefreshSelectUrlItem(i, url)
        end)
        self.selectUrlItemBtnList[i] = btn_select
        self.selectUrlItemList[i] = item
    end
end

function EnterGameLoadingView:RefreshSelectUrlItem(itemIndex, selectUrl)
    local item = self.selectUrlItemList[itemIndex]
    local ref = fun.get_component(item, fun.REFER)
    local selectBg = ref:Get("selectBg")
    local normalBg = ref:Get("normalBg")
    local data = Csv.GetData("test_select_server", itemIndex)
    local url = data["url"]
    if url == selectUrl then
        self.selectUrlIndex = itemIndex
        fun.set_active(selectBg, true)
        fun.set_active(normalBg, false)
    else
        fun.set_active(selectBg, false)
        fun.set_active(normalBg, true)
    end
end

--自动登录
function EnterGameLoadingView:user_login()
    --local platform = UnityEngine.Application.platform
    --if platform == UnityEngine.RuntimePlatform.WindowsEditor and not isShowChangeUrlView then
    --    isShowChangeUrlView = true
    --    this:ChangeUrlBase()
    --    return
    --end

    if (ModelList.loginModel.IsLogined()) then
        ModelList.loginModel.AutoLogin(function()
            this:LoadSceneLogin()
        end, function()
            SDK.login_event("login_success")
            --this:LoadSceneLogin()
        end)
    else
        if ModelList.loginModel.IsPreviousFacebooPlatform() then
            this:LoadSceneLogin()
        else
            ModelList.loginModel.GuestLogin(function()
                UIUtil.show_common_error_popup(8010, true, nil)
                this:LoadSceneLogin()
            end, function()
                --this:LoadSceneLogin()
                SDK.login_event("login_success")
            end)
        end
    end
end

function EnterGameLoadingView.UpdatePercent(percent)
    --log.y("UpdatePercent  ",...)
    this.slider_progress.value = percent * 0.01
    this.txt_progress.text = percent .. "%"
end

function EnterGameLoadingView:OnLoginSuccess()
    --- 屏蔽反复重连，同时加载N个Home场景的问题
    if IsLoadingNextScene then return end
    IsLoadingNextScene = true
    Facade.SendNotification(NotifyName.ShowDialog, ViewList.BattleLoadingView)
    this:setProcess(1)
    this:LoadSceneHome()
end

function EnterGameLoadingView.OnLoginFaild()
    this:LoadSceneLogin()
end

function EnterGameLoadingView.LoadNextScene()
    this.percent = 1
end

function EnterGameLoadingView.OnReLoadLoading()
    this:start_x_update()
    this.update_x_enabled = true
    --this:user_login()
    this.percent = 0.9
end

function EnterGameLoadingView:on_btn_feedback_click()
    local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.WindowsEditor or platform == UnityEngine.RuntimePlatform.OSXEditor then
        fun.OpenURL(
            "mailto:livepartybingoservice@gmail.com?subject=Good Game&body=We are very glad to help you.\nIf you meet a problem while playing our game, please describe it more clearly to help for a fast treatment.\nOur agent will answer you as soon as she/he arrive at your case. Please enter your feedback below.")
    else
        local userinfo = ModelList.PlayerInfoModel:GetUserInfo()
        local recharge = ModelList.PlayerInfoModel:GetUserRechargeInfo()
        AIHelpHelper.Instance:ShowConversation("E001")
    end
end

function EnterGameLoadingView:OnDisable()
    if self.selectUrlItemBtnList then
        for k, v in pairs(self.selectUrlItemBtnList) do
            self.luabehaviour:RemoveClick(v)
        end
    end
    self.selectUrlItemBtnList = {}
    self.selectUrlItemList = {}
    Facade.RemoveView(this)
end

function EnterGameLoadingView:on_close()
end

function EnterGameLoadingView:OnDestroy()
    this:Close()
end

function EnterGameLoadingView:on_btn_PrivacyPolicy_click()
    fun.OpenURL("http://www.triwingames.com/privacy_policy.html")
end

function EnterGameLoadingView:PlayAudio()
    --播放音效

    UISound.load_login_res(function()
        UISound.play("load_fireworks_2")
    end)
end

function EnterGameLoadingView:on_btn_exit_select_url_click()
    fun.set_active(self.selectUrl, false)
    if self.selectUrlIndex then
        local data = Csv.GetData("test_select_server", self.selectUrlIndex)
        local url = data["url"]
        fun.save_value("test_select_url_data", url)
    end

    this:user_login()
end

function EnterGameLoadingView:PlayBtnClickSound(btn_name)
end

this.NotifyList =
{
    { notifyName = NotifyName.Login.LoginSuccess,          func = this.OnLoginSuccess },
    { notifyName = NotifyName.LoadScene.LoadSceneComplete, func = this.OnLoadSceneComplete }
}


return this
