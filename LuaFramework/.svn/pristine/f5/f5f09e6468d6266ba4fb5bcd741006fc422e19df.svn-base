--[[
Descripttion: 进战斗加载资源
version: 1.0.0
Author: gaoshuai
email: 745861933@qq.com
Date: 2025年7月8日 15:38:28
LastEditors: gaoshuai
LastEditTime: 2025年7月8日 15:38:28
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local CmdShowGameBingoView = require "Logic.Command.Battle.Enter.EnterSequence.CmdShowGameBingoView"
local CmdPreLoadModuleRes = require "Logic.Command.Battle.Enter.EnterSequence.CmdPreLoadModuleRes"

---@type CommandBase
local base = CommandBase
---@class CmdLoadModuleBattleRes : CommandBase
local CmdLoadModuleBattleRes = BaseClass("CmdLoadModuleBattleRes", base)

local CommandConst = CommandConst
local private = {}

function CmdLoadModuleBattleRes:OnCmdExecute()
    local sequence = CommandSequence.New({ LogTag = "CmdLoadModuleBattleRes CommandSequence", })

    --1、加载玩法脚本资源
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            xpcall(private.LoadBattleCode, __G__TRACKBACK__, self)
            cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
        end,
        LogTag = "CmdLoadModuleBattleRes 1",
    }))

    --2、加载玩法场景
    local _operation
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local sceneName = private.GetNextSceneName(self)
            --local procedure = require "Procedure/ProcedureNormalGame"
            LoadSceneAsync(sceneName, nil, function(operation)
                _operation = operation
                if IsNull(_operation) then
                    cmd:ExecuteDone(CommandConst.CmdExecuteResult.Fail)
                else
                    --_operation:UnSuspend()
                    --等场景激活
                    LuaTimer:SetDelayFunction(0.2, function()
                        cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
                    end)
                end
            end, true)
        end,
        LogTag = "CmdLoadModuleBattleRes 2",
    }))

    --3、加载玩法音效
    sequence:AddCommand(FunctionCommand.New({
        executeFunc = function(cmd)
            local game_type = ModelList.BattleModel:GetGameCityPlayID()
            local soundResName = Csv.GetData("new_game_music", game_type)
            if not soundResName or soundResName.music[1] == "0" then
                --_operation:UnSuspend()
                return cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end

            --战斗模块音效
            private.LoadBattleSound(self, soundResName, function()
                --_operation:UnSuspend()
                cmd:ExecuteDone(CommandConst.CmdExecuteResult.Success)
            end)
        end,
        LogTag = "CmdLoadModuleBattleRes 3",
    }))

    --4、加载玩法界面
    sequence:AddCommand(CmdShowGameBingoView.New({
        LogTag = "CmdLoadModuleBattleRes 4",
    }))

    --5、预加载玩法特效等
    sequence:AddCommand(CmdPreLoadModuleRes.New({
        LogTag = "CmdLoadModuleBattleRes 5",
    }))

    --结束
    sequence:AddDoneFunc(function()
        Facade.SendNotification(NotifyName.HideDialog, ViewList.BattleLoadingView, nil, function()
            LuaTimer:SetDelayFunction(0.5, function()
                self:ExecuteDone(sequence.executeResult)
            end)
        end)
    end)

    --开始
    sequence:Execute()
end

--------------私有方法-----Start------------------------------------------

function private.GetNextSceneName(self)
    local game_type = ModelList.BattleModel:GetGameCityPlayID()
    return Csv.GetData("new_city_play", game_type, "scenes_name")
end

function private.LoadBattleCode(self)
    local machine_id = 1
    local package = require("M" .. machine_id .. ".Package")
    --[[        Command.registerSound(entermachineModel,machine_id)]]
    PackageLoader.load(machine_id, package.clazz_list) --将机台的类，导入到全局作用域
    -- Command.initGlobalDataInSceneGame(entermachineModel,machine_id,package.effect_list)  --在SceneGame中创建需要全局访问的类
end

function private.LoadBattleSound(self, soundResName, cb)
    --- 预加载战斗开场需要的音效
    local sound_ab_list = deep_copy(soundResName.music)

    --- 加载小丑音效
    if ModelList.BattleModel.GetIsJokerMachine() or ModelList.CityModel:IsMaxBetRate() then
        sound_ab_list = fun.add_table(sound_ab_list, soundResName.joker_music)
        local jokerready = UISound.load_sound_data_in_need("jokerready")
        if jokerready then
            table.insert(sound_ab_list, jokerready.asset_path)
        end
    end
    sound_ab_list = private.LoadPuAudioList(self, "rewardflyincase", sound_ab_list)
    sound_ab_list = private.LoadPuAudioList(self, "bingofirework", sound_ab_list)

    ---加载背景音效
    local loadingAudio = UISound.load_sound_data_in_need("city1loadingover")
    if loadingAudio then
        table.insert(sound_ab_list, loadingAudio.asset_path)
    end
    ---加载倒计时时钟音效
    local countdown = UISound.load_sound_data_in_need("countdown")
    if countdown then
        table.insert(sound_ab_list, countdown.asset_path)
    end

    ---加载卡牌入场音效
    local cardgoin = UISound.load_sound_data_in_need("cardgoin")
    if cardgoin then
        table.insert(sound_ab_list, cardgoin.asset_path)
    end

    ---加载Pu入场音效
    local model = ModelList.BattleModel:GetCurrModel()
    if model and model:LoadGameData() then
        local powerUpData = model:LoadGameData().powerUpData
        if powerUpData and #powerUpData > 0 then
            sound_ab_list = private.LoadPuAudioList(self, "powerupinplace", sound_ab_list)
            sound_ab_list = private.LoadPuAudioList(self, "powerupok", sound_ab_list)
            sound_ab_list = private.LoadPuAudioList(self, "powerupchargeover", sound_ab_list)
            sound_ab_list = private.LoadPuAudioList(self, "powerupitem", sound_ab_list)
            sound_ab_list = private.LoadPuAudioList(self, "powerupuse", sound_ab_list)
            sound_ab_list = private.LoadPuAudioList(self, "powerupcharge", sound_ab_list)
            local gameType = ModelList.BattleModel:GetGameCityPlayID()
            local cdMusic = Csv.GetData("new_game_music", gameType, "power_cd")
            if cdMusic == "0" then
                local lv = (#ModelList.BattleModel:GetCurrModel():GetPowerUps()) / 3
                cdMusic = "powerupcd" .. lv
            end
            sound_ab_list = private.LoadPuAudioList(self, cdMusic, sound_ab_list)
        end
    end

    --- 加载卡包音效
    local cardIds = ModelList.BattleModel:CardIdsContainCardPack()
    if cardIds and #cardIds > 0 then
        -- 有卡包
        local gourmetbagfly = UISound.load_sound_data_in_need("gourmetbagfly")
        if gourmetbagfly then
            table.insert(sound_ab_list, gourmetbagfly.asset_path)
        end
        local gourmetbagreach = UISound.load_sound_data_in_need("gourmetbagreach")
        if gourmetbagreach then
            table.insert(sound_ab_list, gourmetbagreach.asset_path)
        end
        local gourmetbaggoin = UISound.load_sound_data_in_need("gourmetbaggoin")
        if gourmetbaggoin then
            table.insert(sound_ab_list, gourmetbaggoin.asset_path)
        end
    end

    --- 加载战斗背景音效
    local playId = ModelList.CityModel.GetPlayIdByCity()
    local city_music = Csv.GetData("new_city_play", playId, "music")
    --if ModelList.BattleModel.GetIsJokerMachine() or ModelList.CityModel:IsMaxBetRate() then
    --    city_music = Csv.GetData("new_city_play", playId, "maxbet_music")
    --end
    city_music = string.gsub(city_music, "[%_]", "")
    city_music = UISound.load_sound_data_in_need(city_music)
    if city_music then
        table.insert(sound_ab_list, city_music.asset_path)
    end

    UISound.load_res(sound_ab_list, function()
        fun.SafeCall(cb)
    end)
end

function private.LoadPuAudioList(self, puName, sound_ab_list)
    local puName = UISound.load_sound_data_in_need(puName)
    if puName then
        table.insert(sound_ab_list, puName.asset_path)
    end
    return sound_ab_list
end

--------------私有方法-----end------------------------------------------

return CmdLoadModuleBattleRes
