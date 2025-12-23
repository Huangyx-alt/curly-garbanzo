--[[
-- added by LwangZg @ 2025-6-10
-- 1、加载全局模块，所有全局性的东西都在这里加载，好集中管理
-- 2、模块定义时一律用local再return，模块是否是全局模块由本脚本决定，在本脚本加载的一律为全局模块
-- 3、对必要模块执行初始化
-- 注意：
-- 1、全局的模块和被全局模块持有的引用无法GC，除非显式设置为nil
-- 2、除了单例类、通用的工具类、逻辑上的静态类以外，所有逻辑模块不要暴露到全局命名空间
-- 3、这里的全局模块是相对与游戏框架或者逻辑而言，lua语言层次的全局模块放Common.Main中导出
参考 xlua-framework wsh @ 2017-11-30
-- 重点用途：
-- 1、lpb 和 royal lua业务引擎入口和开关
-- 2、作为框架级别的根管理节点
--]]

-- 加载全局模块
require "Common.functions"
-- require "Common.define"     -- by LwangZg LivePartyBingoEntry 注册了
require "Common.baseClass"
require "Global.CSWrap"
require "Global.DefineEnum"
require "Global.CommandSystem"
require "Net.ProtobufEnum" -- 示例 ProtobufEnum["PAY_CHANNEL"]["PAY_CHANNEL_GOOGLE_PLAY"]

-- 创建全局模块
GlobalConfig   = require "Global.Config"
TGameSingleton = require "Common.singleton"
MsgIDDefine    = require "Net.config.MsgIDDefine"
FuncDefines    = require "Global.FuncDefines"


-- res
---@type ResourcesManager
ResourcesManager = (require "Framework.Resource.ResourcesManager"):GetInstance()
---@type AtlasManager
AtlasManager = (require "Framework.Resource.AtlasManager"):GetInstance()


print("创建全局模块")
