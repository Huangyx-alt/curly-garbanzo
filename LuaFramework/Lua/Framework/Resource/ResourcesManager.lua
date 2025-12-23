--[[
Descripttion:
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-07-01 18:36:21
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:47:04
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]
---@class ResourcesManager
local ResourcesManager = BaseClass("ResourcesManager", TGameSingleton)
local base = TGameSingleton
local this = ResourcesManager
local moduleLower = string.lower(BundleCategory.LPB.Module)
-- 引入LRU模块
local LRU = require("Common.LRU")

-- 弱表管理加载状态
local loadingMap = setmetatable({}, { __mode = "k" }) -- 弱键表，自动清理完成的任务

-- 创建LRU路径缓存（最大1000条）
---@type LRU
local pathCache = LRU.new(1000)

-- 预加载配置
local PreloadConfig = {
    highFrequencyPaths = {

    }
}

function ResourcesManager:__init()
    ---@type table assetId -> { path, category } 资源字典
    self.resourceMap = {}
    self.tempSceneList = {}
    self.yoohandleDict = setmetatable({}, { __mode = "v" })
    self.locationMapId = {}
    self.whitelist = {} -- 常驻资源白名单

    -- 启动时预加载高频路径
    for _, path in ipairs(PreloadConfig.highFrequencyPaths) do
        local resolvedPath = string.gsub(path, "%.", "/")
        pathCache:set(path, resolvedPath)
        print("[Preload] Cached path: " .. path .. " -> " .. resolvedPath)
    end

    collectgarbage("stop") -- 启动时暂停GC，避免高频回收[10](@ref)
end

--- 异步加载资源（三级缓存 + 路径安全转换）
---@param category string 资源类别
---@param filePath string 资源文件路径
---@param asset_type any 资源类型
---@param callback fun(assetId:number|nil, err:string|nil)
function ResourcesManager:LoadAssetAsync(category, filePath, asset_type, callback)
    local categoryLower = string.lower(category)
    local resolvedFile = (AssetList and AssetList[filePath]) or filePath

    -- 2. 检查已加载资源（使用局部变量加速遍历）
    local resourceMap = self.resourceMap
    for assetId, meta in pairs(resourceMap) do
        if meta.path == resolvedFile and meta.category == categoryLower then
            callback(assetId)
            return
        end
    end

    -- 3. 合并加载中请求
    local resourceKey = categoryLower .. ":" .. resolvedFile -- 唯一键：避免同名资源跨类别冲突
    if loadingMap[resourceKey] then
        table.insert(loadingMap[resourceKey].callbacks, callback)
        return
    end

    -- 4. 创建新加载任务
    loadingMap[resourceKey] = {
        callbacks = { callback },
        category = category,
        filePath = filePath,
        asset_type = asset_type,
        resolvedFile = resolvedFile,
        categoryLower = categoryLower,
        retryCount = 0, -- 重试计数器
    }

    -- 开始加载流程
    self:_DoLoadAssetAsync(loadingMap[resourceKey])
end

-- 实际的异步加载实现
function ResourcesManager:_DoLoadAssetAsync(task)
    local category = task.category
    local filePath = task.filePath
    local asset_type = task.asset_type
    local resolvedFile = task.resolvedFile
    local categoryLower = task.categoryLower
    local resourceKey = categoryLower .. ":" .. resolvedFile

    -- 使用LRU缓存获取路径
    local cachedPath = pathCache:get(resolvedFile)
    if not cachedPath then
        cachedPath = string.gsub(resolvedFile, "%.", "/")
        pathCache:set(resolvedFile, cachedPath)
    end

    -- 智能路径处理
    local fullPath
    if not string.find(cachedPath:lower(), "luaprefab") and not string.find(cachedPath:lower(), "modules") then
        fullPath = table.concat({ categoryLower, cachedPath }, "/")
    else
        fullPath = cachedPath
    end

    if category == BundleCategory.LPB.Sound then
        fullPath = string.gsub(fullPath, "_", "/")
    end

    -- 7. 智能附加扩展名（使用局部表加速访问）
    local extensionMap = {
        [BundleCategory.LPB.Prefabs] = ".prefab",
        [BundleCategory.LPB.Atlas] = ".spriteatlasv2",
        [BundleCategory.LPB.Textures] = task.retryCount == 0 and ".png" or ".jpg",
        [BundleCategory.LPB.Sound] = task.retryCount == 0 and ".ogg" or ".mp3",
        [BundleCategory.LPB.Material] = ".mat",
    }

    -- 根据重试次数选择扩展名
    local extension = extensionMap[category] or ".prefab"
    if task.retryCount > 0 then
        if category == BundleCategory.LPB.Textures then
            log.r(string.format("正在重试加载贴图: %s.%s", fullPath, extension))
        elseif category == BundleCategory.LPB.Sound then
            log.r(string.format("正在重试加载音效: %s.%s", fullPath, extension))
        end
    end

    -- 创建回调闭包
    local function onResourceLoaded(resultInfo)
        local success, mainData = resultInfo[0], resultInfo[1]
        local task = loadingMap[resourceKey]

        if task then
            if success then
                -- 更新资源管理
                self.resourceMap[mainData] = {
                    path = resolvedFile,
                    category = categoryLower
                }

                self.yoohandleDict[resolvedFile] = self:GetAssetHandle(mainData)
                self.locationMapId[resolvedFile] = {
                    location = "assets/bundles/" .. resolvedFile,
                    assetId = mainData
                }
                -- 成功加载
                for _, cb in ipairs(task.callbacks) do
                    cb(mainData)
                end
                loadingMap[resourceKey] = nil
            else
                -- 加载失败处理
                task.retryCount = task.retryCount + 1

                if category == BundleCategory.LPB.Textures and task.retryCount == 1 then
                    -- 贴图首次加载失败，尝试使用.jpg扩展名重试
                    log.r(string.format("贴图加载失败，尝试重试.jpg: %s", resolvedFile))
                    self:_DoLoadAssetAsync(task)
                elseif category == BundleCategory.LPB.Sound and task.retryCount == 1 then
                    log.r(string.format("音效加载失败，尝试重试.ogg: %s", resolvedFile))
                    self:_DoLoadAssetAsync(task)
                else
                    -- 重试失败或非贴图资源，调用回调通知失败
                    for _, cb in ipairs(task.callbacks) do
                        cb(nil, mainData or "Unknown error")
                    end

                    loadingMap[resourceKey] = nil
                end
            end
        end
    end

    -- 注册回调并开始加载
    local callbackId = CS.LuaHelper.RegisterCallback(onResourceLoaded)

    -- 调试日志（添加缓存命中信息）
    log.l(string.format("bang 异步加载资源| category: %s | resolvedFile: %s | cache: %s | callbackId: %d",
        category, resolvedFile, pathCache:get(resolvedFile) and "HIT" or "MISS", callbackId))

    CS.LuaHelper.LoadAssetAsync(fullPath, extension, asset_type, callbackId)
end

--- 同步加载资源（失败重试机制）
---@param category string 资源类别
---@param filePath string 资源文件路径
---@param asset_type any 资源类型
---@return any|nil 返回资源对象（UnityEngine.Object）
function ResourcesManager:LoadAssetSync(category, filePath, asset_type)
    local categoryLower = string.lower(category)
    local resolvedFile = (AssetList and AssetList[filePath]) or filePath

    -- 检查已加载资源（避免重复加载）
    for assetId, meta in pairs(self.resourceMap) do
        if meta.path == resolvedFile and meta.category == categoryLower then
            return self:GetAssetObject(assetId)
        end
    end

    -- 重试配置参数
    local MAX_RETRIES = 1 -- 最大重试次数（仅贴图和音效有效）
    local retryCount = 0
    local lastError = nil

    -- 加载循环（主尝试+重试）
    while retryCount <= MAX_RETRIES do
        -- 获取LRU缓存路径
        local cachedPath = pathCache:get(resolvedFile) or string.gsub(resolvedFile, "%.", "/")
        pathCache:set(resolvedFile, cachedPath)

        -- 构造完整路径
        local fullPath = cachedPath
        if not string.find(cachedPath:lower(), "luaprefab") and
            not string.find(cachedPath:lower(), "modules") then
            fullPath = table.concat({ categoryLower, cachedPath }, "/")
        end

        if category == BundleCategory.LPB.Sound then
            fullPath = string.gsub(fullPath, "_", "/")
        end

        -- 动态扩展名策略
        local extensionMap = {
            [BundleCategory.LPB.Prefabs] = ".prefab",
            [BundleCategory.LPB.Atlas] = ".spriteatlasv2",
            [BundleCategory.LPB.Textures] = retryCount == 0 and ".png" or ".jpg",
            [BundleCategory.LPB.Sound] = retryCount == 0 and ".ogg" or ".mp3",
        }
        local extension = extensionMap[category] or ".prefab"

        fullPath = string.gsub(fullPath, "%.", "/")
        
        -- 执行同步加载
        local success, assethandle = pcall(CS.LuaHelper.LoadAssetSync, fullPath, extension, asset_type)

        -- 加载成功处理
        if success and assethandle then
            local assetId = CS.LuaHelper.GetNextAssetId()
            self.resourceMap[assetId] = {
                path = resolvedFile,
                category = categoryLower
            }
            self.yoohandleDict[resolvedFile] = CS.LuaHelper.GetAssetHandle(assetId)
            self.locationMapId[resolvedFile] = {
                location = "assets/bundles/" .. resolvedFile,
                assetId = assetId
            }
            return assethandle.AssetObject
        end

        -- 错误处理与重试决策
        lastError = tostring(assethandle or "Unknown error")
        retryCount = retryCount + 1

        -- 打印重试日志（仅针对支持重试的类型）
        if retryCount <= MAX_RETRIES then
            if category == BundleCategory.LPB.Textures then
                log.r(string.format("[Retry] 贴图加载失败(%s), 重试扩展名.jpg: %s", lastError, resolvedFile))
            elseif category == BundleCategory.LPB.Sound then
                log.r(string.format("[Retry] 音效加载失败(%s), 重试扩展名.ogg: %s", lastError, resolvedFile))
            else
                break -- 非支持类型立即退出循环
            end
        end
    end
    log.e(string.format("同步加载失败[%s]: %s/%s (重试%d次)",
        lastError, category, resolvedFile, retryCount - 1))
    -- 最终失败处理
    return nil
end

--- 异步加载场景（优化回调处理）
---@param scenePath string 场景路径
---@param callback fun(assetId:CS.SceneHandle|nil, err:string|nil) 回调函数
---@param activateOnLoad? boolean 是否在加载后激活场景
---@param mode? CS.LoadSceneMode 场景加载模式
function ResourcesManager:LoadSceneAsync(scenePath, callback, activateOnLoad, mode)
    activateOnLoad = activateOnLoad == nil and true or activateOnLoad
    mode = mode or CS.LoadSceneMode.Single
    local resolvedFile = (AssetList and AssetList[scenePath]) or scenePath
    local function onSceneLoaded(resultInfo)
        local success, mainData = resultInfo[0], resultInfo[1]

        if success then
            if callback ~= nil then callback(mainData) end
            table.insert(self.tempSceneList, mainData)
            --场景加载完毕,设置这个全局节点
            -- if fun.is_null(SceneViewManager.page_layer) then
            --     SceneViewManager.page_layer = UnityEngine.GameObject.FindWithTag("NormalUiRoot")
            -- end
        else
            local errMsg = resultInfo[1] or "Unknown error"
            print("[ERROR] Scene load failed: " .. resolvedFile .. " | " .. errMsg)
            if callback ~= nil then callback(nil, errMsg) end
        end
    end

    local callbackId = CS.LuaHelper.RegisterCallback(onSceneLoaded)
    self:Cleanup()
    local directoryFileName = string.gsub(resolvedFile, "%.", "/")

    log.l(string.format("bang 异步加载场景| directoryFileName: %s | scenePath: %s | callbackId: %d", directoryFileName,
        scenePath, callbackId))

    CS.LuaHelper.LoadScene(directoryFileName, callbackId, activateOnLoad, mode)
end

--- 获取资源对象（添加类型安全检查
---@param assetId number 资源ID
---@return any|nil 返回资源对象或nil
function ResourcesManager:GetAssetObject(assetId)
    if not assetId then
        print("[ERROR] Invalid assetId: nil")
        return nil
    end

    local meta = self.resourceMap[assetId]
    if not meta then
        print("[ERROR] Asset not loaded: " .. tostring(assetId))
        return nil
    end

    if meta.type == CS.AssetType.Scene then
        local obj = assetId.SceneObject
        return obj or nil
    else
        local obj = CS.LuaHelper.GetAssetObject(assetId)
        return obj or nil
    end
end

--- 添加资源到白名单（添加存在性检查）
---@param assetId string 资源ID
function ResourcesManager:AddToWhitelist(assetId)
    if self.resourceMap[assetId] then
        self.whitelist[assetId] = true
    else
        print("[WARN] Cannot whitelist unloaded asset: " .. tostring(assetId))
    end
end

--- 从白名单移除
---@param assetId number
function ResourcesManager:RemoveFromWhitelist(assetId)
    self.whitelist[assetId] = nil
end

--- 获取资源句柄
---@param assetId number|nil
---@return any|nil
function ResourcesManager:GetAssetHandle(assetId)
    return CS.LuaHelper.GetAssetHandle(assetId)
end

--获取yooasset assethandle
---@param fileName string 资源文件名
function ResourcesManager:GetYoohandle(fileName)
    if table.keyof(self.yoohandleDict, fileName) then
        return self.yoohandleDict[fileName]
    else
        log.e("获取不到yoohandle fileName")
    end
end

---@param fPtah string  assetList配置的文件名(AssetList)
---@param isDestroyMemory? boolean 是否从内存中删除,并删除依赖资源
function ResourcesManager:UnloadAsset(fPtah, isDestroyMemory)
    if not fPtah then return end
    fPtah = string.gsub(fPtah, "_", "/")
    fPtah = AssetList[fPtah] or fPtah

    local tb = self.locationMapId[fPtah]
    if tb ~= nil then
        log.w("UnloadAsset fPtah: " .. fPtah)
        local assetId = tb.assetId
        local location = tb.location
        if self.resourceMap[assetId] then
            CS.LuaHelper.ReleaseAsset(assetId)
            self.resourceMap[assetId] = nil
        end
        if isDestroyMemory then
            CS.GFX_Asset:UnloadAsset(location)
        end
    end
end

--- 释放资源（添加增量GC控制）
---@param assetId string 资源ID
function ResourcesManager:ReleaseAsset(assetId)
    if not assetId then return end
    if self.whitelist[assetId] then return end

    if self.resourceMap[assetId] then
        CS.LuaHelper.ReleaseAsset(assetId)
        self.resourceMap[assetId] = nil
        collectgarbage("step", 1024) -- 增量回收避免卡顿
    end
end

function ResourcesManager:_releaseScenehandle()
    if next(self.tempSceneList) ~= nil then
        for _, tempScenehandle in ipairs(self.tempSceneList) do
            if tempScenehandle then
                local location = tempScenehandle:GetAssetInfo().AssetPath
                CS.GFX_Asset:UnloadAsset(location)
            end
        end
    end
    self.tempSceneList = {}
end

--- 场景切换时资源清理（添加资源计数）
function ResourcesManager:Cleanup()
    local count = 0
    for assetId, _ in pairs(self.resourceMap) do
        if not self.whitelist[assetId] then
            CS.LuaHelper.ReleaseAsset(assetId)
            count = count + 1
            -- log.e(string.format("场景切换时资源清理 path: %s ", _.path))
        end
    end
    AtlasManager:ClearAll()
    self:_releaseScenehandle()
    self.resourceMap = {}
    self.yoohandleDict = {}
    self.locationMapId = {}
    if collectgarbage("count") < 100 * 1024 then -- <100MB不触发全量GC
        return
    end
    collectgarbage("collect") --TODO lpb旧的系统 场景切换主动做了GC,时机和bang写法不一致
    log.w(string.format("Cleanup released %d resources", count))
end

--- 动态调整缓存大小
---@param newSize number 新的缓存大小
function ResourcesManager:AdjustCacheSize(newSize)
    -- pathCache.capacity = newSize
    pathCache:setCapacity(newSize)
    print("LRU cache capacity set to: " .. newSize)
end

--- 销毁资源管理器（强化清理）
function ResourcesManager:OnDestroy()
    for assetId, _ in pairs(self.resourceMap) do
        CS.LuaHelper.ReleaseAsset(assetId)
    end
    self:_releaseScenehandle()
    -- 清理缓存统计
    self.resourceMap = {}
    self.whitelist = {}
    self.yoohandleDict = {}
    self.locationMapId = {}
    -- 重置LRU缓存
    pathCache:clear()

    -- collectgarbage("collect")
end

return ResourcesManager
