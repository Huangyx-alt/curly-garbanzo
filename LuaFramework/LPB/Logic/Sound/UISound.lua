UISound = {}

UISound.loaded_sound_data = {}

local SOUND_MACHINE_COMMON_AB_NAME = "luaprefab_sound_bingo_common" --通用机台音效
local SOUND_MACHINE_COMMON_UI_NAME = "luaprefab_sound_common"       --全场景通用UI音效（如按钮）
local SOUND_LOBBY_NAME = "luaprefab_sound_lobby"                    --大厅场景专有音效
local SOUND_CITY001_AB = "luaprefab_sound_city001"
local SOUND_LOADING_GAME_AB = "luaprefab_sound_loadinggame"
--local SOUND_HANGUP_GAME_AB = "luaprefab_sound_hangup"
local SOUND_HANGUP_CITY_AB = "luaprefab_sound_bingo_auto_city1"
local SOUND_GUIDE = "luaprefab_sound_guide"
local SOUND_LOGINMUIC = "luaprefab_sound_login"
local SOUND_MINIGAME_MUIC = "luaprefab_minigame_sound01"

---子玩法音效
local SOUND_MACHINE_HangUP_AB_NAME = "luaprefab_sound_bingo_hangup" --子玩法机台音效
local SOUND_MACHINE_AB_NAME1 = "luaprefab_sound_battlecity_1"       --子玩法机台音效
local SOUND_MACHINE_AB_NAME2 = "luaprefab_sound_battlecity_2"       --子玩法机台音效
local SOUND_MACHINE_AB_NAME3 = "luaprefab_sound_battlecity_3"       --子玩法机台音效
local SOUND_MACHINE_AB_NAME4 = "luaprefab_sound_bingo_hawaii"       --子玩法机台音效
local SOUND_MACHINE_AB_NAME5 = "luaprefab_sound_bingo_christmas"    --子玩法机台音效
local SOUND_MACHINE_AB_NAME6 = "luaprefab_sound_bingo_leetoleman"   --子玩法机台音效
local SOUND_MACHINE_AB_NAME7 = "luaprefab_sound_bingo_singlewolf"   --子玩法机台音效
local SOUND_MACHINE_AB_NAME8 = "luaprefab_sound_play10"             --子玩法机台音效
local SOUND_MACHINE_AB_NAME9 = "luaprefab_sound_play11"             --子玩法机台音效
local SOUND_MACHINE_AB_NAME10 = "luaprefab_sound_bingo_joker"       --子玩法机台音效
local SOUND_MACHINE_AB_NAME11 = "luaprefab_sound_bingo_queencharms" --子玩法机台音效



local currentBgmName
local isLobby = false
function UISound.load_lobby_res(cb)
    local lobby = "luaprefab_sound_lobby"
    isLobby = true
    UISound.stop_other_coroutine(1)
    UISound.load_power_res(cb)
end

function UISound.load_machine_res(machine_id, cb)
    --UISound.sound_machine_ab_name = "luaprefab_m"..machine_id.."_sound" --机台专有音效
    --local sound_ab_list ={SOUND_MACHINE_COMMON_AB_NAME}
    --UISound.load_res(sound_ab_list,cb)
    UISound.stop_other_coroutine(2)
    if cb then
        cb()
    end
end

function UISound.load_login_res(cb)
    --local sound_ab_list ={SOUND_LOGINMUIC}
    --UISound.load_res(sound_ab_list,cb)
    if cb then
        cb()
    end
end

function UISound.load_loading_res(cb)
    --local sound_ab_list ={SOUND_LOADING_GAME_AB}
    --UISound.load_res(sound_ab_list,cb)
    if cb then
        cb()
    end
end

local lastBgmName = nil

function UISound.play_temporary_bgm(name)
    if (name ~= lastBgmName) then
        lastBgmName = UISound.get_playing_bgm() or "city"
        UISound.play_bgm(name)
    end
end

function UISound.resume_last_bgm()
    if (lastBgmName == nil) then
        lastBgmName = "ciyt"
    end
    UISound.play_bgm(lastBgmName)
end

function UISound.unload_loading_res()
    --Cache.unload_ab(SOUND_LOADING_GAME_AB)
    --UISound.unload_sound_data(SOUND_LOADING_GAME_AB)
end

function UISound.load_city_res(cb)
    --UISound.load_res({SOUND_CITY001_AB},cb)
    if cb then
        cb()
    end
end

function UISound.unload_city_res()
    --Cache.unload_ab(SOUND_CITY001_AB)
    --UISound.unload_sound_data(SOUND_CITY001_AB)
end

function UISound.load_machine_and_commonUI_res(cb)
    ----UISound.sound_machine_ab_name = "luaprefab_m"..machine_id.."_sound"
    ----local sound_ab_list ={SOUND_MACHINE_COMMON_UI_NAME,SOUND_MACHINE_COMMON_AB_NAME,UISound.sound_machine_ab_name}
    local sound_ab_list = {}
    --for i = 1, 75 do
    --    table.insert(sound_ab_list, "luaprefab_sound_bingo_common_commonnormal" .. tostring(i))
    --end
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_commonbingo")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_whisper")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_kickcall")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_kickerror")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_kickreword")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_chips")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_powerupok")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_powerupcd")
    --table.insert(sound_ab_list, "luaprefab_sound_bingo_common_powerupuse")
    ----table.insert(sound_ab_list, "luaprefab_sound_battlecity_" .. tostring(curr_city))
    --UISound.load_res(sound_ab_list, nil)
    if cb then cb() end
end

function UISound.load_guide_res(cb)
    --local sound_ab_list ={SOUND_GUIDE}
    --UISound.load_res(sound_ab_list,cb)
    if cb then
        cb()
    end
end

function UISound.load_hangup_res(cb)
    --local sound_ab_list ={SOUND_HANGUP_CITY_AB}
    --UISound.load_res(sound_ab_list,cb)
    if cb then
        cb()
    end
end

function UISound.load_res(sound_ab_list, cb)
    UISound.load_sound_data(sound_ab_list)

    SoundHelper.load(sound_ab_list,
        function ()
            if cb then
                cb()
            end
        end)
end

function UISound.load_sound_data(list)
    local isEditor = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor or
    UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor
    for i = 1, #list do
        local ab_name = list[i]
        for _, v in pairs(Csv.audio) do
            if ab_name == v.asset_path then
                UISound.loaded_sound_data[v.sound_name] = v

                if (not isEditor) or AppConst.EditMode == false then
                    UISound.loaded_sound_data[v.sound_name].file_name = StringUtil.split_string(v.file_name, ".")[1]
                end
            end
        end
    end
end

function UISound.unload_sound_data(list)
    for i = 1, #list do
        local ab_name = list[i]
        for _, v in pairs(Csv.audio) do
            if ab_name == v.asset_path then
                UISound.loaded_sound_data[v.sound_name] = nil
                break
            end
        end
    end
end

function UISound.unload_lobby_res()
    -- UISound.unload_sound_data(SOUND_LOBBY_NAME)
    -- Cache.unload_ab(SOUND_LOBBY_NAME)
end

function UISound.unload_machine_res()
    --Cache.unload_ab(SOUND_MACHINE_COMMON_AB_NAME)
    --Cache.unload_ab(SOUND_MACHINE_HangUP_AB_NAME)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME1)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME2)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME3)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME4)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME5)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME6)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME7)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME8)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME9)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME10)
    --Cache.unload_ab(SOUND_MACHINE_AB_NAME11)
    --
    --UISound.unload_sound_data({
    --    SOUND_MACHINE_COMMON_AB_NAME,
    --                            SOUND_MACHINE_HangUP_AB_NAME,
    --                            SOUND_MACHINE_AB_NAME1,
    --                            SOUND_MACHINE_AB_NAME2,
    --                            SOUND_MACHINE_AB_NAME3,
    --                            SOUND_MACHINE_AB_NAME4,
    --                            SOUND_MACHINE_AB_NAME5,
    --                            SOUND_MACHINE_AB_NAME6,
    --                            SOUND_MACHINE_AB_NAME7,
    --                            SOUND_MACHINE_AB_NAME8,
    --                            SOUND_MACHINE_AB_NAME9,
    --                            SOUND_MACHINE_AB_NAME10,
    --                            SOUND_MACHINE_AB_NAME11
    --})
end

function UISound.Destroy()
    --log.r("UISound.Destroy")
    UISound.loaded_sound_data = {}
    Cache.unload_ab(SOUND_MACHINE_COMMON_AB_NAME)
    Cache.unload_ab(UISound.sound_machine_ab_name)
    Cache.unload_ab(SOUND_LOBBY_NAME)
    Cache.unload_ab(SOUND_MACHINE_COMMON_UI_NAME)
    currentBgmName = nil
end

function UISound.IsHasSound(sound_name)
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    local data = UISound.loaded_sound_data[sound_name]
    return data ~= nil;
end

function UISound.play(sound_name, volume)
    --if SoundHelper.sound_switch == "close" then return 0 end

    if sound_name == nil then
        return
    end
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    log.b("play sound " .. tostring(sound_name))
    local data = UISound.loaded_sound_data[sound_name]
    if data == nil then
        --log.r("no find sound: "..sound_name)
        ---2023.10.19 声音改成按需加载，不再预加载
        UISound.load_res_in_need(sound_name, function ()
            local data = UISound.loaded_sound_data[sound_name]
            if data == nil then
                log.r("no find sound: " .. sound_name)
                return
            else
                --log.r("find sound: "..sound_name.."   data.file_name  "..data.file_name)
            end
            return SoundHelper.play(data.asset_path, data.file_name, sound_name, nil, volume)
        end)
        return true
    end
    if nil == volume then
        volume = -1
    end
    return SoundHelper.play(data.asset_path, data.file_name, sound_name, nil, volume)
end

function UISound.stop(sound_name)
    if sound_name == nil then
        return
    end
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    SoundHelper.stop_sound_by_name(sound_name)
end

function UISound.play_loop(sound_name)
    --if SoundHelper.sound_switch == "close" then return 0 end
    log.r("PlaySound: " .. tostring(sound_name))
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    local data = UISound.loaded_sound_data[sound_name]
    --log.b("play sound",sound_name)
    if data == nil then
        ----log.r("no find sound: "..sound_name)
        ---2023.10.19 声音改成按需加载，不再预加载
        UISound.load_res_in_need(sound_name, function ()
            local data = UISound.loaded_sound_data[sound_name]
            if data == nil then
                log.r("no find sound: " .. sound_name)
                return
            end
            SoundHelper.play_loop(sound_name, data.asset_path, data.file_name)
        end)
        return true
    end
    return SoundHelper.play_loop(sound_name, data.asset_path, data.file_name)
end

function UISound.play_loop_with_volume(sound_name, volume)
    --if SoundHelper.sound_switch == "close" then return 0 end
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    local data = UISound.loaded_sound_data[sound_name]
    log.b("play sound  " .. tostring(sound_name))
    if data == nil then
        --log.r("no find sound: "..sound_name)
        ---2023.10.19 声音改成按需加载，不再预加载
        UISound.load_res_in_need(sound_name, function ()
            local data = UISound.loaded_sound_data[sound_name]
            if data == nil then
                log.r("no find sound: " .. sound_name)
                return
            end
            SoundHelper.play_loop_with_volume(sound_name, data.asset_path, data.file_name, nil, volume)
        end)
        return true
    end
    return SoundHelper.play_loop_with_volume(sound_name, data.asset_path, data.file_name, nil, volume)
end

function UISound.set_bgm_volume(targetVolume)
    SoundHelper.set_bgm_volume(targetVolume)
end

function UISound.fade_in_bgm(sound_name)
    --播放音效并音效渐强动画
    --if SoundHelper.music_switch == "close" then return 0 end
    if sound_name == nil then
        return
    end
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    local data = UISound.loaded_sound_data[sound_name]
    if data == nil then
        --log.r("no find sound: "..sound_name)
        ---2023.10.19 声音改成按需加载，不再预加载
        UISound.load_res_in_need(sound_name, function ()
            local data = UISound.loaded_sound_data[sound_name]
            if data == nil then
                log.r("no find sound: " .. sound_name)
                return
            end
            SoundHelper.fade_in_bgm(data.asset_path, data.file_name)
        end)
        return true
    end
    --log.b("fade_in_bgm  ",sound_name .."    asset_path   "..data.asset_path.."  file_name   "..data.file_name)
    SoundHelper.fade_in_bgm(data.asset_path, data.file_name)
end

function UISound.play_bgm(sound_name)
    --if SoundHelper.music_switch == "close" then return 0 end
    -- 临时切换
    UISound.fade_in_bgm(sound_name)

    --[[
         SoundHelper.stop_bgm()
         local data = UISound.loaded_sound_data[sound_name]
         if data == nil then
             log.r("no find sound: "..sound_name)
             return
         end
         log.b("play sound __",sound_name)
         SoundHelper.play_bgm(data.asset_path,data.file_name)  --endy test
         --]]
    currentBgmName = sound_name
end

function UISound.get_playing_bgm()
    return currentBgmName
end

function UISound.tween_out_bgm()
    --只播放音效从当前值 渐弱到0的动画
    --if SoundHelper.music_switch == "close" then return 0 end
    SoundHelper.tween_out_bgm(1)
end

function UISound.tween_in_bgm()
    --只播放音效从当前值 渐强到1的动画
    --if SoundHelper.music_switch == "close" then return 0 end

    SoundHelper.tween_in_bgm(1)
end

function UISound.mix_fade_out_bgm()
    --if SoundHelper.music_switch == "close" then return 0 end

    SoundHelper.mix_fade_out_bgm(ArtConfig.Bgm_fadein_time)
end

function UISound.max_fade_in_bgm()
    --if SoundHelper.music_switch == "close" then return 0 end


    SoundHelper.mix_fade_in_bgm(ArtConfig.Bgm_fadein_time)
end

function UISound.pause_all_sound()
    SoundHelper.pause_all_sound()
end

function UISound.resume_all_sound()
    SoundHelper.resume_all_sound()
end

function UISound.stop_bgm()
    SoundHelper.stop_bgm()
    currentBgmName = nil
end

function UISound.stop_sound_by_name(sound_effect_name)
    sound_effect_name = string.gsub(sound_effect_name, "[%_]", "")
    --log.r("UISound.stop_sound_by_name",sound_effect_name)
    SoundHelper.stop_sound_by_name(sound_effect_name)
end

function UISound.stop_loop(sound_name)
    sound_name = string.gsub(sound_name, "[%_%-]", "")
    local data = UISound.loaded_sound_data[sound_name]
    --log.b("stop_loop sound",sound_name)
    if data == nil then
        --log.r("no find sound: " .. sound_name)
        return
    end
    --log.r("PlaySound: stoploop " .. sound_name)
    SoundHelper.stop_sound_by_name(data.sound_name)
end

function UISound.is_bgm_playing()
    return SoundHelper.is_bgm_playing()
end

function UISound.tween_out_music(sound_full_name, time, source_volume, target_volume, call_back)
    if sound_full_name == "" then
        return 0
    end
    SoundHelper.TweenOutMusic(sound_full_name, time, source_volume, target_volume, call_back)
end

function UISound.load_minigame_res(cb)
    local sound_ab_list = { SOUND_MINIGAME_MUIC }
    UISound.load_res(sound_ab_list, cb)
end

function UISound.unload_battle_res()
    Cache.unload_ab(SOUND_LOADING_GAME_AB)
    UISound.unload_sound_data({SOUND_LOADING_GAME_AB})
end

function UISound.load_joker_res()
    --local sound_ab_list = {
    --    "luaprefab_sound_bingo_joker_jockerwhistle1",
    --    "luaprefab_sound_bingo_joker_jockerwhistle2",
    --    "luaprefab_sound_bingo_joker_jokerbonues",
    --    "luaprefab_sound_bingo_joker_jokerdoublecoins",
    --    "luaprefab_sound_bingo_joker_jokerready",
    --    "luaprefab_sound_bingo_joker_jokerready4",
    --    "luaprefab_sound_bingo_joker_jokerready5",
    --    "luaprefab_sound_bingo_joker_jokerready6",
    --    "luaprefab_sound_bingo_joker_jokerready7",
    --    "luaprefab_sound_bingo_joker_jockerballcaller",
    --    "luaprefab_sound_bingo_joker_jockerhummer",
    --    "luaprefab_sound_bingo_joker_jockerlandmine",
    --}
    --UISound.load_res(sound_ab_list, nil)
end

function UISound.load_competition_res()
    --local sound_ab_list = {
    --    "luaprefab_sound_lobby_competitionlist",
    --    "luaprefab_sound_lobby_competitionlist",
    --    "luaprefab_sound_lobby_competitionpopup",
    --    "luaprefab_sound_lobby_competitionputin",
    --}
    --UISound.load_res(sound_ab_list, nil)
end

function UISound.load_power_res(cb)
    --local sound_ab_list = {
    --    "luaprefab_sound_lobby_powerupaccumulation",
    --    "luaprefab_sound_lobby_powerupflip",
    --    "luaprefab_sound_lobby_poweruppay",
    --    "luaprefab_sound_lobby_powerupopen",
    --    "luaprefab_sound_lobby_powerupappear",
    --    "luaprefab_sound_lobby_powerupenergy1",
    --    "luaprefab_sound_lobby_powerupenergy2",
    --    "luaprefab_sound_lobby_powerupenergy3",
    --    "luaprefab_sound_lobby_powerupput",
    --    "luaprefab_sound_lobby_poweruptearup" }
    --UISound.load_res(sound_ab_list, nil)
    if cb then cb() end
end

function UISound.delay_load_power_res()

end

---- 2023.10.19 声音改成按需加载，不再预加载
function UISound.load_res_in_need(sound_name, cb)
    local v = UISound.load_sound_data_in_need(sound_name)
    if v then
        SoundHelper.load({ v.asset_path },
            function ()
                if cb then
                    cb()
                end
            end)
    else
        log.r("load_res_in_need   null")
        if cb then
            cb()
        end
    end
end

function UISound.load_sound_data_in_need(sound_name)
    local isEditor = UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor or
    UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor
    for _, v in pairs(Csv.audio) do
        if sound_name == v.sound_name then
            UISound.loaded_sound_data[v.sound_name] = v

            if (not isEditor) or AppConst.EditMode == false then
                UISound.loaded_sound_data[v.sound_name].file_name = StringUtil.split_string(v.file_name, ".")[1]
            end
            --UISound.loaded_sound_data[v.sound_name].file_name = StringUtil.split_string(v.file_name, ".")[1]
            return v
        end
    end
end

local unload_lobby_coroutine = {}
local unload_battle_coroutine = {}

function UISound.stop_other_coroutine(sound_scene)
    if sound_scene == 1 then
        table.each(unload_lobby_coroutine, function (i, v)
            if v then
                coroutine.stop(v)
            end
        end)
        unload_lobby_coroutine = {}
    else
        table.each(unload_battle_coroutine, function (i, v)
            if v then
                coroutine.stop(v)
            end
        end)
        unload_battle_coroutine = {}
    end
end

function UISound.unload_sound_data_in_need(sound_scene)
    local loading = "luaprefab_sound_loadinggame"
    local common = "luaprefab_sound_common"
    if sound_scene == 1 then
        -- 卸载大厅的音效
        local lobby = "luaprefab_sound_lobby"
        local lobbyCompetion = "luaprefab_sound_lobby_competition"
        local delay = 0
        for _, v in pairs(UISound.loaded_sound_data) do
            if fun.starts(v.asset_path, lobby) and not fun.starts(v.asset_path, loading) and not fun.starts(v.asset_path, lobbyCompetion)
                and not fun.starts(v.asset_path, common) then
                local _coroutine = coroutine.start(function ()
                    delay = delay + 0.2
                    coroutine.wait(delay)
                    Cache.unload_ab(v.asset_path)
                    UISound.unload_sound_data({v.asset_path})
                    UISound.loaded_sound_data[v.sound_name] = nil
                    table.remove(unload_lobby_coroutine, 1)
                end)
                if not _coroutine then
                    Cache.unload_ab(v.asset_path)
                    UISound.unload_sound_data({v.asset_path})
                    UISound.loaded_sound_data[v.sound_name] = nil
                else
                    table.insert(unload_lobby_coroutine, _coroutine)
                end
            end
        end
    elseif sound_scene == 2 then
        -- 卸载战斗的音效
        local lobby = "luaprefab_sound_lobby"
        local delay = 0
        for _, v in pairs(UISound.loaded_sound_data) do
            if not fun.starts(v.asset_path, lobby) and not fun.starts(v.asset_path, loading) and not fun.starts(v.asset_path, common) then
                local _coroutine = coroutine.start(function ()
                    delay = delay + 0.2
                    coroutine.wait(delay)
                    Cache.unload_ab(v.asset_path)
                    UISound.unload_sound_data({v.asset_path})
                    UISound.loaded_sound_data[v.sound_name] = nil
                    table.remove(unload_battle_coroutine, 1)
                end)
                if not _coroutine then
                    Cache.unload_ab(v.asset_path)
                    UISound.unload_sound_data({v.asset_path})
                    UISound.loaded_sound_data[v.sound_name] = nil
                else
                    table.insert(unload_battle_coroutine, _coroutine)
                end
            end
        end
    end
end

---卸载bingo对局叫号球的声音,使用完即回收

function UISound.unload_battle_call_number_sound_data(soundName)
    for _, v in pairs(UISound.loaded_sound_data) do
        if v.sound_name == soundName then
            Cache.unload_ab(v.asset_path)
            UISound.unload_sound_data({v.asset_path})
            break
        end
    end
end
