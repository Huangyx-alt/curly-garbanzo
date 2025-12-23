--[[
Descripttion: C# call lua的方法在这里定义，然后再调用回具体lua的方法
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-08-26 14:57:27
LastEditors: LwangZg
LastEditTime: 2025-08-26 14:58:14
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]
local FuncDefines = {}

function FuncDefines.OnProgressUpdate(progress, currentSizeMb, totalSizeMb)
    Event.Brocast(EventName.CS_ModuleDownloaderProgressUpdateEvent, progress, currentSizeMb, totalSizeMb);
    log.g("监听下载模块的进度 " .. progress .. "currentSizeMb " .. currentSizeMb .. "totalSizeMb " .. totalSizeMb)
    --LuaHelper.DownloadModule(go, "1001") --先监听再请求
end

return FuncDefines
