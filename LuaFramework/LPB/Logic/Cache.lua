-- require "Logic.MachinePortalManager" by LwwangZg 没用到就别用了

Cache = {}
Cache.ab_dic = {}


function Cache.init()
    Cache.ab_dic = {}
end

--lpb时期接口
-- function Cache.Load_Atlas_lpb(assetbundle_name, atlas_name, callback, isSync, view_ab_name, second_atlas_name)
--     if atlas_name == nil then
--         if callback then
--             callback(nil)
--         end
--         --log.r("参数错误,atlas_name不能为nil")
--         return
--     end
--     local contxt = string.format("assetbundle_name: %s ,atlas_name: %s view_ab_name: %s second_atlas_name: %s",
--         assetbundle_name, atlas_name, view_ab_name, second_atlas_name)
--     log.r(contxt)
--     local ab_name = assetbundle_name or AssetList[atlas_name] or atlas_name
--     if ab_name ~= nil then
--         local atlas = Cache.find_prefab(ab_name, atlas_name)
--         if atlas == nil then
--             --图集不用传ab名
--             if isSync == nil then isSync = false end
--             resMgr:LoadAtlas(nil, atlas_name, function(objs)
--                 atlas = objs[0]
--                 local cacheList = {}
--                 cacheList[atlas_name] = atlas
--                 Cache.add_to_cache_dic(ab_name, cacheList)
--                 Cache.add_atlas_reference_to_cache_dic(atlas_name, view_ab_name)
--                 if second_atlas_name then
--                     Cache.add_atlas_reference_to_cache_dic(second_atlas_name, view_ab_name)
--                 end
--                 if callback then
--                     callback(atlas)
--                 end
--             end, nil, isSync)
--         else
--             Cache.add_atlas_reference_to_cache_dic(atlas_name, view_ab_name)
--             if second_atlas_name then
--                 Cache.add_atlas_reference_to_cache_dic(second_atlas_name, view_ab_name)
--             end
--             if callback then
--                 callback(atlas)
--             end
--         end
--     else
--         if callback then
--             callback(nil)
--         end
--         if #atlas_name > 0 then
--             log.r("没有这样的资源：" .. atlas_name)
--         end
--     end
-- end

-- 重构后的 Cache.Load_Atlas（使用 AtlasManager）
function Cache.Load_Atlas(assetbundle_name, atlas_name, callback, isSync, view_ab_name, second_atlas_name)
    if atlas_name == nil or atlas_name == "" or assetbundle_name == nil then
        if callback then callback(nil) end
        return
    end

    local ab_name = assetbundle_name or AssetList[atlas_name] or atlas_name

    -- 记录调试信息
    -- local contxt = string.format("assetbundle_name: %s, atlas_name: %s, view_ab_name: %s, second_atlas_name: %s",
    --     assetbundle_name, atlas_name, view_ab_name, second_atlas_name)
    -- log.r(contxt)

    -- 构建图集列表（主图集+副图集）
    local atlasList = { ab_name }
    if second_atlas_name then
        table.insert(atlasList, AssetList[second_atlas_name])
    end
    local ab_name = assetbundle_name or AssetList[atlas_name] or atlas_name
    if ab_name ~= nil then
        local atlas = Cache.find_prefab(ab_name, atlas_name)
        if atlas == nil then
            -- 使用 AtlasManager 批量加载图集
            AtlasManager:LoadAtlasesAsync(
                atlasList,
                view_ab_name, 
                function(success)
                    if not success then
                        log.e("图集加载失败: " .. table.concat(atlasList, ","))
                        if callback then callback(nil) end
                        return
                    end
                    -- 获取主图集对象
                    AtlasManager:LoadImageAsync(atlas_name, nil, function(spriteAtlas, _, err)
                        if err then
                            log.e("获取图集失败: " .. atlas_name .. ", 错误: " .. err)
                            if callback then callback(nil) end
                            return
                        end

                        -- 记录引用关系
                        for _, atlas in ipairs(atlasList) do
                            AtlasManager:AddReference(atlas, view_ab_name)
                        end

                        if callback then
                            callback(spriteAtlas)

                            local cacheList = {}
                            cacheList[atlas_name] = spriteAtlas
                            Cache.add_to_cache_dic(ab_name, cacheList)
                            Cache.add_atlas_reference_to_cache_dic(atlas_name, view_ab_name)
                            if second_atlas_name then
                                Cache.add_atlas_reference_to_cache_dic(second_atlas_name, view_ab_name)
                            end
                        end
                    end)
                end)
        else
            Cache.add_atlas_reference_to_cache_dic(atlas_name, view_ab_name)
            if second_atlas_name then
                Cache.add_atlas_reference_to_cache_dic(second_atlas_name, view_ab_name)
            end
            if callback then
                callback(atlas)
            end
        end
    else
        if callback then
            callback(nil)
        end
        if #atlas_name > 0 then
            log.r("没有这样的资源：" .. atlas_name)
        end
    end
end

----lpb时期接口 预加载预置体
-- function Cache.load_prefabs_lpb(assetbundle_name, prefab_names, callback, isSync)
--     if prefab_names == nil then
--         log.r("参数错误,prefab_names不能为nil")
--         return
--     end
--     local ab_name = assetbundle_name or AssetList[prefab_names]
--     if ab_name ~= nil then
--         --log.r(" Cache.load_prefabs   "..ab_name)
--         local prefab = Cache.find_prefab(ab_name, prefab_names)
--         if prefab == nil then
--             if isSync == nil then isSync = false end
--             resMgr:LoadPrefab(ab_name, { prefab_names }, function(objs)
--                 prefab = objs[0]
--                 local cacheList = {}
--                 cacheList[prefab_names] = prefab
--                 Cache.add_to_cache_dic(ab_name, cacheList)
--                 if callback then
--                     callback(prefab)
--                 end
--             end, isSync)
--         else
--             if callback then
--                 callback(prefab)
--             end
--         end
--     else
--         if callback then
--             callback(nil)
--         end
--         log.r("没有这样的资源：" .. prefab_names)
--     end
-- end

-- 重构后的 Cache.load_prefabs（使用 ResourcesManager）
function Cache.load_prefabs(assetbundle_name, prefab_names, callback, isSync)
    if prefab_names == nil then
        log.r("参数错误,prefab_names不能为nil")
        return
    end
    local ab_name = assetbundle_name or AssetList[prefab_names]
    if ab_name ~= nil then
        local prefab = Cache.find_prefab(ab_name, prefab_names)
        if prefab == nil then
            -- 使用 ResourcesManager 异步加载预制体
            ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Prefabs, prefab_names, typeof(CS.GameObject),
                function(assetId, err)
                    if err or not assetId then
                        log.e("预制体加载失败: " .. prefab_names .. ", AB: " .. ab_name)
                        if callback then callback(nil) end
                        return
                    end

                    local prefabObj = ResourcesManager:GetAssetObject(assetId)
                    if not prefabObj then
                        log.e("获取预制体对象失败: " .. prefab_names)
                        if callback then callback(nil) end
                        return
                    end

                    -- 缓存资源
                    local cacheList = {}
                    cacheList[prefab_names] = prefabObj
                    Cache.add_to_cache_dic(ab_name, cacheList)
                    if callback then callback(prefabObj) end
                end)
        else
            if callback then callback(prefab) end
        end
    else
        if callback then callback(nil) end
        log.r("没有这样的资源：" .. prefab_names)
    end
end

function Cache.load_texture(assetbundle_name, texture_names, callback)
    if texture_names == nil then
        log.r("参数错误,texture_names不能为nil")
        return
    end
    local ab_name = assetbundle_name or AssetList[texture_names]
    if ab_name ~= nil then
        local texture = Cache.find_prefab(ab_name, texture_names)
        if texture == nil then
            ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Textures, ab_name,
                typeof(CS.Texture2D), --Assets/Bundles/LuaPrefab/Textures/Anniversary/AnniversaryBuff1.png
                function(assetId, err)
                    if err or not assetId then
                        log.e("加载Sprite失败: " .. ab_name .. ", 错误: " .. err)
                        if callback then callback(nil) end
                        return
                    end

                    local textures = ResourcesManager:GetAssetObject(assetId)
                    if not textures then
                        log.e("获取textures对象失败: " .. sprite_names)
                        if callback then callback(nil) end
                        return
                    end

                    -- 缓存资源
                    local cacheList = {}
                    cacheList[texture_names] = textures
                    Cache.add_to_cache_dic(ab_name, cacheList)
                    if callback then
                        callback(textures)
                    end
                end)
        else
            if callback then
                callback(texture)
            end
        end
    else
        if callback then
            callback(nil)
        end
        log.r("没有这样的资源：" .. texture_names)
    end
end

function Cache.load_sprite(assetbundle_name, sprite_names, callback)
    if sprite_names == nil then
        log.r("参数错误,sprite_names不能为nil")
        return
    end
    local ab_name = assetbundle_name or AssetList[sprite_names]
    if ab_name ~= nil then
        local sprite = Cache.find_prefab(ab_name, sprite_names)
        if sprite == nil then
            ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Textures, ab_name,
                typeof(CS.Texture2D), --Assets/Bundles/LuaPrefab/Textures/Anniversary/AnniversaryBuff1.png
                function(assetId, err)
                    if err or not assetId then
                        log.e("加载Sprite失败: " .. ab_name .. ", 错误: " .. err)
                        if callback then callback(nil) end
                        return
                    end

                    local textures = ResourcesManager:GetAssetObject(assetId)
                    if not textures then
                        log.e("获取textures对象失败: " .. sprite_names)
                        if callback then callback(nil) end
                        return
                    end

                    -- 缓存资源
                    local cacheList = {}
                    sprite = Util.Texture2Sprite(textures)
                    cacheList[sprite_names] = sprite
                    Cache.add_to_cache_dic(ab_name, cacheList)
                    if callback then
                        callback(sprite)
                    end
                end)
        else
            if callback then
                callback(sprite)
            end
        end
    else
        if callback then
            callback(nil)
        end
        log.r("没有这样的资源：" .. sprite_names)
    end
end

function Cache.GetSpriteByName(atlas_name, sprite_name, callback)
    if atlas_name == nil or sprite_name == nil or sprite_name == "0" then
        log.r("参数错误,atlas_name,sprite_name不能为nil")
        return
    end
    --图集不用传ab名了，所以直接传图集名
    local ab_name = AssetList[atlas_name] or atlas_name
    if ab_name ~= nil then
        --log.r("GetSpriteByName   "..ab_name)
        Cache.Load_Atlas(ab_name, atlas_name, function(obj)
            if callback then
                if obj then
                    callback(obj:GetSprite(sprite_name))
                else
                    callback(nil)
                end
            end
        end)
    end
end

function Cache.SetImageSprite(atlas_name, sprite_name, image, resize)
    Cache.GetSpriteByName(atlas_name, sprite_name, function(img)
        if img and image then
            image.sprite = img
            if resize then
                image:SetNativeSize()
            end
        end
    end)
end

--不同预制体的加载方式
function Cache.load_view_prefab(assetbundle_name, view_name, atlas_name, callback, second_atlas_name)
    if view_name == nil then
        log.r("参数错误,view_name不能为nil")
        return
    end
    local ab_name = assetbundle_name or AssetList[view_name]
    if ab_name ~= nil then
        local fun = function()
            local viewPrefab = Cache.find_prefab(ab_name, view_name)
            if viewPrefab == nil then
                ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Prefabs, ab_name, typeof(CS.GameObject),
                    function(assetId, err)
                        if err or not assetId then
                            log.e("加载预制体失败: " .. view_name .. ", 错误: " .. err)
                            if callback then callback(nil) end
                            return
                        end
                        local prefabObj = ResourcesManager:GetAssetObject(assetId)
                        if not prefabObj then
                            log.e("获取预制体对象失败: " .. prefab_names)
                            if callback then callback(nil) end
                            return
                        end
                        viewPrefab = prefabObj
                        -- 缓存资源
                        local cacheList = {}
                        cacheList[view_name] = viewPrefab
                        Cache.add_to_cache_dic(ab_name, cacheList)
                        if callback then
                            callback(view_name, viewPrefab)
                        end
                    end)
            else
                if callback then
                    callback(view_name, viewPrefab)
                end
            end
        end
        Cache.Load_Atlas(nil, atlas_name, function(obj)
            fun()
        end, nil, ab_name, second_atlas_name)
    else
        if callback then
            callback(view_name, nil)
        end
        log.r("没有这样的资源：" .. view_name)
    end
end

function Cache.add_to_cache_dic(ab_name, prefab_dic)
    if (not Cache.ab_dic[ab_name]) or (not Cache.ab_dic[ab_name].prefab_dic) then
        Cache.ab_dic[ab_name] = { prefab_dic = prefab_dic }
    else
        fun.merge_array(Cache.ab_dic[ab_name].prefab_dic, prefab_dic)
    end
end

function Cache.find_prefab(assetbundle_name, prefab_name)
    local ab = Cache.ab_dic[assetbundle_name]
    if ab and ab.prefab_dic and not fun.is_null(ab.prefab_dic[prefab_name]) then
        return ab.prefab_dic[prefab_name]
    end
    return nil
end

-- 创建实例
function Cache.create(assetbundle_name, prefab_name)
    -- log.r("Cache.create",assetbundle_name,prefab_name)
    local prefab = Cache.find_prefab(assetbundle_name, prefab_name)
    if prefab == nil then
        log.r("预制体" .. tostring(prefab_name) .. "未加载!")
        return nil
    end
    return fun.get_instance(prefab)
end

function Cache.IsWhitelistAb(ab)
    if (Cache.ABWhitelist == nil) then
        Cache.ABWhitelist = fun.merge_array(AssetList.M19999)
    end
    for k, v in pairs(Cache.ABWhitelist) do
        if (v == ab) then
            return true
        end
    end
    return false
end

--清理assertbundle及相关所有assert,及实例
function Cache.unload_ab(ab_name, isAtlas)
    if ab_name then
        log.r("销毁----->" .. ab_name)
        --Done LwangZg 资源卸载,卸载指定的ab
        ResourcesManager:UnloadAsset(ab_name, true)
        Cache.ab_dic[ab_name] = nil
    else
        if isAtlas then
            log.r("销毁-----> isAtlas  " .. ab_name)
            --Done LwangZg 资源卸载
            ResourcesManager:UnloadAsset("luaprefab_atlas_" .. string.lower(ab_name), true)
        else
            log.r("销毁 unload_ab   null")
        end
    end
end

--清理assertbundle但不清理依赖资源
function Cache.unload_ab_no_depen(ab_name, isAtlas)
    if ab_name then
        log.r("销毁----->" .. ab_name)
        --Done LwangZg 资源卸载
        ResourcesManager:UnloadAsset(ab_name, false)
        Cache.ab_dic[ab_name] = nil
    else
        if isAtlas then
            log.r("销毁-----> isAtlas  " .. ab_name)
            --Done LwangZg 资源卸载
            ResourcesManager:UnloadAsset("luaprefab_atlas_" .. string.lower(ab_name), false)
        else
            log.r("销毁 unload_ab   null")
        end
    end
end

function Cache.unload_atlas_ab(atlasName, isModule, ab_name)
    if atlasName then
        log.r("销毁----->unload_atlas_ab " .. atlasName)
        --local abName = AssetList[ab_name]
        if isModule then
            --Done LwangZg 资源卸载
            ResourcesManager:UnloadAsset(string.lower(ab_name), true)
        else
            --Done LwangZg 资源卸载
            ResourcesManager:UnloadAsset("luaprefab_atlas_" .. string.lower(atlasName), true)
        end
        Cache.ab_dic[atlasName] = nil
    else
        log.r("销毁 unload_ab   null")
    end
end

function Cache.unload_ab_on_exit_game()
    for k, v in pairs(Cache.ab_dic) do
        if (not Cache.IsWhitelistAb(k)) then
            Cache.unload_ab(k)
        end
    end
    --MachinePortalManager.purge()
end

function Cache.unload_ab_on_exit_home()
    for k, v in pairs(Cache.ab_dic) do
        log.r("unload_ab_on_exit_home", k)
        if (not Cache.IsWhitelistAb(k) and k ~= AssetList.SceneLoadingMachineView) then
            Cache.unload_ab(k)
        end
    end
    --MachinePortalManager.purge()
end

-- function Cache.PrintLoadedAsset()
    --resMgr:PrintLoadedAssertBundleNames()
-- end

function Cache.load_materials(assetbundle_name, sprite_names, callback)
    if sprite_names == nil then
        log.r("参数错误,sprite_names不能为nil")
        return
    end
    local ab_name = assetbundle_name or AssetList[sprite_names]
    if ab_name ~= nil then
        local sprite = nil

        -- resMgr:LoadMaterial(ab_name, { sprite_names }, function(objs)
        --     sprite = objs[0]
        --     if callback then
        --         callback(sprite)
        --     end
        -- end)

        ResourcesManager:LoadAssetAsync(BundleCategory.LPB.Material,ab_name,typeof(CS.Material),
        function(assetId,err )
            if err or not assetId then
                log.e("材质失败: " .. ab_name)
                if callback then callback(nil) end
                return
            end

            local material = ResourcesManager:GetAssetObject(assetId)
            if not material then
                log.e("获取材质对象失败: " .. sprite_names)
                if callback then callback(nil) end
                return
            end
            if callback then callback(material) end
        end)
    else
        if callback then
            callback(nil)
        end
        log.r("没有这样的资源：" .. sprite_names)
    end
end

---优先从缓存中加载，如果缓存中没有，则创建实例
function Cache.load_pool_or_instance(pool_name, prefab, needActive)
    local obj = BattleEffectPool:Get(pool_name, nil, needActive)
    if obj == nil and prefab ~= nil then
        obj = fun.get_instance(prefab)
    end
    return obj
end

--- 记录图集的缓存界面调用
function Cache.add_atlas_reference_to_cache_dic(atlasName, abName)
    if atlasName then
        if not Cache.atlas_dic then
            Cache.atlas_dic = {}
        end
        if abName then
            if (not Cache.atlas_dic[atlasName]) then
                Cache.atlas_dic[atlasName] = { abName }
            elseif not fun.is_include(abName, Cache.atlas_dic[atlasName]) then
                table.insert(Cache.atlas_dic[atlasName], abName)
            end
        end
    end
end

--- 没有界面引用的图集，可以卸载
function Cache.remove_atlas_reference(atlasName, abName)
    if atlasName then
        if Cache.atlas_dic and Cache.atlas_dic[atlasName] and #Cache.atlas_dic[atlasName] > 0 then
            fun.remove_table_item(Cache.atlas_dic[atlasName], abName)
        end
        if Cache.atlas_dic and Cache.atlas_dic[atlasName] and #Cache.atlas_dic[atlasName] > 0 then
            log.r(atlasName .. "  还有使用,不卸载  " .. table.print(Cache.atlas_dic[atlasName]))
            return
        end
        log.r(abName .. "卸载  " .. atlasName)
        AssetManager.unload_atlas_ab({ atlasName }, abName)
        -- 移除视图对图集的引用
        AtlasManager:RemoveReference(atlasName, abName)
    end
end

--- 记录图集的缓存界面调用
function Cache.clear_atlas_reference_to_cache_dic()
    Cache.atlas_dic = {}
end

--- 打印atlas_dic的引用关系
function Cache.print_atlas_reference()
    local str = ""
    if Cache.atlas_dic then
        for _, v in pairs(Cache.atlas_dic) do
            for key, value in pairs(v) do
                str = str .. _ .. "：" .. tostring(value) .. "\n"
            end
            str = str .. "  \n "
        end
    end
    log.r(str)
end

function Cache.load_texture_to_sprite(texture_name, img, resize)
    Cache.load_texture(AssetList[texture_name], texture_name, function(objs)
        if objs then
            local sprite = Util.Texture2Sprite(objs)
            if img and sprite then
                img.sprite = sprite
                if resize then
                    img:SetNativeSize()
                end
            end
        end
    end)
end
