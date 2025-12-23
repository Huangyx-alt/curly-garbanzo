require "Utils.Eventer"
require "Utils.SuperDownloader"
require "Utils.WWWTextureLoader"
require "Utils.WWWSpriteLoader"
require "Utils.SuperUnzipDownloader"
require "Common.fun"
require "Logic.MachineDownloadManager"

MachinePortalManager = {}

MachinePortalManager.res_info_type = 
{
    lobby_icon = 1, -- 大厅缩略图
    loading_logo = 2, --加载logo图
    loading_text = 3, --加载说明图
}
--加载图片本地保存地址
MachinePortalManager.res_local_path = 
{
    "_lobby_icon_path" , --加载logo图
    "_loading_logo_path" , --加载logo图
    "_loading_text_path", --加载说明图
}




-- 图片缓存
MachinePortalManager.data_cache = {} -- 原始数据(不含sprite)
MachinePortalManager.data_cache_remake = {} -- 整理过的数据(不含sprite)
MachinePortalManager.sprite_cache_banner = {} -- 大厅列表广告位图片(sprite)

MachinePortalManager.data_cache_preview = {}            -- preview数据缓存
MachinePortalManager.sprite_cache_preview_machine = {}  -- preview图片资源缓存(机台)
MachinePortalManager.sprite_cache_preview_logo = {}     -- preview图片资源缓存(LOGO)
MachinePortalManager.sprite_cache_loading = {}          -- loading图片资源缓存
MachinePortalManager.sprite_cache_loading_text = {}     -- loadingtext图片资源缓存
MachinePortalManager.sprite_md5 = {}     -- 图片MD5

-- 机台图片

MachinePortalManager.data_cache_sprite = {}

MachinePortalManager.group_data = {} -- 分组数据
MachinePortalManager.room_type = "general"
MachinePortalManager.banners_priority = 1
MachinePortalManager.max_priority = 20
local machine_versions = {}

function MachinePortalManager.has_data()
    for i,v in pairs(MachinePortalManager.data_cache_remake) do
        return true
    end
end

-- 设定总机台数以便指定下载优先级
function MachinePortalManager.set_total_count(machine_cnt)
    MachinePortalManager.portal_priority = MachinePortalManager.banners_priority + 5
    MachinePortalManager.preview_machine_priority = MachinePortalManager.portal_priority + machine_cnt
    MachinePortalManager.preview_logo_priority = MachinePortalManager.preview_machine_priority + machine_cnt
    MachinePortalManager.loading_img_priority = MachinePortalManager.preview_logo_priority + machine_cnt
    MachineDownloadManager.machine_download_priority = MachinePortalManager.loading_img_priority + machine_cnt

    MachinePortalManager.res_base_priority = {}
    MachinePortalManager.res_base_priority[1] = MachinePortalManager.portal_priority + machine_cnt
    MachinePortalManager.res_base_priority[2] = MachinePortalManager.loading_img_priority + machine_cnt
    MachinePortalManager.res_base_priority[3] = MachinePortalManager.loading_img_priority + machine_cnt


end

function MachinePortalManager.get_machines_data()
    return MachinePortalManager.data_cache.general.machines
end

function MachinePortalManager.get_machine_index(machine_id)
    local index = 1
    local machines_data = MachinePortalManager.data_cache.general.machines
    for k, v in pairs(machines_data) do
        if v.machine_id == machine_id then
            return index
        end
        index = index + 1
    end
    return MachinePortalManager.max_priority
end

function MachinePortalManager.get_priority(machine_id, base_priority)
    return MachinePortalManager.max_priority - MachinePortalManager.get_machine_index(machine_id) + base_priority
end

-- 获取图片资源 大厅机台图标
function MachinePortalManager.get_portal_image(room_type,machine_id,url,callback)
    local data = MachinePortalManager.data_cache[machine_id]
    local downloader = nil
    local texture_loader = nil
    
    if data and data.portal and data.portal.url == url then
        if callback then
            callback(machine_id,data.portal.sprite)
        end
    else
        if type(url) ~= "string" or url == "" then
            log.r({"资源路径错误",machine_id,url})
            return
        end

        texture_loader = WWWSpriteLoader.create()
        local priority = MachinePortalManager.get_priority(machine_id, MachinePortalManager.portal_priority)
        downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), tostring(url), priority)
        downloader:add_event_listener(SuperDownloader.DownloadSuccess, function (arg)
            texture_loader:run(arg.LocalPath,function(sprite)
                -- log.b("3.加载完成",machine_id,path)
                log.log("大厅机台贴图.加载完成",machine_id,url,sprite)
                MachinePortalManager.data_cache[machine_id] = MachinePortalManager.data_cache[machine_id] or {}
                MachinePortalManager.data_cache[machine_id].portal = {
                    url = url,
                    path = arg.LocalPath,
                    sprite = sprite,
                }
                if callback then
                    callback(machine_id,sprite)
                end
            end)
        end)

        downloader:run()
    end
    return downloader, texture_loader
end

-- 读取大厅机台列表数据(force_request[bool]=true时强制重新请求)
function MachinePortalManager.get_portal_list_data(room_type,callback,force_request)
    local data = MachinePortalManager.data_cache[room_type]
    if force_request or not data then

        Http.fetch_machines(room_type,function(d)
            MachinePortalManager.data_cache[room_type] = d
            MachinePortalManager.remake_portal_list_data(room_type,d)
            MachinePortalManager.make_group_data(room_type,d)
            MachinePortalManager.save_sprite_latest_md5(room_type,d)

            MachinePortalManager.init_res_data(room_type,d)
            if callback then
                callback(d)
            end
        end)
    else
        if callback then
            callback(data)
        end
    end
end

function MachinePortalManager.init_res_data(room_type,data)
    MachinePortalManager.data_cache_sprite[room_type] = {}
    --local cur_lv = 1
    for k ,v in pairs(data.machines) do
        local data = {}
        data.unlock_level = v.unlock_level
        --cur_lv = cur_lv + 1
       -- data.unlock_level =  cur_lv

        local machine_id = v.machine_id
        --log.log("解锁数据", v)
        data.res_info = {}
        for i = 1, #v.res_info do
            data.res_info[i] = {}
            data.res_info[i].url  = v.res_info[i].url
            data.res_info[i].lateset_md5  = v.res_info[i].lateset_md5
            data.res_info[i].sprite  = nil
            data.res_info[i].current_md5  = nil
        end
        MachinePortalManager.data_cache_sprite[room_type][machine_id]  = data
    end
    --log.log("数据变化B",MachinePortalManager.data_cache_sprite)
end

-- 整理机台列表数据
function MachinePortalManager.remake_portal_list_data(room_type,data)
    local remake = {}
    for i,v in ipairs(data.machines) do
        if v.machine_id then
            v.index_in_list = i -- 记录列表中序号
            remake[v.machine_id] = v
        end
    end

    local machine_status_list = {}
    for i,v in pairs(remake) do
        if i ~= "jackpot_remake" then
            machine_status_list[v.machine_id] = v.status
        end
    end
    MachinePortalManager.data_cache_remake[room_type] = remake
end

function MachinePortalManager.save_sprite_latest_md5(room_type, data)
    local remake = {}
    for k ,v in pairs(data.machines) do
        if v.machine_id then
            remake[v.machine_id] = {}
            remake[v.machine_id].cover_pic_latest_md5 = v.cover_pic_latest_md5  --大厅机台图标
            remake[v.machine_id].loading_pic_latest_md5 = v.loading_pic_latest_md5  --加载logo图
            remake[v.machine_id].loading_text_latest_md5 = v.loading_text_latest_md5  -- 加载说明图
        end
    end
    MachinePortalManager.sprite_md5[room_type] = remake
    log.log("MD5统计",  MachinePortalManager.sprite_md5)
end

-- 读取机台列表中单一机台的数据
function MachinePortalManager.get_portal_data_by_machine_id(machine_id)
    
    return MachinePortalManager.data_cache_remake[MachinePortalManager.room_type] and  MachinePortalManager.data_cache_remake[MachinePortalManager.room_type][machine_id] or {}
end

-- 读取机台列表中得数据
function MachinePortalManager.get_portal_data_by_machine()
    return MachinePortalManager.data_cache_remake[MachinePortalManager.room_type] and  MachinePortalManager.data_cache_remake[MachinePortalManager.room_type] or {}
end

-- 整理机台分组数据
function MachinePortalManager.make_group_data(room_type,data)
    local list = {}
    for _, group_item in ipairs(data.groups) do
        --local machine_1_id = group_item.machine_ids[1]
        --local machine_2_id = group_item.machine_ids[2]
        --local machine_1_data = MachinePortalManager.get_portal_data_by_machine_id(machine_1_id)
        --local machine_2_data = MachinePortalManager.get_portal_data_by_machine_id(machine_2_id)
        --local machine_1_style = StaticData.get_machine_style_by_id(machine_1_id)
        --local machine_2_style = StaticData.get_machine_style_by_id(machine_2_id)
        --local group_name = machine_1_data.type
        --list[group_name] = {}
        --local g = list[group_name]
        --g.index_first = machine_1_data.index_in_list
        --g.index_last = machine_2_data.index_in_list
        --g.machine_ids = group_item.machine_ids
        --g.shared_jackpots = {}
        --g.left_jackpot = {}
        --g.right_jackpot = {}
        --local shared_names = {}
        --for _, jackpot_name in ipairs(group_item.shared_jackpots) do
        --    shared_names[jackpot_name] = true
        --end
        ---- 共享
        --for _, jackpot_data in ipairs(machine_1_data.jackpot_info) do
        --    for _, shared_name in ipairs(group_item.shared_jackpots) do
        --        if jackpot_data.jackpot_name == shared_name then
        --            jackpot_data.jackpot_color = machine_1_style.jackpot_color[jackpot_data.jackpot_name]
        --            table.insert(g.shared_jackpots, jackpot_data)
        --        end
        --    end
        --end
        ---- 左
        --for _, jackpot_data in ipairs(machine_1_data.jackpot_info) do
        --    if not shared_names[jackpot_data.jackpot_name] then
        --        jackpot_data.jackpot_color = machine_1_style.jackpot_color[jackpot_data.jackpot_name]
        --        table.insert(g.left_jackpot, jackpot_data)
        --    end
        --end
        ---- 右
        --for _, jackpot_data in ipairs(machine_2_data.jackpot_info) do
        --    if not shared_names[jackpot_data.jackpot_name] then
        --        jackpot_data.jackpot_color = machine_2_style.jackpot_color[jackpot_data.jackpot_name]
        --        table.insert(g.right_jackpot, jackpot_data)
        --    end
        --end
    end
    --log.log("联机标题数据",room_type,list)
    MachinePortalManager.group_data[room_type] = list
    return list
end

-- 读取机台分组数据
function MachinePortalManager.get_group_data(room_type)
    room_type = room_type or MachinePortalManager.room_type
    return MachinePortalManager.group_data[room_type]
end

-- 机台是否是联机机台
function MachinePortalManager.is_machine_in_group(machine_id)
    for i,j in ipairs(MachinePortalManager.group_data) do
        for p,q in ipairs(j.machine_ids) do
            if tostring(machine_id) == tostring(q) then
                return true
            end
        end
    end
    return false
end

--[[ -- 根据machine_id读取机台预览数据
function MachinePortalManager.get_preview_data(machine_id,callback)
    if MachinePortalManager.last_update_user_coin ~= My.get_coin() then
        --log.r("玩家金币发生变化 清空机台预览数据缓存",tostring(MachinePortalManager.last_update_user_coin),">",My.get_coin())
        MachinePortalManager.last_update_user_coin = My.get_coin()
        MachinePortalManager.data_cache_preview = {}
    end
    local data = MachinePortalManager.data_cache_preview[machine_id]
    if data then
        if callback then
            callback(data)
        end
    else
        Http.machine_preview(machine_id, "general", function(para)
            MachinePortalManager.data_cache_preview[machine_id] = para
            if callback then
                callback(para)
            end
        end)
    end
end ]]

-- 获取机台预览图资源
-- will_load 下载成功后是否使用loader将资源加载到内存
--[[ function MachinePortalManager.get_preview_machine_img(machine_id,url,will_load,callback_in_cache,callback_not_in_cache)
    --log.log("get_preview_machine_img",machine_id,url,will_load)
    -- local sprite = MachinePortalManager.sprite_cache_preview_machine[machine_id]
    local sprite =  MachinePortalManager.data_cache_sprite[machine_id].lobby_icon.sprite
    -- local sprite = MachinePortalManager.sprite_cache_preview_machine[machine_id]

    if sprite then
        log.log("缓存中存在",machine_id,url,sprite)
        if callback_in_cache then
            callback_in_cache(machine_id,sprite)
        end
        return
    end
    local downloader = nil
    local texture_loader = nil
    if type(url) ~= "string" then
        log.r({"资源路径错误",machine_id,url})
        return
    end

    local func_md5_down = function()
        
    end

    if CS.AssetsManager:Exist(ModelList.loginModel:GetResurl(), url) then
        log.log("本地已下载",machine_id,url)
        local priority = MachinePortalManager.get_priority(machine_id, MachinePortalManager.preview_machine_priority)
        downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
        if will_load then

            texture_loader = WWWTextureLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
                texture_loader:run(arg.LocalPath,function(sprite)
                    MachinePortalManager.sprite_cache_preview_machine[machine_id] = sprite
                    if callback_in_cache then
                        callback_in_cache(machine_id,sprite) -- 从本地读取 读取完成后 赋值
                    end
                end)
            end)
        end
        downloader:run()
        MachinePortalManager.preview_machine_priority = MachinePortalManager.preview_machine_priority + 1
        return downloader, texture_loader
    else
        log.log("本地未下载",machine_id,url)
        downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, MachinePortalManager.preview_machine_priority)
        if will_load then
            texture_loader = WWWTextureLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
                texture_loader:run(arg.LocalPath,function(sprite)
                    MachinePortalManager.sprite_cache_preview_machine[machine_id] = sprite
                    if callback_not_in_cache then
                        callback_not_in_cache(machine_id,sprite) -- 下载完成后 从本地读取 读取完成后 赋值
                    end
                end)
            end)
        end
        downloader:run()
        return downloader, texture_loader
    end
end ]]

-- 获取机台LOGO资源
-- will_load 下载成功后是否使用loader将资源加载到内存
--[[ function MachinePortalManager.get_preview_logo_img(machine_id,url, will_load, callback)
    --log.log("get_preview_logo_img",machine_id,url,will_load)
    local sprite = MachinePortalManager.sprite_cache_preview_logo[machine_id]
    if sprite then
        if callback then
            callback(machine_id,sprite)
        end
    else
        local downloader = nil
        local texture_loader = nil
        if type(url) ~= "string" then
            log.r({"资源路径错误",machine_id,url})
            return
        end
        local priority = MachinePortalManager.get_priority(machine_id, MachinePortalManager.preview_logo_priority)
        downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
        if will_load then
            texture_loader = WWWTextureLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
                texture_loader:run(arg.LocalPath,function(sprite)
                    MachinePortalManager.sprite_cache_preview_logo[machine_id] = sprite
                    if callback then
                        callback(machine_id,sprite)
                    end
                end)
            end)
        end
        downloader:run()
        return downloader, texture_loader
    end
end ]]


--获取机台加载说明图片
function MachinePortalManager.get_loading_text_img(machine_id, will_load,callback)
    local machine_data = MachinePortalManager.get_portal_data_by_machine_id(machine_id)
    local url = machine_data.loading_text
    local sprite = MachinePortalManager.sprite_cache_loading_text[machine_id]
    if sprite then
        log.log("缓存中存在机台Loading_text图,直接返回",machine_id,url,sprite)
        if callback then
            callback(machine_id,sprite)
        end
    else
        log.log("缓存中不存在机台Loading_text图,开始重新加载",machine_id,url)
        if type(url) ~= "string" then
            log.r({"资源路径错误",machine_id,url})
            return
        end
        local asset_name = "res_"..machine_id.."_loading_text_path"

        local local_path = UnityEngine.PlayerPrefs.GetString(asset_name,"") --之前存储再本地过

        local isFileExist = Util.IsFileExist(local_path)
        local is_md5_same = false
        if isFileExist then
            local current_md5 =  Util.md5file(local_path)
            local latest_md5 = MachinePortalManager.sprite_md5["general"][machine_id].loading_text_latest_md5
            is_md5_same = current_md5 == latest_md5
        end

        log.r("说明图下载t",local_path , isFileExist , is_md5_same)

        if local_path ~= "" and isFileExist and is_md5_same then
            local w = UnityEngine.PlayerPrefs.GetInt(asset_name.."width")
            local h = UnityEngine.PlayerPrefs.GetInt(asset_name.."height")
            local sprite = Util.CreateSprite(local_path,w,h)

            MachinePortalManager.save_machie_bg_path(machine_id,local_path)
            MachinePortalManager.sprite_cache_loading_text[machine_id] = sprite
            if callback then
                callback(machine_id,sprite)
            end
            return
        end

        local priority = MachinePortalManager.get_priority(machine_id, MachinePortalManager.loading_img_priority)
        local downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
        local texture_loader = nil
        if will_load then
            texture_loader = WWWSpriteLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
                texture_loader:run(arg.LocalPath,function(sprite)
                    log.log("机台Loading_text图放入缓存",machine_id,url,sprite)
                    MachinePortalManager.save_machie_bg_path(machine_id,arg.LocalPath)
                    MachinePortalManager.sprite_cache_loading_text[machine_id] = sprite
                    if(Util.IsFileExist(arg.LocalPath))then
                        UserData.set_global(asset_name, arg.LocalPath)
                        UnityEngine.PlayerPrefs.SetInt(asset_name.."width",sprite.texture.width)
                        UnityEngine.PlayerPrefs.SetInt(asset_name.."height",sprite.texture.height)
                    end
                    if callback then
                        callback(machine_id,sprite)
                    end
                end)
            end)
        end
        downloader:run()
        return downloader, texture_loader
    end
end

-- 获取机台加载图片
-- will_load 下载成功后是否使用loader将资源加载到内存
function MachinePortalManager.get_loading_img(machine_id, will_load,callback)
    local machine_data = MachinePortalManager.get_portal_data_by_machine_id(machine_id)
    local url = machine_data.loading_pic
    -- local sprite = MachinePortalManager.sprite_cache_loading[machine_id]
    local sprite =  MachinePortalManager.data_cache_sprite[machine_id].loading_logo.sprite
    --local sprite_txt = MachinePortalManager.sprite_cache_loading_text[machine_id]
    if sprite then
        if callback then
            callback(machine_id,sprite)
        end
    else
        log.log("缓存中不存在机台Loading图,开始重新加载",machine_id,url)
        if type(url) ~= "string" then
            log.r({"资源路径错误",machine_id,url})
            return
        end
        local asset_name = "res_"..machine_id.."_loading_path"

        local local_path = UnityEngine.PlayerPrefs.GetString(asset_name,"") --之前存储再本地过

        if (local_path ~= "") then
            local isFileExist = Util.IsFileExist(local_path)
            local is_md5_same = false
            if isFileExist then
                local current_md5 =  Util.md5file(local_path)
                local latest_md5 = MachinePortalManager.sprite_md5["general"][machine_id].loading_pic_latest_md5
                is_md5_same = current_md5 == latest_md5
            end
            log.log("机台预览图下载XYZ",isFileExist ,  is_md5_same)
            
            if isFileExist and is_md5_same then
                local w = UnityEngine.PlayerPrefs.GetInt(asset_name.."width")
                local h = UnityEngine.PlayerPrefs.GetInt(asset_name.."height")
                local sprite = Util.CreateSprite(local_path,w,h)
                MachinePortalManager.save_machie_bg_path(machine_id,local_path)
                MachinePortalManager.sprite_cache_loading[machine_id] = sprite
                log.log("机台预览图下载H" , local_path,w,h)

                if callback then
                    callback(machine_id,sprite)
                end
                return
            end
        end

        local priority = MachinePortalManager.get_priority(machine_id, MachinePortalManager.loading_img_priority)
        local downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
        local texture_loader = nil
        if will_load then
            texture_loader = WWWSpriteLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)

                texture_loader:run(arg.LocalPath,function(sprite)
                    log.log("机台Loading_text图放入缓存",machine_id,url,sprite)
                    MachinePortalManager.save_machie_bg_path(machine_id,arg.LocalPath)
                    MachinePortalManager.sprite_cache_loading[machine_id] = sprite
                    if(Util.IsFileExist(arg.LocalPath))then
                        UserData.set_global(asset_name, arg.LocalPath)
                        UnityEngine.PlayerPrefs.SetInt(asset_name.."width",sprite.texture.width)
                        UnityEngine.PlayerPrefs.SetInt(asset_name.."height",sprite.texture.height)
                    end
                    if callback then
                        callback(machine_id,sprite)
                    end
                end)
            end)
        end
        downloader:run()
        return downloader, texture_loader
    end
end

function MachinePortalManager.save_machie_bg_path(machine_id,path)
    UserData.set_global("res_"..tostring(machine_id).."_path",path)
end

function MachinePortalManager.get_machie_bg_path(machine_id)
    --UserData.get_global("res_"..tostring(machine_id).."_path","")
    local key = "res_"..tostring(machine_id).."_path"
    local ret_str = UnityEngine.PlayerPrefs.GetString(key)
    ret_str  = ret_str or ""
    return ret_str
end


function MachinePortalManager.status_prefix_builder(machine_id, key)
    return "machine."..machine_id..".status."..key
end

-- 获取大厅广告位数据
function MachinePortalManager.get_banners_data(callback)
    local data = MachinePortalManager.sprite_cache_banner

    if data and next(data) == nil  then
        Http.fetch_banners(function(d)
            MachinePortalManager.sprite_cache_banner = d 
            if callback then

                callback()
            end
        end)
    else
        if callback then
            callback()
        end
    end
end

function MachinePortalManager.get_banners()
    return  MachinePortalManager.sprite_cache_banner
end





-- 获取大厅广告位资源
function MachinePortalManager.get_banner_img(url,callback)
    local sprite = MachinePortalManager.sprite_cache_banner[url]
    if sprite then
        if callback then
            callback(sprite)
        end
        return nil, nil
    else
        local priority = MachinePortalManager.banners_priority + 20
        local downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
        local texture_loader = WWWTextureLoader.create()
        --log.log("开始下载Banner图片",url)
        -- TODO by LwangZg 运行时热更部分
        downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
            --log.log("Banner图片下载成功",url)
            texture_loader:run(arg.LocalPath,function(sprite)
                -- log.y("广告图读取成功",arg.LocalPath)
                MachinePortalManager.sprite_cache_banner[url] = sprite
                if callback then
                    callback(sprite)
                end
            end)
        end)
        downloader:run()
        MachinePortalManager.banners_priority = MachinePortalManager.banners_priority + 1
        return downloader, texture_loader
    end
end

function MachinePortalManager.purge()
    for machine_id,sprite in pairs(MachinePortalManager.sprite_cache_preview_machine) do
        UnityEngine.Object.Destroy(sprite)
        MachinePortalManager.sprite_cache_preview_machine[machine_id] = nil
    end

    for machine_id,sprite in pairs(MachinePortalManager.sprite_cache_preview_logo) do
        UnityEngine.Object.Destroy(sprite)
        MachinePortalManager.sprite_cache_preview_logo[machine_id] = nil
    end

    for machine_id,sprite in pairs(MachinePortalManager.sprite_cache_loading) do
        UnityEngine.Object.Destroy(sprite.texture)
        UnityEngine.Object.Destroy(sprite)
        MachinePortalManager.sprite_cache_loading[machine_id] = nil
    end

    -- for url,sprite in pairs(MachinePortalManager.sprite_cache_banner) do
    --     UnityEngine.Object.Destroy(sprite)
    --     MachinePortalManager.sprite_cache_banner[url] = nil
    -- end


    for room_type , machine_info in pairs(MachinePortalManager.data_cache_sprite) do
        for sprite_type ,sprite_info in pairs(machine_info) do
            for i = 1, #sprite_info["res_info"] do
                if sprite_info["res_info"][i].sprite then
                    UnityEngine.Object.Destroy(sprite_info["res_info"][i].sprite)
                end
                -- sprite_info[i].url = nil
                -- sprite_info[i].lateset_md5 = nil
            end
        end
    end
end

-- 提前下载某个机台3种图片
function MachinePortalManager.prepare_machine_sprite(machine_id , finish_call_back)
    local type_list = {}

    local test_call_back = function(sprite_type)
        if not type_list[sprite_type] then
            type_list[sprite_type] = true
            if GetTableLength(type_list)  == 3 then 
                if finish_call_back then
                    finish_call_back()
                end
            end
        end
    end

    for k , v in pairs(MachinePortalManager.res_info_type) do
        local latest_md5 = MachinePortalManager.data_cache_sprite[MachinePortalManager.room_type][machine_id]["res_info"][v].lateset_md5
        local sprite_path =  MachinePortalManager.res_local_path[v]
        local url = MachinePortalManager.data_cache_sprite[MachinePortalManager.room_type][machine_id]["res_info"][v].url

        local asset_name = "res_"..machine_id .. sprite_path
        if MachinePortalManager.match_local_path(url, latest_md5) then
            test_call_back(v)
        else
            MachinePortalManager.get_machine_sprite(MachinePortalManager.room_type , machine_id ,v,
            function(machine_id, sprite)
                if sprite then
                    test_call_back(v)
                end
            end
            )
        end
    end
end

-- 判断本地是否有文件并且是最新的
function MachinePortalManager.match_local_path(url, latest_md5,call_back)
    -- TODO 接口替换 by LwangZg
    local localPath = CS.AssetsManager:GetFilePathFromStorage(url)
    if not localPath or localPath == "" then
        return false
    end
    local current_md5 = string.lower(Util.md5file(localPath)) 
    
    local is_md5_same = current_md5 == string.lower(latest_md5)
    if(is_md5_same == false)then 
        Util.DeleteFile(localPath)  --md5不存在的情况下,直接删除
    end
    log.r("查找本地图片"  , is_md5_same , "当前MD5", current_md5 ,"   最新MD5", latest_md5 , current_md5 == latest_md5)

    return is_md5_same
end

-- 获得机台图片
function MachinePortalManager.get_machine_sprite(room_type, machine_id, sprite_type, call_back)
    
    local latest_md5 = MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].lateset_md5

    local url = MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].url
    local base_priority = MachinePortalManager.res_base_priority[sprite_type]
    local downloader = nil
    local texture_loader = nil

    -- TODO 接口替换 by LwangZg
    local is_local_res = CS.AssetsManager:Exist(ModelList.loginModel:GetResurl(), url)

    local is_same_md5 = false
    if is_local_res then
        is_same_md5 = MachinePortalManager.match_local_path(url, latest_md5)
    end
    log.r("get_machine_sprite",is_same_md5,is_local_res,ModelList.loginModel:GetResurl(),url)
    --本地存在最新文件
    if is_local_res and is_same_md5 then
        
        local priority = MachinePortalManager.get_priority(machine_id, base_priority)
        downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority,latest_md5)
        texture_loader = WWWTextureLoader.create()
        downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
            texture_loader:run(arg.LocalPath,function(tex2d)
                local sprite = Util.Texture2Sprite(tex2d)
                MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].sprite = sprite
                MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].current_md5 = latest_md5
                if call_back then
                    call_back(machine_id,sprite) -- 从本地读取 读取完成后 赋值
                end
            end)
        end)
        downloader:run()
        MachinePortalManager.preview_machine_priority = MachinePortalManager.preview_machine_priority + 1
        return downloader, texture_loader
    else
        local priority = MachinePortalManager.get_priority(machine_id, base_priority)
        local downloader = SuperDownloader.create(ModelList.loginModel:GetResurl(), url, priority)
            texture_loader = WWWTextureLoader.create()
            downloader:add_event_listener(SuperDownloader.DownloadSuccess,function(arg)
                texture_loader:run(arg.LocalPath,function(tex2d)
                    local sprite = Util.Texture2Sprite(tex2d)
                    MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].sprite = sprite
                    MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type].current_md5 = latest_md5
                    if call_back then
                        call_back(machine_id,sprite) -- 下载完成后 从本地读取 读取完成后 赋值
                    end
                end)
            end)
        -- end
        downloader:run()
        return downloader, texture_loader
    end
end


function MachinePortalManager.try_unlock_machine(lv)
    -- MachinePortalManager.data_cache_sprite[room_type][machine_id]["res_info"][sprite_type]
    local room_type = MachinePortalManager.room_type
    if(MachinePortalManager.data_cache_sprite and MachinePortalManager.data_cache_sprite[room_type])then 
        for machine_id , v in pairs(MachinePortalManager.data_cache_sprite[room_type]) do
            log.log("这个目标", machine_id, v)
            if v.unlock_level == lv then
                -- 判断要解锁的机台资源是否最新
                
                -- MachinePortalManager.prepare_machine_sprite(machine_id)
                return machine_id
    
            end
        end
    end 
    return nil
end

