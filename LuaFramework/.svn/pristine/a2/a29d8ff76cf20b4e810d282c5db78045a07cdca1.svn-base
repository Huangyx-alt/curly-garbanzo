--lbp的入口，lua的面向对象实现有3个规则以上，统一的规范请使用
local MainStartLogic = {}

---很多 lps 时期的遗留,找时间干掉 TODO
function MainStartLogic.RequireLua()
    print(" ====== MainStartLogic 进入 RequireLua ====== ")
	require "Config/ArtConfig"
	require "Utils/CanvasSortingOrderManager"
	require "Common/fun"
	require "Common/LogUtil"
	require "Common/Clazz"
	require "Common.base.class"
	require "Common.base.Object"
	require "Common.base.class_yf"
	require "Procedure/ProcedureManager"
	require "RedDot/RedDotManager"
	require "Common/package"
	require "View/SceneViewManager"
	require "data/Csv"
	require "Command/NotifyName"
	require "Command/CmdList"
    require "Logic/Enum"
	require "Utils.package"
	require "Common/framework/Facade"
	require "Logic/package"
	require "Logic/AnimatorPlayer"
	require "Logic.Sound.SoundHelper"
	require "pblua/PB_Common"
	-- require "net.Proto" --大改网络模块 by LwwangZg
	-- require "Config/FakeNetData" --这个本地网络数据不需要 by LwangZg
	Event = require "Common/events"
	-----所有需要直接.调用的panel，在下面require
	require "View/ViewList"
	require "View/ViewTool"
	require("Language/LangManager")
	require("Model/ModelList")
	require "Logic/SDK/PurchaseHelper"  --暂时屏蔽SDK by LwangZg
	require "Notifications/LuaNotifications"
    print(" ====== success 完成这次 脚本加载 ====== ")
end

--主入口函数。从这里开始lua逻辑
function MainStartLogic.InitAllModul()
    -- Http.get_url_base()
    --StaticData.init()
    UnityTick.init()
    --PurchaseUtil.init()
    MainStartLogic.init_log()
    --AdTaskManager.init()
    --ActivityManager.init()
    --MissionManager:init()
    -- QuickQuestManager:init()
    --MCT:Init()
    --SCT:Init()
    --CommonTipConfigTools:Init()
    -- Proto.init() --大改网络模块
    LuaTimer:Init()
    if IS_OPEN_DEBUG then WriteFiles.WritFile:Log(UnityEngine.LogType.Log, "开始初始化") end
        fun.save_int("DevMode", DevMode)
        --MainStartLogic.InitNotification()
        --ModuleManager.init_modules_version()
        MD5Checker.init()
        print(" ====================  InitAllModul again")
        MainStartLogic.init_framework()
        local download_dir = Util.DataPath .. "lua/storages/assetsstorage"
        MD5Checker.check_exist_file(download_dir)
        print(" ====================  InitAllModul middle")
        --PlayerTrackerData.init()
        --TapTicManager.IsInit()
        RedDotManager:Init()
        LuaNotifications:Initialize()
        UnityEngine.Application.targetFrameRate = 60
        print(' ==================== InitAllModul end')
end

function MainStartLogic.RegCmd()
    Facade.RegisterCommand(NotifyName.Login.ConnectServer, CmdCommonList.CmdConnectServer)
    Facade.RegisterCommand(NotifyName.Login.UserEnter, CmdCommonList.CmdUserEnter)
    Facade.RegisterCommand(NotifyName.Login.LoginSuccess, CmdCommonList.CmdLoginSuccess)
    Facade.RegisterCommand(NotifyName.Login.LoginRequestOrder, CmdCommonList.CmdLoginRequestOrder)
    Facade.RegisterCommand(NotifyName.LoadUIToCache, CmdCommonList.CmdLoadUIToCache)
    Facade.RegisterCommand(NotifyName.ShowUI, CmdCommonList.CmdShowUI)
    Facade.RegisterCommand(NotifyName.HideUI, CmdCommonList.CmdHideUI)
    Facade.RegisterCommand(NotifyName.CloseUI, CmdCommonList.CmdCloseUI)
    Facade.RegisterCommand(NotifyName.SkipLoadShowUI, CmdCommonList.CmdSkipLoadShowUI)
    Facade.RegisterCommand(NotifyName.ShowDialog, CmdCommonList.CmdShowDialog)
    Facade.RegisterCommand(NotifyName.HideDialog, CmdCommonList.CmdHideDialog)
    Facade.RegisterCommand(NotifyName.LoadScene.RequestChangeScene, CmdCommonList.CmdLoadScene)
    Facade.RegisterCommand(NotifyName.Common.CommonTip, CmdCommonList.CmdCommonTip)
    Facade.RegisterCommand(NotifyName.Common.PopupDialogCountDown, CmdCommonList.CmdPopupDialogCountDown)
    Facade.RegisterCommand(NotifyName.Common.PopupDialog, CmdCommonList.CmdPopupDialog)
    Facade.RegisterCommand(NotifyName.Common.PopupDialogCustom, CmdCommonList.CmdPopupDialogCustom)
    Facade.RegisterCommand(NotifyName.Common.GlobalPopup, CmdCommonList.CmdGlobalPopupDialog)
    Facade.RegisterCommand(NotifyName.Common.Reconnection, CmdCommonList.CmdReconnection)
    Facade.RegisterCommand(NotifyName.Net.CheckNetState, CmdCommonList.CmdCheckNetState)
    Facade.RegisterCommand(NotifyName.Net.CheckNetFocus, CmdCommonList.CmdCheckNetFocus)
    Facade.RegisterCommand(NotifyName.ShowPopup, CmdCommonList.CmdShowPopup)
    Facade.RegisterCommand(NotifyName.ShopView.PopupShop, CmdCommonList.CmdPopupShopView)
    Facade.RegisterCommand(NotifyName.ShopView.CheckCurrencyAvailable, CmdCommonList.CmdCheckCurrencyAvailable)
    Facade.RegisterCommand(NotifyName.HallCity.EnterCityPopupOrder, CmdCommonList.CmdEnterCityPopupOrder)
    Facade.RegisterCommand(NotifyName.ShopView.FlyRewardEffcts, CmdCommonList.CmdFlyRewardEffects)
    Facade.RegisterCommand(NotifyName.ClaimReward.PopupClaimReward, CmdCommonList.CmdPopupClaimReward)
    Facade.RegisterCommand(NotifyName.Net.BattleReconnect, CmdCommonList.CmdBattleConnect)
    Facade.RegisterCommand(NotifyName.StartDownloadMachine, CmdCommonList.CmdStartDownloadMachine)
    Facade.RegisterCommand(NotifyName.Event_machine_download_success, CmdCommonList.CmdSuccessDownloadMachine)
    --Facade.RegisterCommand(NotifyName.Event_Unload_Lobby,CmdCommonList.CmdUnloadBattleLobby)
end

function MainStartLogic.UnRegCmd()
    Facade.RemoveCommand(NotifyName.Login.ConnectServer)
    Facade.RemoveCommand(NotifyName.Login.UserEnter)
    Facade.RemoveCommand(NotifyName.Login.LoginSuccess)
    Facade.RemoveCommand(NotifyName.Login.LoginRequestOrder)
    Facade.RemoveCommand(NotifyName.LoadUIToCache)
    Facade.RemoveCommand(NotifyName.ShowUI)
    Facade.RemoveCommand(NotifyName.HideUI)
    Facade.RemoveCommand(NotifyName.CloseUI)
    Facade.RemoveCommand(NotifyName.SkipLoadShowUI)
    Facade.RemoveCommand(NotifyName.ShowDialog)
    Facade.RemoveCommand(NotifyName.HideDialog)
    Facade.RemoveCommand(NotifyName.LoadScene.RequestChangeScene)
    Facade.RemoveCommand(NotifyName.Common.CommonTip)
    Facade.RemoveCommand(NotifyName.Common.PopupDialogCountDown)
    Facade.RemoveCommand(NotifyName.Common.PopupDialog)
    Facade.RemoveCommand(NotifyName.Common.GlobalPopup)
    Facade.RemoveCommand(NotifyName.Common.Reconnection)
    Facade.RemoveCommand(NotifyName.Net.CheckNetState)
    Facade.RemoveCommand(NotifyName.Net.CheckNetFocus)
    Facade.RemoveCommand(NotifyName.ShopView.PopupShop)
    Facade.RemoveCommand(NotifyName.ShopView.CheckCurrencyAvailable)
    Facade.RemoveCommand(NotifyName.HallCity.EnterCityPopupOrder)
    Facade.RemoveCommand(NotifyName.ShopView.FlyRewardEffcts)
    Facade.RemoveCommand(NotifyName.ClaimReward.PopupClaimReward)
    Facade.RemoveCommand(NotifyName.StartDownloadMachine)
    Facade.RemoveCommand(NotifyName.Event_machine_download_success)
    ModelList.Destroy()
end

function MainStartLogic.init_framework()
    Facade.InitFramework();
    Network.Start()
    MainStartLogic.RegCmd()
    ModelList.Init()
end

function MainStartLogic.init_promotion()
    if (promotionDataManager and promotionEventManager) then
        return
    end
    promotionDataManager = PromotionDataManager:new()
    promotionEventManager = PromotionEventManager:new()
    promotionEventManager:init()
    promotionDataManager:init()
end

function MainStartLogic.init_log()
    local val = fun.read_value("log_switch")
    -- local fps_val = fun.read_value("ShowFps")
    if val == "true" then
        log.enabled = true
    elseif val == "false" then
        log.enabled = false
    else
        log.enabled = true
    end
    --暂时屏蔽 by LwangZg
    --  if fps_val == "true" then
    --     AppConst.ShowFps = true
    -- else
    --     AppConst.ShowFps = false
    -- end
   
     if (fun.IsEditor()) then
        log.enabled = true
    else
         if LuaHelper.PublishType < 2 then
            log.enabled = true
        else
            log.enabled = false
        end
    end

end

function MainStartLogic.InitNotification()
    NotificationUtil.cancel_all_notifications()
end

return MainStartLogic
