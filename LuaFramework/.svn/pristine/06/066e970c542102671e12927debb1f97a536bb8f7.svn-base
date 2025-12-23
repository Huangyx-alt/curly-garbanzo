local GMView = BaseDialogView:New('GMView')
local this = GMView

this.viewType = CanvasSortingOrderManager.LayerType.Tips
this.auto_bind_ui_items = {
    "btn_mirror",
    "btn_close",
    "btn_show_map_id",
    "btn_change_account",
    "btn_close_self",
    "btn_enter_game",
    "uid",
    "exp",
    "cityexp",
    "btn_gm",
    "Placeholder",
    "cmd",
    "btn_add_coin",
    "btn_add_diamond",
    "btn_add_mirror",
    "btn_add_ticket",
    "flag_get_dropdown",
    "Label",
    "InputField",
    "btn_add_cherry",
    "btn_add_role_exp",
    "tip",
    "btn_jump_console",
    "btn_chang_net",
    "netCmd",
    "netlabel",
    "netInputField",
    "repeatEnterBattle",
    "repeatSign",
    "openGuide",
    "btn_onekey_init"
}

function GMView.Awake(obj)
    this.update_x_enabled = true
    this:on_init()
    this.repeatEnterBattle.isOn = ModelList.GMModel.IsAutoBattle
    this.repeatSign.isOn = ModelList.GMModel.IsAutoSign
    local isOpenGuide = ModelList.BattleModel.GetBattleSuperMatch()
    this.openGuide.isOn = isOpenGuide
end

function GMView.OnEnable()
    Facade.RegisterView(this)
    ModelList.GMModel.is_show = true
    local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
    local gmv = fun.find_child(game_ui, "GMView")

    if fun.get_active_scene().name == "SceneHome" then
        local game_ui = fun.find_gameObject_with_tag("NormalUiRoot")
        local child_count = fun.get_child_count(game_ui)
        for i = child_count, 1, -1 do
            local ab = fun.get_child(game_ui, i - 1)
            if ab and fun.get_active_self(ab) and ab.transform.name ~= "GMView" then
                if gmv then
                    fun.set_parent(gmv, ab.transform)
                end
                break
            end
        end
    elseif fun.get_active_scene().name == "SceneGame" or fun.get_active_scene().name == "SceneHangUp" then
        local canva = fun.get_component(this.exp.transform.parent, "Canvas")
        if canva then
            --canva.sortingLayerName = "FakeUI"
        end
    end
    if ModelList.PlayerInfoModel and ModelList.ItemModel then
        local uid = ModelList.PlayerInfoModel:GetUid() or "null"
        this.uid.text = "Uid:  " .. uid
        local coins = ModelList.ItemModel.get_coin()
        local diamond = ModelList.ItemModel.get_diamond()
        this.exp.text = "当前等级:  " ..
            ModelList.PlayerInfoModel.my_info.level ..
            " 等级经验 " ..
            ModelList.PlayerInfoModel.my_info.exp ..
            " Vip " .. ModelList.PlayerInfoModel.my_info.vip .. "  钻石 " .. diamond .. "   金币 " .. coins
        local all_city_exp = ModelList.CityModel:GetAllCityExp()
        for k, v in pairs(all_city_exp) do
            local clone = fun.get_instance(this.cityexp.gameObject, this.cityexp.gameObject.transform.parent)
            local txt = fun.get_component(clone, "Text")
            txt.text = "城市经验: " .. k .. "  " .. v
            fun.set_active(clone, true)
        end
    end



    local load_key = fun.read_value("last_gm_cmd", 'item#3#1000')
    this.InputField.text = load_key

    Event.Brocast(Notes.CARD_COLLIDER_OPEN, false)
    if this.btn_chang_net then
        local txt = fun.find_child(this.btn_chang_net, "Text")
        if txt then
            local text = fun.get_component(txt, "Text")
            if text then
                text.text = "HotFix"
            end
        end
    end
end

function GMView:GetRootView()
    if SceneViewManager.gobal_layer == nil then
        SceneViewManager.gobal_layer = UnityEngine.GameObject.FindWithTag("GlobalUiRoot")
    end
    local parent = SceneViewManager.gobal_layer
    return parent
end

function GMView:on_x_update()
    this:CheckDropdown()
    this:netDropdown()
    --if this.repeatEnterBattle then
    --    if this.repeatEnterBattle.isOn ~= ModelList.GameModel.repeatBattle then
    --        ModelList.GameModel.repeatBattle = this.repeatEnterBattle.isOn
    --    end
    --end
    if ModelList.GMModel.IsAutoBattle ~= this.repeatEnterBattle.isOn then
        ModelList.GMModel.IsAutoBattle = this.repeatEnterBattle.isOn
        --log.r("IsAutoBattle   "..tostring(ModelList.GMModel.IsAutoBattle))
    end
    if ModelList.GMModel.IsAutoSign ~= this.repeatSign.isOn then
        ModelList.GMModel.IsAutoSign = this.repeatSign.isOn
    end
    if ModelList.BattleModel.Is_Battle_SuperMatch ~= this.openGuide.isOn then
        ModelList.BattleModel.Is_Battle_SuperMatch = this.openGuide.isOn
        local type = this.openGuide.isOn and 0 or 1
        fun.save_value("openGuide", type)
    end
end

function GMView.OnDisable()
    --Facade.RemoveView(this)
    ModelList.GMModel.is_show = true
end

function GMView.OnDestroy()
    this:Destroy()
end

function GMView:on_close()
    ModelList.GMModel.is_show = true
    Event.Brocast(Notes.CARD_COLLIDER_OPEN, true)
end

function GMView:CloseFunc()
    --this.main_effect:Play("end")
    ModelList.GMModel:Reset()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
end

function GMView:ShowTip(tipName)

end

function GMView:InitTip()

end

function GMView:ShowCardId()
    if ModelList.BattleModel:GetGameType() == PLAY_TYPE.PLAY_TYPE_NORMAL then
        local cardView = ViewList.GameBingoView.cardView
        local loadData = ModelList.BattleModel:GetCurrModel():LoadGameData()
        local id_tex = fun.find_child(cardView.bingoMap1.gameObject, "Text")
        fun.set_active(id_tex, true)

        local id_tex = fun.find_child(cardView.bingoMap2.gameObject, "Text")
        fun.set_active(id_tex, true)

        local id_tex = fun.find_child(cardView.bingoMap3.gameObject, "Text")
        fun.set_active(id_tex, true)

        local id_tex = fun.find_child(cardView.bingoMap4.gameObject, "Text")
        fun.set_active(id_tex, true)
    else
        local cardView = ViewList.HangUpView.cardView.idToMap
        for k, v in pairs(cardView) do
            local id_tex = fun.find_child(v.gameObject, "Text")
            fun.set_active(id_tex, true)
        end
    end
end

function GMView:on_btn_mirror_click()
    --ViewList.GameBingoView.cardView.cardMagnifier.is_open_search  =  not  ViewList.GameBingoView.cardView.cardMagnifier.is_open_search
    Event.Brocast(EventName.Magnifier_Default_Attribute, true)
end

function GMView:on_btn_close_click()
    ModelList.GMModel:Reset()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
end

--- 重加载GMViewDebug脚本
function GMView:on_btn_show_map_id_click()
    local oldModule
    local filename = ("View.GM.GmViewDebug")
    if package.loaded[filename] then
        oldModule = package.loaded[filename]
        package.loaded[filename] = nil
    else
        --print('this file never loaded: ', filename)
        require(filename)
        oldModule = package.loaded[filename]
    end

    local ok, err = pcall(require, filename)
    if not ok then
        package.loaded[filename] = oldModule
        print('reload lua file failed.', err)
        return
    end

    ---更新旧表目前不需要
    local newModule = package.loaded[filename]
    --update_table(newModule, oldModule)
    oldModule.Excute = newModule.Excute

    --- 更新旧函数
    --if oldModule.OnReload ~= nil then
    --    oldModule:OnReload()
    --end
    package.loaded[filename] = oldModule
    oldModule.Excute()
end

function GMView:on_btn_change_account_click()
    local len = math.random(5, 15)
    --local path = string.gsub(UnityEngine.Application.dataPath, "/Assets", "") .. "/tool/randomlogin"
    local path = string.gsub(UnityEngine.Application.dataPath, "/Assets", "") .. "/randomlogin"
    file_save(path, this:getRandom(len))
    --fun.save_value("random_login", this:getRandom(len))
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
    ModelList.GMModel:Reset()
end

function GMView:getRandom(n)
    local t = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w",
        "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W",
        "X", "Y", "Z",
    }
    local s = ""
    for i = 1, n do
        s = s .. t[math.random(#t)]
    end;
    return s
end

function GMView:on_btn_close_self_click()
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
    ModelList.GMModel:Reset()
end

function GMView:on_btn_real_hangup_click()
    ModelList.HangUpModel:ReqEnterGame(4, 5)
end

function GMView._getLoginInfo()
    local openid = fun.read_value(DATA_KEY.openid, "")
    local token = fun.read_value(DATA_KEY.token, "")
    local platform = fun.read_value(DATA_KEY.platform, "")
    if GameUtil.is_windows_editor() then
        local local_openid = fun.read_local_openid()
        log.y("编辑器模式:使用自定义账号登录", local_openid)
        --if local_openid and type(local_openid) == "string" and local_openid ~= "" then
        --    openid = local_openid
        --else
        local path = string.gsub(UnityEngine.Application.dataPath, "/Assets", "") .. "/randomlogin"
        local readAll = function (file)
            local f = assert(io.open(file, "rb"))
            local content = f:read("*all")
            f:close()
            return content
        end
        local load_key = readAll(path)
        openid = UnityEngine.SystemInfo.deviceUniqueIdentifier .. load_key
        --end
    end
    return openid, token, platform
end

function GMView:on_btn_enter_game_click()
    local openid, token, platform = this._getLoginInfo()
    this:LoadNetWorkTexture("http://livepartybingo.test.51chivalry.com/ApiTest/getResponse")
end

function GMView:LoadNetWorkTexture(url, resName, callBack)
    local wr = UnityEngine.Networking.UnityWebRequest(url);
    wr.method = "POST"
    local form = UnityEngine.WWWForm:New();
    form:AddField("openid", "123")
    form:AddField("token", "123")
    form:AddField("platform", "123")
    form:AddField("version", "123")
    form:AddField("deviceId", "123")
    form:AddField("idfa", "123")
    form:AddField("arch", "123")
    form:AddField("appsflyerId", "123")
    Yield(wr:SendWebRequest())
    if GameUtil.UNITY_EDITOR() or GameUtil.UNITY_STANDALONE() then
        log.r("abc")
    end
end

function GMView:EnterGame(code, msg, data)
    log.log("自动登录返回", code, data)
    --Facade.SendNotification(NotifyName.CommonTip, "Facebook_fail")
    local t = {}
    local func = function (openid, token, device_id, platform)
        if not openid or not token or openid == "" or token == "" then
            log.log("请登录数据失败")
            return
        end
        t.openid = tostring(openid)
        t.token = tostring(token)
        t.platform = tonumber(platform)
        t.idfa = device_id

        t.deviceToken = "editor" --FirebaseHelper.LocalDeviceToken or "editor"

        t.appsflyerId = "editor" --SDK.GetAppFlyerId() or "editor"
        log.log(
            "请求登录\nopenid =", t.openid,
            "\ntoken =", t.token,
            "\nplatform =", t.platform,
            "\ndevideId =", t.deviceId
        )
        local score = fun.get_int("mobile_score", 0) --性能评分
        t.score = score
        t.version = tostring(UIUtil.get_client_version())
        Http.session_id = data.sessionId
        --Facade.SendNotification(NotifyName.CommonTip, "Facebook_fail")
    end

    func("1234", "1234", "1234", "1234")
end

function GMView:on_btn_real_hangup8_click()
    ModelList.HangUpModel:ReqEnterGame(8, 5)
end

function GMView:on_btn_real_hangup12_click()
    ModelList.HangUpModel:ReqEnterGame(12, 5)
end

function GMView:on_btn_add_ticket_click()
    --this:RequestTicket("http://192.168.1.200:8080/admin/user/updateInfo")
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#2#1000" });
end

function GMView:RequestTicket(url, resName, callBack)
    this:do_post(function ()
        log.r("dopost")
    end)
    --[[
    function send  ()
        local form =  UnityEngine.WWWForm.New()
        form:AddField("uid",ModelList.PlayerInfoModel.my_info.uid)
        form:AddField("tickets","200")
        local wr = UnityEngine.WWW(url,form);
        Yield(wr)
    end
    local send_cherry = send()
    coroutine.resume(send_cherry)
--]]
end

--框架方法，不应该直接调用
function GMView:do_post(callback, req_error_callback)
    -- 设置超时时间. 使用2秒做测试. 7秒是正式时间.
    --log.y("[do_post]",callback)
    local timeout = 10
    if false then
    else
        local function post_callback(code, txt)
            --log.y("code",code,"msg_id:",msg_id,"[Http原始响应数据]",txt)
            if code == 200 then
                if callback then
                    callback()
                end
            else
                if callback then
                    callback(-1, "Http Error " .. code, nil)
                end
                Message.DispatchMessage(msg_id, -1, nil)
            end
        end
        --log.o("[Http请求>>>]",Http.get_current_network_name(),get_msg_type_name(msg_id),msg_id,tbl)
        local request = LuaHttpRequest.New("http://192.168.1.200:8080/admin/user/updateInfo", "post", post_callback)
        request:AddHeader("Content-Type", "application/x-www-form-urlencoded")
        request:AddField("uid", "10113")
        request:AddField("coins", "200")
        request:AddField("diamond", "200")
        request:AddField("level", "")
        request:AddField("exp", "")
        request:AddField("hintTime", "200")
        request:AddField("tickets", "200")
        request:AddField("vipPts", "200")
        request:AddField("recharge", "200")
        request:AddField("loginTime", "")

        local reqKey = "getticket"
        --重写了http请示队列，保证回调是在主线程内，不会因为子线程问题导致，reqKey是唯一不重复使用
        request:Do(reqKey)
    end
end

function GMView:on_btn_add_coin_click()
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#2#100000" });
end

function GMView:on_btn_add_diamond_click()
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#1#1000" });
end

function GMView:on_btn_add_mirror_click()
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#3#1000" });
end

function GMView.PrintTable(t, name)
    local spaceAdd = 4
    local function getTableStr(t, name, space)
        local str = string.format("%s%s = {\n", string.rep(" ", space - spaceAdd), (name or "table"))
        local init = false
        for k, v in pairs(t) do
            if type(v) == "table" then
                str = str .. getTableStr(v, k, space + spaceAdd)
            else
                if type(v) == "string" and string.len(v) > 2 and string.sub(v, 1, 3) == "cs." then
                    init = true
                end
                str = str .. string.format("%s%s = %s\n", string.rep(" ", space), k, v)
            end
        end
        str = str .. string.rep(" ", space - spaceAdd) .. "}\n"
        return str
    end
    if (type(t) == "table") then
        print("\n" .. getTableStr(t, name, spaceAdd))
    else
        print(t)
    end
end

this.key = ""
this.out_content = ""
function GMView:PrintTable2(table, level)
    --level = level or 1
    --local indent = ""
    --for i = 1, level do
    --    indent = indent.."  "
    --end
    --
    --if this.key ~= "" then
    --    this.out_content = this.out_content.."\n" .. (indent..this.key.." ".."=".." ".."{")
    --else
    --    this.out_content = this.out_content.."\n" .. (indent .. "{")
    --end
    --
    --this.key = ""
    --for k,v in pairs(table) do
    --    if type(v) == "table" then
    --        this.key = k
    --        this:PrintTable2(v, level + 1)
    --    else
    --        local content = string.format("%s%s = %s", indent .. "  ",tostring(k), tostring(v))
    --        this.out_content = this.out_content.."\n" .. (content)
    --    end
    --end
    --this.out_content = this.out_content .."\n".. (indent .. "}")
    local content = TableToJson(table)
end

function GMView:writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then
            --log.r("1")
            return false
        end
        io.close(file)
        --log.r("2")
        return true
    else
        --log.r("3")
        return false
    end
end

function GMView:on_btn_gm_click()
    if not this.cmd then
        return
    end
    local txt = this.cmd.text
    --    local start = string.sub(txt,1,4)
    if txt == "rddata" then
        this.out_content = ""
        local jsonData = TableToJson((ModelList.GameModel:GetRoundData()))
        this:writefile("E:\\rounddata.txt", jsonData)
    elseif txt == "rddata2" then
        this.out_content = ""
        this:PrintTable2(ModelList.HangUpModel:GetRoundData())
        this:writefile("E:\\rounddata.txt", this.out_content)
    elseif txt == "net#0" then
        Network.OnException()
    elseif string.find(txt, "minigame#") ~= nil then
        local newId = string.sub(txt, 10)
        ModelList.SmallGameModel.GmModifyMiniGameTime(tonumber(newId))
    elseif txt == "hot" then ---内网测试,拉取修复更新
        log.r("this is hot fix  log")
        this:download_machine_directly()
    elseif string.find(txt, "time#") ~= nil then
        local new_cd = string.sub(txt, 6)
        UnityEngine.Time.timeScale = new_cd
    elseif txt == "net#1" then
        local loginModel = ModelList.loginModel
        print("----------SendConnect " .. tostring(loginModel.connector.host))
        CS.NetworkManager:SendConnect(loginModel.connector.host, loginModel.connector.port);
    elseif txt == "recharge" then
        --Event.Brocast(Notes.SYNC_NUMBER_ChARGE)
    elseif string.find(txt, "adbreak#") ~= nil then
        --指定openid

        Facade.SendNotification(NotifyName.ShowUI, ViewList.AdBreakView, nil)
    elseif string.find(txt, "skipguide#") ~= nil then
        --指定openid


        ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "guide#2#-1" });
        LuaTimer:SetDelayFunction(1, function ()
            ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "guide#3#-1" });
        end)

        LuaTimer:SetDelayFunction(2, function ()
            ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "guide#6#-1" });
        end)
    elseif txt == "login" then
        ViewList.EnterGameLoadingView:user_login()
    elseif txt == "net#0" then
        Network.OnException()
    elseif txt == "net#2" then
        Network.isConnect = false
    elseif txt == "win#0" then
        UIUtil.show_common_global_popup(8008, true, nil, nil, "coin", "coin")
    elseif txt == "win#1" then
        UIUtil.show_common_popup(8008, true, nil, nil, "coin")
        --Facade.SendNotification(NotifyName.Common.PopupDialog, 8008, 1,nil,nil,"coin");
    elseif string.find(txt, "music#") ~= nil then
        local new_cd = string.sub(txt, 7)
        UISound.play(new_cd)
    elseif string.find(txt, "acc#") ~= nil then --指定openid
        local new_cd = string.sub(txt, 5)
        local path = UnityEngine.Application.dataPath .. "/openid.txt"
        file_save(path, new_cd)
    elseif string.find(txt, "powercd") ~= nil then
        local new_cd = string.sub(txt, 8)
        if ModelList.BattleModel:GetGameType() == PLAY_TYPE.PLAY_TYPE_NORMAL then
            ViewList.GameBingoView.powerView.max_power = tonumber(new_cd)
            ViewList.GameBingoView.powerView.common_cd = 1
        else
            ViewList.HangUpView.powerView.max_power = tonumber(new_cd)
            ViewList.HangUpView.powerView.common_cd = 1
        end
    elseif txt == "hide#ready" then
        Facade.SendNotification(NotifyName.CloseUI, ViewList.ReadyView)
    elseif txt == "hideguide" then
        if ViewList.GuideView.go then
            Facade.SendNotification(NotifyName.HideUI, ViewList.GuideView)
        end
    elseif txt == "hide#ready" then
        Facade.SendNotification(NotifyName.CloseUI, ViewList.ReadyView)
    elseif txt == "crash" then
    elseif txt == "openguide#1" then
        fun.save_value("openGuide", 1)
    elseif txt == "openguide#0" then
        fun.save_value("openGuide", 0)
    elseif txt == "max" then
        SDK.ShowAdDebugger()
    elseif string.find(txt, "startGuide#") ~= nil then
        local new_cd = string.sub(txt, 12)
        ModelList.GuideModel:TriggerWinZoneBattleGuide(new_cd)
    elseif txt == "cache" then
        Cache.print_atlas_reference()
    elseif txt == "systime" then
        log.r(ModelList.PlayerInfoModel.get_cur_server_time())
        this.tip.text = ModelList.PlayerInfoModel.get_cur_server_time()
    elseif txt == "enterNormal" then
        log.r("enterNormal")
        ModelList.BattleModel.SendMessage(MSG_ID.MSG_BUY_POWERUP,
            { rate = 1, type = ModelList.CityModel:GetEnterGameMode(), cityId = 1 })
        LuaTimer:SetDelayFunction(0.5, function ()
            local powerupId = ModelList.CityModel:GetPowerupId()
            ModelList.BattleModel:SetGameType(ModelList.CityModel:GetEnterGameMode())
            LoadScene("SceneLoadingGame", ViewList.SceneLoadingGameView)
            local cardNum = ModelList.CityModel:GetCardNumber()
            local betRate = ModelList.CityModel:GetBetRate()
            local powerupId = ModelList.CityModel:GetPowerupId()
            local city = ModelList.CityModel:GetCity()
            ModelList.BattleModel.SendMessage(MSG_ID.MSG_GAME_LOAD_DEFAULT,
                { cardNum = 4, rate = 1, powerUpId = tonumber(powerupId), cityId = 1 });
            ModelList.GameModel:InitBattleMessageQueue()
        end)
    else
        -- ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, {cmd = this.cmd.text});
        SendGmCmd(this.cmd.text)
    end
    local load_key = fun.save_value("last_gm_cmd", txt)
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
end

function SendGmCmd(cmdStr)
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = cmdStr });
end

function GMView:CheckDropdown()
    if not fun.get_active_self(this.flag_get_dropdown) then
        if (this.Label) then
            local content = this.Label.text
            --log.r(content)
            if this.InputField == nil then log.r(" nil    lllllllll") end
            if content == "设置power CD" then
                this.InputField.text = "powercd1"
            elseif content == "指定同一powerup卡牌" then
                this.InputField.text = "powerupTest#114"
            elseif content == "取消同一powerup" then
                this.InputField.text = "powerupTest#-1"
            elseif content == "主动断网" then
                this.InputField.text = "net#0"
            elseif content == "手动重连" then
                this.InputField.text = "net#1"
            elseif content == "普通玩法实时数据" then
                this.InputField.text = "rddata"
            elseif content == "挂机玩法实时数据" then
                this.inputField.text = "rddata2"
            elseif content == "加道具" then
                this.InputField.text = "item#3#1000"
            elseif content == "systime" then
                log.r(ModelList.PlayerInfoModel.get_cur_server_time())
                this.tip.text = ModelList.PlayerInfoModel.get_cur_server_time()
            elseif content == "enterNormal" then
                log.r("enterNormal")
                ModelList.BattleModel.SendMessage(MSG_ID.MSG_BUY_POWERUP,
                    { rate = 4, type = ModelList.CityModel:GetEnterGameMode(), cityId = 1 })
                LuaTimer:SetDelayFunction(1, function ()
                    local powerupId = ModelList.CityModel:GetPowerupId()
                    ModelList.BattleModel.SendMessage(MSG_ID.MSG_GAME_LOAD_DEFAULT,
                        { cardNum = 4, rate = 1, powerUpId = tonumber(powerupId), cityId = 1 });
                end)
            else
                log.r("没有这条GM命令")
            end
        end
        if this.flag_get_dropdown then
            fun.set_active(this.flag_get_dropdown, true)
        end
    end
end

function file_save(filename, data)
    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, "wb")
        if file == nil then
            error(("Unable to write '%s': %s"):format(filename, err))
        end
    end
    file:write(data)
    if filename ~= nil then
        file:close()
    end
end

function GMView:on_btn_add_cherry_click()
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#6#1000" });
end

function GMView:on_btn_add_role_exp_click()
    ModelList.BattleModel.SendMessage(MSG_ID.MSG_SHOP_GM, { cmd = "item#5#100" });
end

function GMView:on_btn_enter_hangup_click()
end

function GMView:on_btn_jump_console_click()
    fun.OpenURL(LuaFramework.AppConst.HTTP_SERVER_IP .. "admin/#/index/welcome")
end

function GMView:on_btn_chang_net_click()
    UIUtil.LoadLogin()
    --Facade.SendNotification(NotifyName.CommonTip, "session_fail")
    Facade.SendNotification(NotifyName.CloseUI, ViewList.GMView)
end

function GMView:netDropdown()
    if this.netlabel then
        local content = this.netlabel.text
        if content == "内网" then
            this.netInputField.text = "http://livepartybingo.triwin.com"
        elseif content == "外网" then
            this.netInputField.text = "http://livepartybingo.test.51chivalry.com"
        elseif content == "正式服" then
            this.netInputField.text = "http://livepartybingo.51chivalry.com"
        end
    end
end

function GMView:on_btn_repeatEnterBattle_click()
    ModelList.GMModel.IsAutoBattle = not ModelList.GMModel.IsAutoBattle
    log.r("自动战斗   " .. tostring(ModelList.GMModel.IsAutoBattle))
end

function GMView:on_btn_repeatSign_click()
    ModelList.GMModel.IsAutoSign = not ModelList.GMModel.IsAutoSign
    --log.r("自动战斗   "..tostring(ModelList.GMModel.IsAutoBattle))
end

function GMView:on_btn_onekey_init_click()
    coroutine.start(function ()
        SendGmCmd("guide#2,3,5#-1")
        coroutine.wait(1.5)
        SendGmCmd("exp#10000")
        coroutine.wait(1.5)
        SendGmCmd("coins#100000000")
        coroutine.wait(1.5)
        SendGmCmd("diamond#100000000")
    end)
end

function GMView:DownLoadFixPackage()

end

function GMView.download_machine_directly()
    local downloadUrl = "http://192.168.1.215:5000/FixPackage.zip"
    local urlMd5 = ""

    if (downloadUrl == nil) then
        --下载成功，发通知
        --MachineDownloadManager._unzip_success_callback(machine_id, in_queue)
        return
    end
    local unzipDir = Util.DataPath
    local priority = 20
    local loader = SuperUnzipDownloader.create(downloadUrl, unzipDir, priority)
    MD5Checker.add_md5_data(downloadUrl, urlMd5)
    loader:add_event_listener(SuperDownloader.DownloadSuccess, function (owener, path)
    end)
    loader:add_event_listener(SuperDownloader.DownloadFail, function (owener, error)
        --事件打点_游戏行为_机台下载失败
    end)
    loader:add_event_listener(SuperDownloader.DownloadUpdate, function (owener, progress)
        local downloadSize = progress / 100 * machine_download_sizes[downloadUrl]
        status.progress = downloadSize / status.download_size
    end)
    loader:run(true)
end

return this
