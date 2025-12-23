--[[
Descripttion:
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-07-29 20:06:57
LastEditors: LwangZg
LastEditTime: 2025-08-07 18:46:15
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]
--[[
Descripttion:主入口函数。从这里开始lua逻辑,使用Global作为lpb和bang的业务分流
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-06-17 11:03:44
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:49:10
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

require "Global.Global"
local UnitTestMain = require "UnitTest.UnitTestMain"
local LogicEntry   = require "Logic.LogicEntry"
local testOpen     = false
function Main()
    GlobalConfig.UseAssetBundle = (CS.GFX_Asset.GamePlayMode == YooAsset.EPlayMode.OfflinePlayMode) or
        (CS.GFX_Asset.GamePlayMode == YooAsset.EPlayMode.HostPlayMode)
    GlobalConfig.Debug = CS.GFX_Asset.GamePlayMode == YooAsset.EPlayMode.EditorSimulateMode
    if testOpen then
        UnitTestMain.Run()
        -- require "Logic.Game"
        -- Game.OnInitOK()
        return
    end

    ---@type LogicEntry 逻辑入口开关
    local logicEntryIns = LogicEntry.New()
    logicEntryIns:BingoBangRun()
    logicEntryIns:LivePartyBingoRun()
    logicEntryIns:GlobalRedirect()

    print("logic start")

    -- logicEntryIns:NetworkStart()
end

function Unload()
    print(" 退出游戏 ")
    AtlasManager:Delete()
    ResourcesManager:Delete()
end
