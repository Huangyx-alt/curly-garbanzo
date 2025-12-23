local modelNameList = {
    "LoginModel",
    "PlayerInfoModel",
    "CityModel",
    "GameModel",
    "BattleModel",
    "HangUpModel",
    "ItemModel",
    "TaskModel",
    "PuzzleModel",
    "NewPuzzleModel",
    "GiftPackModel",
    "RegularlyAwardModel",
    "ShopModel",
    "GuideModel",
    "RofyModel",
    "ActivityModel",
    "ApplicationGuideModel",
    "AdModel",
    "PopupModel",
    "TournamentModel",
    "FixedActivityModel",
    "CouponModel",
    "RouletteModel",
    "BingopassModel",
    "MiniGameModel",

    "GMModel",
    "MailModel",
    "HawaiiGameModel",
    "ChristmasGameModel",
    "ExtraBonusModel",
    "AppEventTimerModel",
    "CompetitionModel",
    "PlayerInfoSysModel",
    "AppEventTimerModel",
    --"LeetoleManModel",
    --"SingleWolfGameModel",
    --"EnterMachineModel"
    --"FoodPartyGameModel",

    "UltraBetModel",
    "FBFansModel",
    "SeasonCardModel",
    "ClubModel",
    "ServerNotifyModel",
    "CarQuestModel",
    --"WinZoneGameModel",
    "WinZoneModel",
    "GameActivityPassModel",
    "VolcanoMissionModel",
    "HallofFameModel",
    "SuperMatchModel",
    "SmallGameModel",
    "PiggySloltsGameModel",
    "BetConfigModel",
    "MainShopModel",
}

local model_part = {"BaseGameModel"}

local all_model_list = (function()
    local models = {}
    for key, value in pairs(model_part) do
        table.insert(models,value)
    end
    for key, value in pairs(modelNameList) do
        table.insert(models,value)
    end
    return models
end)()

ModelList = {}

(function()
    for index, value in ipairs(model_part) do
        local model = require(string.format("Model/ModelPart/%s",value))
        if model then
            ModelList[value] = model
            local f = string.sub(value,1,1)
            local lower = string.gsub(value,f,string.lower(f),1)
            ModelList[lower] = model
        end
    end
    for index, value in ipairs(modelNameList) do
        local model = require(string.format("Model/%s",value))
        if model then
            ModelList[value] = model
            local f = string.sub(value,1,1)
            local lower = string.gsub(value,f,string.lower(f),1)
            ModelList[lower] = model
        end
    end
end)()

--- 主包自带的模块
local mainModularModelName = { "GameModel", "HangUpModel", "HawaiiGameModel", "ChristmasGameModel" }

function ModelList.ClearModularModel()
    for _, v in pairs(Csv.new_game_mode) do
        local modelName = v.model
        if not fun.is_include(modelName, mainModularModelName) and ModelList[modelName] then
            ModelList[modelName]:unRegEvent()
            ModelList[modelName]:SetInit(false)
            if ModelList[modelName].CancelInitData then
                ModelList[modelName]:CancelInitData()
            end
            ModelList[modelName] = nil
            local mName = string.format("Model.%s",modelName)
            _G[modelName] = nil
            package.loaded[mName] = nil
            package.preload[mName] = nil
        end
    end
end



function ModelList.ClearModelList()
    for index, value in ipairs(modelNameList) do
        ModelList[value]:unRegEvent()
        if ModelList[value].CancelInitData then
            ModelList[value]:CancelInitData()
        end
        local mName = string.format("Model.%s",value)
        _G[value] = nil
        package.loaded[mName] = nil
        package.preload[mName] = nil
    end
    ModelList.ClearModularModel()
    for index, value in ipairs(model_part) do
        ModelList[value]:unRegEvent()
        if ModelList[value].CancelInitData then
            ModelList[value]:CancelInitData()
        end
        local mName = string.format("Model.ModelPart.%s",value)
        _G[value] = nil
        package.loaded[mName] = nil
        package.preload[mName] = nil
    end
------------------ModelList永远放最后---------------------------
    _G["ModelList"] = nil
    package.loaded["Model.ModelList"] = nil
    package.preload["Model.ModelList"] = nil
    require "Model/ModelList"
    ModelList.Init()
end

function ModelList.Init()
    for k, v in pairs(all_model_list) do
        ModelList[v]:RegEvent()
        ModelList[v]:InitData()
    end
end

function ModelList.ReInitByServer(unOpenIdList)
    unOpenIdList = {16}
    for i = 1, #unOpenIdList do
        local data = Csv.GetData("control_function",unOpenIdList[i])
        local models =data.models
        local uis = data.uis
        for m = 1, #models do
            for k, v in pairs(all_model_list) do
                if ModelList[v].name == models[m] then
                    v = nil
                    break
                end
            end
        end
        for m = 1, #uis do
            if ViewList[uis[m]]  then
                ViewList[uis[m]] = nil
            end
        end
    end
end

function ModelList.Destroy()
    for k, v in pairs(all_model_list) do
        ModelList[v]:Destroy()
    end
end

function ModelList.SetLoginData(data)
    for k, v in pairs(all_model_list) do
        ModelList[v]:SetLoginData(data)
    end
end

--传入key指定要更新的Model，免去遍历所有Model，免去一些没有更新的Model也要走一遍流程,params用于区别更新的字段
function ModelList.SetDataUpdate(data,key,params)
    if data then
        if key and ModelList[key] then
            ModelList[key]:SetDataUpdate(data,params)
        else
            for k, v in pairs(all_model_list) do
                ModelList[v]:SetDataUpdate(data,params)
            end
        end 
    end
end

---新加载了一个模块model，先要初始化一次
function ModelList:InitModule(model)
    if not model:IsInit() then
        log.r("InitModule   ")
        model:RegEvent()
        model:InitData()
        model:SetInit()
    end
end


function ModelList.OnLevelChange(value)
    for k, v in pairs(all_model_list) do
        ModelList[v]:OnLevelChange(value)
    end
end

---退出模块的处理
--1.默认模块都是独立性较强，可以在退出时清空相关的Lua脚本
--2.对于频繁进出同一模块,暂时不做处理
--3.模块保留一个参数 _unloadWhenExit,默认为nil,若设置为true,则不执行清理
--4.只清理lua脚本,不主动清理资源相关
--卸载的时机
--1.返回登录界面的时候
--2.进入一个新模块的时候
--3.退出大厅返回选择城市的时候
function ModelList.CheckExitModular()
    local playId = ModelList.CityModel.GetPlayIdByCity()
    if playId then
        local playType = Csv.GetData("city_play", playId, "play_type")
        if playType ~= PLAY_TYPE.PLAY_TYPE_NORMAL and
            playType ~= PLAY_TYPE.PLAY_TYPE_AUTO_TICKET
        then
            ModelList.ClearModularModel()
        end
    end
end
