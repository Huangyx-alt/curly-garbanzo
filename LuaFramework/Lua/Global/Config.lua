--[[
Descripttion: Lua全局配置
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-06-17 11:03:44
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:47:52
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

local Config = Config or {}

-- 将枚举定义为独立模块，便于外部访问
Config.LoaderType = {
    LPB = 1,
    BingoBang = 2,
    Blend = 3,
    
    -- 添加元方法防止外部修改枚举值
    __newindex = function()
        error("LoaderType enum is read-only")
    end
}

-- 设置枚举的元表保护
setmetatable(Config.LoaderType, {
    __index = function(_, key)
        error("Invalid LoaderType: " .. tostring(key))
    end
})

-- 调试模式：真机出包时关闭
Config.Debug = true
-- AssetBundle
Config.UseAssetBundle = false

-- 使用枚举值进行开关判断
Config.LoaderTypeSwitch = Config.LoaderType.Blend

return Config