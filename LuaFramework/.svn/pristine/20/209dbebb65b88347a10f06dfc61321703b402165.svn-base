---
--- 用于处理assetBundle的加载和卸载逻辑
--- Created by zlc.
--- DateTime: 2020/8/17 21:23
---
require "Utils.AssetList"
require "Logic.MultiLanguageManager"
AssetManager = {}


AssetManager.loaded_data = {}

local MACHINE_AB_NAME = {}     --机台专有资源
local machineId
local battleOverCallBack = nil --战斗结束回调
local battleTargetLoadCount = 0
local receiveBattleData = false



function AssetManager.get_machine_res(machine_id)
    machineId = machine_id
    return { "luaprefab_m" .. machine_id .. "_gameprefab_cell", "luaprefab_m" .. machine_id .. "_gameprefab_celleffect" }
end

--TODO 干嘛???????????
-- function AssetManager.load_sceneloading_common_res(cb)
--     if cb then
--         cb()
--     end
-- end

local common_res_callBack = nil
local needAtlas = 0

function AssetManager.load_common_res(cb)
    common_res_callBack = cb
    needAtlas = 11
    local needAtlas = { "GameItemAtlas", "PopupAtlas", "HeadAtlas", "GiftPackIconAtlas",
        "CityEntityAtlas", "CityAtlas", "SpecialGameplay", "HallMainAtlas", "ItemAtlas",
        "VipAtlas",
        "BingoPassAtlas"
    }
    for i = 1, #needAtlas do
        Cache.Load_Atlas(AssetList[needAtlas[i]], needAtlas[i], function()
            AssetManager.load_common_finish_percent()
        end)
    end
end

function AssetManager.load_guide_common_res(cb)
    common_res_callBack = cb
    needAtlas = 4
    local needAtlas = { "GameItemAtlas", "PopupAtlas", "HeadAtlas", "ItemAtlas", }
    for i = 1, #needAtlas do
        Cache.Load_Atlas(AssetList[needAtlas[i]], needAtlas[i], function()
            AssetManager.load_common_finish_percent()
        end)
    end
end

function AssetManager.load_common_finish_percent()
    needAtlas = needAtlas - 1
    if needAtlas <= 0 then
        if common_res_callBack then
            common_res_callBack()
        end
        --common_res_callBack = nil
    end
end

function AssetManager.load_audiomixer(cb)
    require "Logic.Sound.UISound"
    --加载混音器
    SoundHelper.init(function()
        UISound.load_lobby_res(cb)
    end)
end

function AssetManager.load_lobby_res(cb)
    --log.r("load_lobby_res   load_audiomixer")
    Cache.load_prefabs(AssetList["City1Entity"], "City1Entity")
    AssetManager.load_audiomixer(cb)
end

-- 加载进战斗的资源，包括战斗的ab资源和音效资源
function AssetManager.load_game_res(cb)
    receiveBattleData = false
    if ModelList.BattleModel:IsHangUp() then
        local map = false
        local callcb = false
        ---预留城市单独资源加载
        local gameType = ModelList.BattleModel:GetGameCityPlayID()
        local needAtlasList = Csv.GetData("new_game_bingo_view", gameType, "atlas")
        local loadIndex = 1
        local loadCallBack = function()
            Cache.load_texture(AssetList["BgZdgj"], "bgzdgj", nil)
            Cache.load_prefabs(AssetList["HangUpView"], "HangUpView", function()
                map = true
                log.r("HangUpView   loaded")
            end)
        end

        AssetManager.load_battle_atlas(needAtlasList, loadIndex, loadCallBack)


        LuaTimer:SetDelayLoopFunction(0.1, 0.1, 200, function()
          log.r("LwangZg ===> LuaTimer   倒计时 ..".." map "..tostring(map))
            if map and not callcb then
                callcb = true
                --log.r("callcb   loaded")
                if cb then
                    cb()
                end
            end
        end, function()
            if not callcb then
                --log.r("callcb  finish loaded")
                if cb then
                    cb()
                end
            end
        end, nil, LuaTimer.TimerType.UI)
    else
        ---预留城市单独资源加载
        local gameType = ModelList.BattleModel:GetGameCityPlayID()
        local needAtlasList = Csv.GetData("new_game_bingo_view", gameType, "atlas")
        local loadIndex = 1
        AssetManager.load_battle_atlas(needAtlasList, loadIndex, cb)
    end
end

function AssetManager.load_battle_atlas(loadAtlasList, loadIndex, cb)
    if loadIndex == 1 then
        battleOverCallBack = cb
        -- 加载完图集-1 加载完小丑资源 -1  加载完杯赛资源 -1  加载完卡包资源 -1
        battleTargetLoadCount = 4
        --log.r("battleTargetLoadCount  "..battleTargetLoadCount )
        if ModelList.BattleModel:HasGetBattleData() then
            AssetManager.load_res_after_receive_battle_data()
        end
    end
    if not loadAtlasList then
        if cb then
            cb()
        end
        return
    end
    if not loadAtlasList[loadIndex] then
        if loadIndex == #loadAtlasList then
            battleTargetLoadCount = battleTargetLoadCount - 1
            --log.r("battleTargetLoadCount  "..battleTargetLoadCount )
            if cb then
                cb()
            end
        else
            loadIndex = loadIndex + 1
            AssetManager.load_battle_atlas(loadAtlasList, loadIndex, cb)
        end
    else
        Cache.Load_Atlas(AssetList[loadAtlasList[loadIndex]], loadAtlasList[loadIndex], function()
            --log.r(loadAtlasList[loadIndex].. "   atlas loaded")
            if loadIndex == #loadAtlasList then
                AssetManager.CheckLoadBattleOverCallBack()
                --if cb then
                --    cb()
                --end
            else
                loadIndex = loadIndex + 1
                --battleCurrLoadCount = battleCurrLoadCount + 1
                --log.r("battleCurrLoadCount  "..battleCurrLoadCount )
                AssetManager.load_battle_atlas(loadAtlasList, loadIndex, cb)
            end
        end)
    end
end

--- 收到结算数据后，才能决定加载哪些资源,
---如果在预加载前收到，则不作处理
---如果在预加载后收到，则加载
function AssetManager.load_res_after_receive_battle_data()
    if not receiveBattleData then
        receiveBattleData = true
        AssetManager.LoadJokerAsset()
        AssetManager.LoadCompetitionAsset()
        AssetManager.LoadCardPackageAsset()
        AssetManager.CheckLoadBattleOverCallBack(true)
        --AssetManager.LoadCommonFlyAsset()
    end
end

function AssetManager.CheckLoadBattleOverCallBack(onlyCheck)
    if not onlyCheck and battleTargetLoadCount then battleTargetLoadCount = battleTargetLoadCount - 1 end
    --log.r("battleTargetLoadCount  "..battleTargetLoadCount)
    if 0 >= battleTargetLoadCount then
        if battleOverCallBack then
            battleOverCallBack()
            battleOverCallBack = nil
        end
    end
end

--- 小丑通用资源，可以提前预加载
function AssetManager.LoadJokerAsset()
    if ModelList.BattleModel.GetIsJokerMachine() then
        local cardJoker = require("View.Bingo.EffectModule.CardJoker.CardJokerEnterEffect")
        cardJoker:PreloadJokerResource()
    else
        battleTargetLoadCount = battleTargetLoadCount - 1
        --log.r("battleTargetLoadCount  "..battleTargetLoadCount )
    end
end

--- 加载日榜资源
function AssetManager.LoadCompetitionAsset()
    if ModelList.BattleModel:GetBattleCompetition() then
        Cache.load_materials("luaprefab.material.ef_hall_Coincookie", "ef_hall_Coincookie", function()
            Cache.load_prefabs(AssetList["DailyCompetitionCookiezhandou"], "DailyCompetitionCookiezhandou", function()
                AssetManager.CheckLoadBattleOverCallBack()
            end)
        end)
        UISound.load_competition_res()
    else
        battleTargetLoadCount = battleTargetLoadCount - 1
    end
end

--- 加载卡包资源
function AssetManager.LoadCardPackageAsset()
    local cardIds = ModelList.BattleModel:CardIdsContainCardPack()
    if cardIds and #cardIds > 0 then
        --battleTargetLoadCount = battleTargetLoadCount - 1
        --log.r("battleTargetLoadCount  "..battleTargetLoadCount )
        Cache.Load_Atlas(AssetList["SeasonCardOpenPackage"], "SeasonCardOpenPackage", function()
            local packageEnter = require("View/Bingo/EffectModule/BattleOpen/CardPackageEnterGameEffect")
            packageEnter:PreloadPackageResource()
        end)
    else
        battleTargetLoadCount = battleTargetLoadCount - 1
        --log.r("battleTargetLoadCount  "..battleTargetLoadCount )
    end
end

--- 加载公共飞行道具资源
function AssetManager.LoadCommonFlyAsset()
    local jokerRoot = fun.GetNotDestroyJokerParent()
    local parent = BaseView:GetRootView()
    Cache.load_prefabs(AssetList.FlyCommonEffectsView, "FlyCommonEffectsView", function(obj)
        --GoPool.CreatePool("FlyCommonEffectsView", 2, 10, obj,jokerRoot)
        BattleEffectPool:Recycle2("FlyCommonEffectsView", obj, parent)
        fun.set_parent(obj, jokerRoot)
        Cache.load_prefabs(AssetList.FlyRewardhit, "FlyRewardhit", function(obj2)
            --GoPool.CreatePool("FlyRewardhit", 3, 15, obj2,jokerRoot)
            BattleEffectPool:Recycle2("FlyRewardhit", obj2, parent)
            fun.set_parent(obj2, jokerRoot)
            Cache.load_prefabs(AssetList.FlyCoinEffectsView, "FlyCoinEffectsView", function(obj3)
                battleTargetLoadCount = battleTargetLoadCount - 1
                --GoPool.CreatePool("FlyCoinEffectsView", 2, 15, obj3,jokerRoot)
                BattleEffectPool:Recycle2("FlyRewardhit", obj3, parent)
                fun.set_parent(obj3, jokerRoot)
            end)
        end)
    end)
end

function AssetManager.unload_game_res()
    if ModelList.BattleModel:IsHangUp() then
        Cache.unload_atlas_ab("HangUpAtlas")
        Cache.unload_atlas_ab("BattleReadyAtlas")
        Cache.unload_atlas_ab("BingoAtlas")
        Cache.load_prefabs(AssetList["HangUpView"])
    else
        Cache.unload_atlas_ab("BattleReadyAtlas")
        Cache.unload_atlas_ab("BingoAtlas")
    end
    Cache.unload_atlas_ab("BattleExtraAtlas")
    Cache.unload_atlas_ab("BattleHawaii")
    Cache.unload_atlas_ab("ChristmasAtlas")
    Cache.unload_atlas_ab("ClimbRankAtlas")
    Cache.unload_atlas_ab("HawaiiBingoAtlas")
    Cache.unload_atlas_ab("LeetoleManBattleAtlas")
    Cache.unload_atlas_ab("LeetoleManBingoAtlas")
    Cache.unload_atlas_ab("SingleWolfBingoAtlas")
end

function AssetManager.unload_lobby_res_for_enter_game()
    --Cache.unload_atlas_ab("GiftPackAtlas")
    --Cache.unload_atlas_ab("FoodBagClaimAtlas")
    --Cache.unload_atlas_ab("City1EntityAtlas")
    --Cache.unload_atlas_ab("CityEntityAtlas")
    --Cache.unload_atlas_ab("City2EntityAtlas")
    --Cache.unload_atlas_ab("City3EntityAtlas")
    ----Cache.unload_atlas_ab("LoginAtlas")
    ----Cache.unload_atlas_ab("HallMainAtlas")
    --Cache.unload_atlas_ab("PowerUpAtlas")
    --Cache.unload_atlas_ab("Lobby1EntityAtlas")
    --Cache.unload_atlas_ab("PowerUpBackGroundAtlas")
    --Cache.unload_atlas_ab("PowerUpHintAtlas")
    --Cache.unload_atlas_ab("AdventureAtlas")
    --Cache.unload_atlas_ab("AutoHallAtlas")
    --Cache.unload_atlas_ab("BingoPassAtlas")
    --Cache.unload_atlas_ab("BingoPassPopupAtlas")
    --Cache.unload_atlas_ab("CityAtlas")
    --Cache.unload_atlas_ab("CityDownloadAtlas")
    --Cache.unload_atlas_ab("DailyRewardAtlas")
    --Cache.unload_atlas_ab("DoubleRewardAtlas")
    --Cache.unload_atlas_ab("EvaluateUsAtlas")
    --Cache.unload_atlas_ab("FBRecommendAtlas")
    --Cache.unload_atlas_ab("FoodBagClaimAtlas")
    --Cache.unload_atlas_ab("JackpotEnableAtlas")
    --Cache.unload_atlas_ab("MailAtlas")
    --Cache.unload_atlas_ab("MainTaskLevelUpAtlas")
    --Cache.unload_atlas_ab("MakeFoodAtlas")
    --Cache.unload_atlas_ab("MiniGame01Atlas")
    --Cache.unload_atlas_ab("MiniGame01PopupAtlas")
    --Cache.unload_atlas_ab("PowerupHelperAtlas")
    --Cache.unload_atlas_ab("PowerUpHintAtlas")
    --Cache.unload_atlas_ab("PuzzleAtlas")
    --Cache.unload_atlas_ab("QuickTaskPromotedAtlas")
    --Cache.unload_atlas_ab("RegisterRewardAtlas")
    --Cache.unload_atlas_ab("RegularlyAwardAtlas")
    --Cache.unload_atlas_ab("RouletteAtlas")
    --Cache.unload_atlas_ab("RouletteConfirmAtlas")
    --Cache.unload_atlas_ab("SettingAtlas")
    ----Cache.unload_atlas_ab("SpecialGameplay")
    --Cache.unload_atlas_ab("SpecialGameplayEnterAtlas")
    --Cache.unload_atlas_ab("TaskAtlas")
    --Cache.unload_atlas_ab("TournamentAtlas")
    --Cache.unload_atlas_ab("VipAtlas")
    AssetManager.unload_ab({ "luaprefab.material.ef_hall_Coincookie" })
    --TODO卸载大厅的Bundle
    -- resMgr:UnloadLobbyBundle()
end

function AssetManager.GetAssetNames(assetkey)
    local ret = {}
    local views = Split(assetkey, "_")
    local view = views[#views]


    if (assetkey == AssetList.M19999Effects) then
        return M19999Effects
    elseif (assetkey == AssetList.MachineCommonEffects) then
        return MachineCommonEffects
    elseif (assetkey == AssetList.MachineEnterAni) then
        return LobbyRes
    end
    local isView = string.find(view, "view")
    if (isView and isView >= 0) then
        return { view }
    end
    -- log.r("assetkey:",assetkey)
    return ret
end

local ABWhitelist = {
    "luaprefab_m19999_waitloadingview"
}


function AssetManager.IsWhitelistAb(ab)
    for k, v in pairs(ABWhitelist) do
        if (v == ab) then
            return true
        end
    end
    return false
end

function AssetManager.LoadCityBackgrounnd(cityid, rawimage, callback)
    if cityid then
        --local bg = "luaprefab_textures_citybackground" --string.format("luaprefab_textures_citybackground",cityid)
        local tName = string.format("city%sbackground", cityid)
        Cache.load_texture(AssetList[tName], tName, function(objs)
            if rawimage then
                rawimage.texture = objs
                if callback then
                    callback()
                end
            end
        end)
    end
end

function AssetManager.unload_ab_on_exit_machine(machineId)
    MACHINE_AB_NAME = AssetManager.get_machine_res(machineId)
    local ab_list   = fun.merge_array(MACHINE_AB_NAME, MACHINE_COMMON_AB_NAME)
    for k, v in pairs(ab_list) do
        if (not AssetManager.IsWhitelistAb(v)) then
            Cache.unload_ab(v)
            --log.r(" Cache.unloadsfd_ab "..v)
        end
    end
end

function AssetManager.unload_ab_on_exit_home()
    --log.r(" unload_ab_on_exit_home ")
    AssetManager.unload_ab(LOBBY_AB_NAME)
    -- Cache.unload_ab_on_exit_game()
end

function AssetManager.unload_ab(ab_list)
    --resMgr:PrintLoadedAssertBundleNames()

    for k, v in pairs(ab_list) do
        --log.r("AssetManager.unload_ab "..v)
        Cache.unload_ab(v)
    end

    --resMgr:PrintLoadedAssertBundleNames()
end

function AssetManager.unload_atlas_ab(ab_list, abName)
    if fun.starts(abName, "modules_") then
        for k, v in pairs(ab_list) do
            Cache.unload_atlas_ab(v, true, abName)
        end
    else
        for k, v in pairs(ab_list) do
            Cache.unload_atlas_ab(v)
        end
    end
end

--退出战斗时候 清理AB
function AssetManager.unload_ab_on_game_over()
    local ab_list = {}
    local city = ModelList.CityModel:GetCity()
    local atlas = string.format("City%sBattleIngredientAtlas", city)
    table.insert(ab_list, AssetList[atlas])
    --table.insert(ab_list,AssetList["BingoAtlas"])

    for k, v in pairs(ab_list) do
        if (not AssetManager.IsWhitelistAb(v)) then
            Cache.unload_ab(v)
            --log.r(" Cache.unloadsfd_ab "..v)
        end
    end
end

--- 在load_prefab的时候，保存prefab的引用,在下次load_prefab的时候，优先从这里instaniate
function AssetManager.SavePrefab(prefabName, prefab)
    if (prefabName and prefab) then
        if (not AssetManager.PrefabCache[prefabName]) then
            AssetManager.PrefabCache[prefabName] = {}
        end
        table.insert(AssetManager.PrefabCache[prefabName], prefab)
    end
end

--- 退出战斗时候，清理prefab的引用
function AssetManager.ClearPrefabCache()
    for k, v in pairs(AssetManager.PrefabCache) do
        for k1, v1 in pairs(v) do
            if (v1) then
                GameObject.Destroy(v1)
            end
        end
    end
    AssetManager.PrefabCache = {}
end
