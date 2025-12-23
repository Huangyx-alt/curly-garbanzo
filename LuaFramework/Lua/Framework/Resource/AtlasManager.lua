--[[
Descripttion:图集管理器
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-07-07 14:52:11
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:58:07
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@class AtlasManager
local AtlasManager = BaseClass("AtlasManager", TGameSingleton)
---@type ResourcesManager
local resSys = ResourcesManager

-- 初始化缓存表
function AtlasManager:__init()
    self.__cache = {}  -- { [atlas_path] = { handle = AssetHandle, refCount = number, assetid = number } }
    self.__refMap = {} -- { [atlas_path] = { [view_ab_name] = true } } 用于记录图集被哪些视图引用
end

-- 从缓存中获取图集资源
---@param atlas_path string
---@return table|nil
function AtlasManager:__getCacheItem(atlas_path)
    return self.__cache[atlas_path]
end

-- 增加引用计数
---@param atlas_path string
function AtlasManager:__retainCacheItem(atlas_path)
    local item = self:__getCacheItem(atlas_path)
    if item then
        item.refCount = item.refCount + 1
    end
end

-- 减少引用计数
---@param atlas_path string
function AtlasManager:__releaseCacheItem(atlas_path)
    local item = self:__getCacheItem(atlas_path)
    if item then
        item.refCount = item.refCount - 1
        if item.refCount <= 0 then
            self.__cache[atlas_path] = nil
            resSys:ReleaseAsset(item.assetid) -- 释放资源
        end
    end
end

-- 记录图集被视图引用
---@param atlas_path string
---@param view_name string|nil
function AtlasManager:AddReference(atlas_path, view_name)
    if view_name == nil then
        return -- 如果视图名为空，则不记录引用
    end
    local completed_atlas_path = AssetList[atlas_path] or atlas_path
    if not self.__refMap[completed_atlas_path] then
        self.__refMap[completed_atlas_path] = {}
    end
    if self.__refMap[completed_atlas_path][view_name] == nil then
        self.__refMap[completed_atlas_path][view_name] = {}
    end
    self.__refMap[completed_atlas_path][view_name] = true
end

-- 移除视图对图集的引用
---@param atlas_path string
---@param view_name string
function AtlasManager:RemoveReference(atlas_path, view_name)
    local completed_atlas_path = AssetList[atlas_path] or atlas_path
    if self.__refMap[completed_atlas_path] then
        self.__refMap[completed_atlas_path][view_name] = nil
        if not next(self.__refMap[completed_atlas_path]) then -- 无引用时
            self:__releaseCacheItem(completed_atlas_path)     -- 释放图集
            self.__refMap[completed_atlas_path] = nil
        end
    end
end

-- 释放视图引用的所有图集
---@param view_ab_name string
function AtlasManager:ReleaseViewReferences(view_ab_name)
    for atlas_path, refs in pairs(self.__refMap) do
        if refs[view_ab_name] then
            self:RemoveReference(atlas_path, view_ab_name)
        end
    end
end

-- 批量加载多个图集（支持主图集+副图集
---@param atlas_names table 图集名称列表
---@param view_ab_name string|nil 引用图集的视图资源名
---@param callback fun(success:boolean) 全部加载完成回调
function AtlasManager:LoadAtlasesAsync(atlas_names, view_ab_name, callback)
    local atlas_paths = {}
    for _, atlas_name in ipairs(atlas_names) do
        table.insert(atlas_paths, AssetList[atlas_name] or atlas_name)
    end
    local pendingCount = table.length(atlas_paths)
    local success = true

    for _, atlas_path in ipairs(atlas_paths) do
        self:AddReference(atlas_path, view_ab_name) -- 记录引用关系

        -- 检查缓存是否存在
        local cacheItem = self:__getCacheItem(atlas_path)
        if cacheItem then
            self:__retainCacheItem(atlas_path) -- 增加计数
            pendingCount = pendingCount - 1
            if pendingCount == 0 then
                callback(true)
            end
        else
            -- 新建缓存项
            self.__cache[atlas_path] = {
                handle = nil,
                refCount = 0,
                assetid = 0,
            }

            -- 异步加载资源
            resSys:LoadAssetAsync(
                BundleCategory.LPB.Atlas,
                atlas_path,
                typeof(CS.SpriteAtlas),
                function(assetId, err)
                    if assetId > 0 then
                        local handle = resSys:GetAssetHandle(assetId)
                        local cacheItem = self:__getCacheItem(atlas_path)
                        if cacheItem then
                            cacheItem.handle = handle
                            cacheItem.refCount = 1 -- 初始引用计数为1
                            cacheItem.assetid = assetId
                        end
                    else
                        success = false
                    end

                    pendingCount = pendingCount - 1
                    if pendingCount == 0 then
                        callback(success)
                    end
                end
            )
        end
    end
end

-- 从图集异步加载图片（带缓存优化）
---@param atlas_name string 图集名称
---@param image_name string|nil 图片名称
---@param callback fun(atlals:CS.SpriteAtlas|nil,sprite:CS.Sprite|nil,err:string|nil)|nil 回调函数
---@return void
function AtlasManager:LoadImageAsync(atlas_name, image_name, callback)
    local atlas_path = AssetList[atlas_name] or atlas_name
    -- 检查缓存是否存在
    local cacheItem = self:__getCacheItem(atlas_path)

    if cacheItem then
        local sprite = nil
        -- if cacheItem.handle == nil then
        --     self:__retainCacheItem(atlas_path)
        --     return
        if cacheItem.handle and cacheItem.handle.AssetObject then
            local spriteAtals = cacheItem.handle.AssetObject
            if not IsNull(spriteAtals) then
                if image_name ~= nil then
                    sprite = spriteAtals:GetSprite(image_name)
                end
                self:__retainCacheItem(atlas_path)
                if callback then
                    callback(spriteAtals, sprite, nil)
                end
                return
            end
        end
    end

    -- 新建缓存项
    self.__cache[atlas_path] = {
        handle = nil,
        refCount = 0,
        assetid = 0,
    }

    -- 异步加载资源
    resSys:LoadAssetAsync(
        BundleCategory.LPB.Atlas,
        atlas_path,
        typeof(CS.SpriteAtlas),
        function(assetId, err)
            if assetId ~= nil and assetId > 0 then
                local handle = resSys:GetAssetHandle(assetId)
                local cacheItem = self:__getCacheItem(atlas_path)

                if cacheItem then
                    cacheItem.handle = handle
                    cacheItem.refCount = 1
                    cacheItem.assetid = assetId
                    local spriteAtals = resSys:GetAssetObject(assetId)
                    if spriteAtals ~= nil then
                        if callback then
                            callback(spriteAtals, spriteAtals:GetSprite(image_name))
                        end
                    else
                        if callback then
                            callback(spriteAtals, nil, err or "加载失败")
                        end
                    end
                end
            else
                if callback then
                    callback(nil, nil, err or "加载失败")
                end
            end
        end
    )
end

---@param atlas_name string 图集名称
---@param image_name string 赋值的图片名称
---@return CS.Sprite|nil 返回一个Unity类型对象
function AtlasManager:GetSpriteByName(atlas_name, image_name)
    local atlas_path = AssetList[atlas_name] or atlas_name
    -- 检查缓存是否存在
    local cacheItem = self:__getCacheItem(atlas_path)

    -- 已缓存
    if cacheItem and cacheItem.handle and cacheItem.handle.AssetObject then
        local sprite = nil
        local spriteAtals = cacheItem.handle.AssetObject
        if image_name ~= nil and not IsNull(spriteAtals) then
            sprite = spriteAtals:GetSprite(image_name)
        end
        self:__retainCacheItem(atlas_path)
        if IsNull(sprite) then
            log.e("同步 从缓存中获取图片失败了 atlas_name " .. atlas_name .. " image_name " .. image_name .. "请确认是否勾选了SpriteAtlas打包选项")
        end
        return sprite
    end

    -- 异步加载资源
    local atalsObj = resSys:LoadAssetSync(
        BundleCategory.LPB.Atlas,
        atlas_path,
        typeof(CS.SpriteAtlas)
    )
    if not IsNull(atalsObj) then
        local curAssetid = CS.LuaHelper.GetNextAssetId()
        -- 更新缓存项
        self.__cache[atlas_path] = {
            handle = resSys:GetAssetHandle(curAssetid),
            refCount = 1,
            assetid = curAssetid,
        }
        if atalsObj ~= nil then
            if IsNull(atalsObj:GetSprite(image_name)) then
                log.e("同步 请求获取图片失败了 atlas_name " .. atlas_name .. " image_name " .. image_name ..
                    "请确认是否勾选了SpriteAtlas打包选项")
            end
            return atalsObj:GetSprite(image_name)
        end
    else
        log.e("同步 没有图集 图片失败了 atlas_name: " .. atlas_name .. " image_name: " .. image_name)
        return nil
    end
end

-- 释放图集资源
---@param atlas_name string
function AtlasManager:ReleaseImage(atlas_name)
    local atlas_path = atlas_name
    self:__releaseCacheItem(atlas_path)
end

-- 强制释放所有图集资源
function AtlasManager:ClearAll()
    for _, item in pairs(self.__cache) do
        resSys:ReleaseAsset(item.assetid) -- 释放资源
        item.handle = nil
        item.refCount = 0
        item.assetid = 0
    end
    self.__cache = {}
end

function AtlasManager:OnDestroy()
    self:ClearAll()
end

----------------------------- 新增接口 -----------------------------

----------------------------- 新增接口 -----------------------------

return AtlasManager
