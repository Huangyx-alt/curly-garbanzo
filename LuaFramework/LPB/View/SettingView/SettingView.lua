require "State/Common/CommonState"

local SettingView = BaseView:New("SettingView","SettingAtlas")

local this = SettingView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
this.isCleanRes = true
this.auto_bind_ui_items = {
    "btn_close",
    "btn_contactus",
    "btn_facebook",
    "btn_uid",
    "btn_bindfacebook",
    "btn_bindapple",
    "btn_condition",
    "version",
    "ContactText",
    "text_support",
    "text_fanpage_notifiction",
    "text_copy_progess",
    "text_copy_uid",
    "text_uid",
    "text_signinapple",
    "anima",
    "toggle_music",
    "toggle_sound",
    "btn_logout",
    "btn_delete",
    "btn_Logoutapple",
    "MailPage",
    "btn_Mail",
    "text_fanpage_mailadress",
    "fans_xlh",
    "btn_terms",
    "toggleDisplay2",
    "toggleDisplay4",
    "btn_delete",
}

function SettingView:Awake()
    self:on_init()
end

function SettingView:OnEnable()
    Facade.RegisterView(self)
    self:SetFacebookUI()
    self.text_uid.text = string.format("UID:%s",ModelList.PlayerInfoModel:GetUid())
    self.version.text = "v"..UIUtil.get_client_version()
    self:InitSoundToggle()
    self:InitMusicToggle()

    CommonState.BuildFsm(self,"SettingView")
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,"Common_window01_start",false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)

    UISound.play("popup_window")

    self.luabehaviour:AddToggleChange(self.toggle_music.gameObject, function(go,check)
        self:SetMusicToggle(check)
    end)

    self.luabehaviour:AddToggleChange(self.toggle_sound.gameObject, function(go,check)
        self:SetSoundToggle(check)
    end)

    this:CheckHaveEmail()
    this.SetFanPage()

    self.luabehaviour:AddToggleChange(self.toggleDisplay2.gameObject, function(go,check)
        fun.save_value(BingoBangEntry.selectGameCardNumString,BingoBangEntry.selectGameCardNum.TwoCard)
        self:InitCardNumToggle(BingoBangEntry.selectGameCardNum.TwoCard,check)
    end)
    self.luabehaviour:AddToggleChange(self.toggleDisplay4.gameObject, function(go,check)
        fun.save_value(BingoBangEntry.selectGameCardNumString,BingoBangEntry.selectGameCardNum.FourCard)
        self:InitCardNumToggle(BingoBangEntry.selectGameCardNum.FourCard,check)
    end)
    
    local selectCard = fun.read_value(BingoBangEntry.selectGameCardNumString,BingoBangEntry.selectGameCardNum.FourCard)
    self:InitCardNumToggle(BingoBangEntry.selectGameCardNum.TwoCard,selectCard == BingoBangEntry.selectGameCardNum.TwoCard)
    self:InitCardNumToggle(BingoBangEntry.selectGameCardNum.FourCard,selectCard == BingoBangEntry.selectGameCardNum.FourCard)
    
end

function SettingView:InitCardNumToggle(cardType,check)
    local toggle = self["toggleDisplay" .. cardType]
    toggle:SetIsOnWithoutNotify(check)
end

---回调函数执行的时候，界面可能已经关闭了
function SettingView:SetFacebookUI()
    --facebook UI 状态todo
    --if fun.is_null(self.btn_bindfacebook) then --暂且认为这种情况为界面已经关闭了
    --    return
    --end
    --
    --local plateform = ModelList.loginModel:GetLoginPlatform() --PLATFORM.PLATFORM_FACEBOOK --
    --if not plateform then
    --    plateform = 0
    --end
    --
    --
    --if plateform == PLATFORM.PLATFORM_GUEST then
    --    local openidFacebookGroup = ModelList.LoginModel:CheckOpenidGroup(PLATFORM.PLATFORM_FACEBOOK)
    --    local openidAppleGroup = ModelList.LoginModel:CheckOpenidGroup(PLATFORM.PLATFORM_APPLE)
    --    if openidAppleGroup ~= nil then 
    --        --判断苹果
    --        fun.set_active(self.btn_bindfacebook.transform,false,false)
    --        fun.set_active(self.btn_logout.transform,false,false)
    --
    --        fun.set_active(self.btn_bindapple.transform,false,false)
    --        fun.set_active(self.btn_Logoutapple.transform,true,false)
    --    else
    --        if openidFacebookGroup ~= nil then 
    --            fun.set_active(self.btn_bindfacebook.transform,false,false) 
    --            fun.set_active(self.btn_logout.transform,true,false)
    --
    --            fun.set_active(self.btn_bindapple.transform,false,false)
    --            fun.set_active(self.btn_Logoutapple.transform,false,false)
    --        else 
    --            fun.set_active(self.btn_bindfacebook.transform,ModelList.PlayerInfoModel:IsFaceBookOpen(),false)
    --            fun.set_active(self.btn_logout.transform,false,false)
    --            
    --
    --            if fun.is_ios_platform() then 
    --                fun.set_active(self.btn_bindapple.transform,true,false)
    --            else 
    --                fun.set_active(self.btn_bindapple.transform,false,false)
    --            end 
    --    
    --            fun.set_active(self.btn_Logoutapple.transform,false,false)
    --        end 
    --    end 
    --elseif plateform == PLATFORM.PLATFORM_FACEBOOK then
    --    fun.set_active(self.btn_bindfacebook.transform,false,false)
    --    fun.set_active(self.btn_logout.transform,true,false)
    --
    --    fun.set_active(self.btn_bindapple.transform,false,false)
    --    fun.set_active(self.btn_Logoutapple.transform,false,false)
    --elseif plateform == PLATFORM.PLATFORM_APPLE then 
    --    fun.set_active(self.btn_bindapple.transform,false,false)
    --    fun.set_active(self.btn_Logoutapple.transform,true,false)
    --
    --    fun.set_active(self.btn_bindfacebook.transform,false,false)
    --    fun.set_active(self.btn_logout.transform,false,false)
    --
    --end

end

function SettingView.SetFanPage()
    --local ret = ModelList.FBFansModel:IsClaimedFbFollowReward()
    --local text = Csv.GetData("description", ret and 32 or 31, "description")
    --this.text_fanpage_notifiction.text = text
    --fun.set_active(this.fans_xlh, not ret)
end

function SettingView:CheckAppleLogin()
    --检查苹果登录 如果存在key 就是没有问题
    local appleState = fun.read_value("AppleUserId",nil)
    if appleState ~= nil then 
        fun.set_active(self.btn_bindapple.transform,false,false)
    else
        fun.set_active(self.btn_bindapple.transform,true,false)
    end 
end

--检查是否要开启邮箱
function SettingView:CheckHaveEmail()
    if ModelList.PlayerInfoModel:GetIsTrueGoldUser()  then 
        --如果是真金金用户需要检测邮箱下存不存在
        if  ModelList.PlayerInfoModel:GetEmail() ~= nil and   ModelList.PlayerInfoModel:GetEmail() ~= "" then 
            self.text_fanpage_mailadress.text = ModelList.PlayerInfoModel:GetEmail()
            fun.set_active(self.MailPage,true)
            fun.set_active(self.btn_Mail,false)
         else
            fun.set_active(self.MailPage,false)
             fun.set_active(self.btn_Mail,true)
         end 
    else 
        fun.set_active(self.MailPage,false)
        fun.set_active(self.btn_Mail,false)
    end 
end

function SettingView:OnDisable()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function SettingView:on_close()

end

function SettingView:OnDestroy()

end

function SettingView:OnApplicationFocus(focus)
    if focus and this.isInFansPage then
        this.isInFansPage = false
        
        local ret = ModelList.FBFansModel:IsClaimedFbFollowReward()
        if not ret then
            --领取奖励
            ModelList.FBFansModel:ReqFbFollowReward()
        end
    end
end

function SettingView:InitSoundToggle()
    local sound = fun.read_value("sound_switch")
    if not sound or sound == "open" then
        self.toggle_sound.isOn = true
    else
        self.toggle_sound.isOn = false
    end
end

function SettingView:InitMusicToggle()
    local music = fun.read_value("music_switch")
    if not music or music == "open" then
        self.toggle_music.isOn = true
    else
        self.toggle_music.isOn = false
    end
end

function SettingView:SetSoundToggle(toggle)
    if toggle then
        SoundHelper.sound_switch = "open"
    else
        SoundHelper.sound_switch = "close"    
    end
    fun.save_value("sound_switch",SoundHelper.sound_switch)
    if toggle then
        
    else
        soundMgr:StopAllSound()
    end
end

function SettingView:SetMusicToggle(toggle)
    if toggle then
        SoundHelper.music_switch = "open"
    else
        SoundHelper.music_switch = "close"    
    end
    fun.save_value("music_switch",SoundHelper.music_switch)
    if toggle then
        SoundHelper.resume_bgm()
    else
        --soundMgr:StopBackSound()
        SoundHelper.stop_bgm()
    end
end

function SettingView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,"Common_window01_end",false,function()
            Facade.SendNotification(NotifyName.CloseUI,this)
        end)
    end)
end

function SettingView:on_btn_contactus_click()
    local platform = UnityEngine.Application.platform

    if platform == UnityEngine.RuntimePlatform.WindowsEditor or platform == UnityEngine.RuntimePlatform.OSXEditor then
        fun.OpenURL("mailto:livepartybingoservice@gmail.com?subject=Good Game&body=We are very glad to help you.\nIf you meet a problem while playing our game, please describe it more clearly to help for a fast treatment.\nOur agent will answer you as soon as she/he arrive at your case. Please enter your feedback below.")
    else
        local userinfo = ModelList.PlayerInfoModel:GetUserInfo()
        local recharge = ModelList.PlayerInfoModel:GetUserRechargeInfo()
        AIHelpHelper.Instance:ShowConversation("E002")
    end
end

function SettingView:on_btn_facebook_click()
    this.isInFansPage = true
    --记录已经打开
    ModelList.FBFansModel:ReqFollowFb()
    ModelList.FBFansModel:SaveInPrefs("need_follow_reward", 1)
    
    fun.OpenURL("https://www.facebook.com/people/Live-Party-Bingo/100081989509019")
end

function SettingView:on_btn_uid_click()
   
    Util.CopyTextToClipboard(tostring(ModelList.PlayerInfoModel:GetUid()))
    Facade.SendNotification(NotifyName.Common.CommonTip, "copy uid success")
    
end

function SettingView:on_btn_delete_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.DeleteAccView,nil)
end

function SettingView:on_btn_bindfacebook_click()
    local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.WindowsEditor or platform == UnityEngine.RuntimePlatform.OSXEditor then
        self:on_btn_logout_click()
    else
        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
            Http.session_id = ""
            ModelList.loginModel.FbLogin(function(code)
                self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
                if code and code == RET.RET_ACCOUNT_BIND_NOT_CURRENT then
                    UIUtil.show_common_error_popup(9037,true,function()
                        self:on_btn_logout_click()
                    end)
                else
                    UIUtil.show_common_error_popup(8010,true,nil)
                end
            end,function()
                Event.Brocast(EventName.Event_FaceBookLogin_Update_Icon)
                self:SetFacebookUI()
                self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
            end)
        end)
    end
end

function SettingView:on_btn_bindapple_click()
    local platform = UnityEngine.Application.platform
    if platform == UnityEngine.RuntimePlatform.WindowsEditor or platform == UnityEngine.RuntimePlatform.OSXEditor then
        self:on_btn_logout_click()
    else 
        self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
            Http.session_id = ""
            ModelList.loginModel.AppleLogin(function(code)
                self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
                if code and code == RET.RET_ACCOUNT_BIND_NOT_CURRENT then
                    UIUtil.show_common_error_popup(9037,true,function()
                        self:on_btn_logout_click()
                    end)
                else
                    UIUtil.show_common_error_popup(8010,true,nil)
                end
            end,function()
                self:SetFacebookUI()
                self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
            end)
        end)
    end 
end

function SettingView:on_btn_logout_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        ModelList.loginModel.user_logout()
    end)
end

function SettingView:on_btn_Logoutapple_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        ModelList.loginModel.user_logout()
    end)
end 

function SettingView:on_btn_condition_click()
    fun.OpenURL("https://www.triwingames.com/#privacy_policy")
end

function SettingView:on_btn_terms_click()
    fun.OpenURL("https://www.triwingames.com/#terms_of_service")
end

function SettingView:on_btn_delete_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.DeleteAccView,nil)
end

function SettingView:on_btn_Mail_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.MailAdressSubmitView,nil,nil,nil)
end

function SettingView.OnUserLogoutRespone(data)
    if data == RET.RET_FAILED then --这里等于1是成功的，不要看字面意思
        ModelList.loginModel.LogoutHandle()
        Facade.SendNotification(NotifyName.ShowUI,ViewList.SceneLoadingGameView,nil,nil,JumpSceneType.ToLogin)
    end
end

function SettingView.OnReceiveFbFollowReward(data)
    ModelList.FBFansModel:SaveInPrefs("need_follow_reward", 0)
    this.SetFanPage()
    
    --local rewards = Csv.GetData("control",151,"content")
    local rewards = data and data.reward or Csv.GetData("control",151,"content")
    Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.show, ClaimRewardViewType.CollectReward, rewards, function()
        Facade.SendNotification(NotifyName.ClaimReward.PopupClaimReward, PopupViewType.hide, ClaimRewardViewType.CollectReward, nil, function()

        end)
    end)
end

this.NotifyList = {
    {notifyName = NotifyName.Login.LogoutRespone,func = this.OnUserLogoutRespone},
    {notifyName = NotifyName.FBFansPage.ReceiveFbFollowReward, func = this.OnReceiveFbFollowReward}
}

return this

