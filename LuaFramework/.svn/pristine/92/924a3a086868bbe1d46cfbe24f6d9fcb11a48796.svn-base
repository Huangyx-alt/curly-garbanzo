
GoPool = {}
GoPool.isInit = false

local ef_Bingo_click_pool_name = "ef_Bingo_click"

function GoPool.init()
    if not GoPool.isInit then
        GoPool.go_pool_dic = {}
        GoPool.isInit = true
    end
end


function GoPool.CreatePool(pool_name , initSize, maxSize, prefab,parent_trans)
    if not GoPool.isInit then GoPool.init() end
    initSize = tonumber(initSize)
    maxSize = tonumber(maxSize)
    if  GoPool:Key_Include(GoPool.go_pool_dic,pool_name) then
        GoPool.go_pool_dic[pool_name].max_size = GoPool.go_pool_dic[pool_name].max_size + maxSize
        return
    end
    --if  Util.IsPrefabInstance( prefab ) then  --This is a Prefab Instance
    --    GoPool.go_pool_dic[pool_name] = {max_size = tonumber( maxSize),clone = prefab, parent = parent_trans,objs ={prefab},minCount = 1,minTime = os.time() }
    --else  --This is a Prefab Asset
    --
    --end
    GoPool.go_pool_dic[pool_name] = {max_size = tonumber( maxSize),clone = prefab, parent = parent_trans,objs ={},minCount = 1,minTime = os.time() }
    if initSize == 0 then
        log.r("pool  initSize  为0  "..pool_name)
    end
    if initSize < 0 then  -- 跟随卡牌数量变化，基础值是2
        local cardCount =  math.abs(initSize)
        if ModelList.BattleModel:GetCurrModel() then cardCount = ModelList.BattleModel:GetCurrModel():GetCardCount() end
        initSize = 2*cardCount
    end
    for i = 1, initSize do
        local obj = fun.get_instance(prefab,parent_trans)
        fun.set_active(obj,false)
        table.insert(GoPool.go_pool_dic[pool_name].objs,obj)
        fun.set_transform_pos(obj.transform,5000,0,0,true)
    end
end


function GoPool.pop(pool_name,defaultActive)
    if not GoPool.go_pool_dic[pool_name] then
        log.r("pool  为空  "..pool_name)
        return nil
    end
    if  defaultActive == nil then defaultActive = true end
    ---对象池增加取之前，假如发现有空对象，则清理一遍对象池
    if #GoPool.go_pool_dic[pool_name].objs > 0 then
        local obj = GoPool.go_pool_dic[pool_name].objs[1]
        table.remove(GoPool.go_pool_dic[pool_name].objs,1)
        if not obj or fun.is_null(obj) then
            for i = #GoPool.go_pool_dic[pool_name].objs, 1,-1  do
                local objs = GoPool.go_pool_dic[pool_name].objs[i]
                if not objs or fun.is_null(objs) then
                    table.remove(GoPool.go_pool_dic[pool_name].objs,i)
                end
            end
        elseif fun.is_not_null(obj) then
            fun.set_gameobject_scale(obj,1,1,1)
            fun.set_active(obj,defaultActive)
            GoPool.refresh_pool_min_count(pool_name)
            return obj
        end
    end
    if #GoPool.go_pool_dic[pool_name].objs > 0 then
        local obj = GoPool.go_pool_dic[pool_name].objs[1]
        table.remove(GoPool.go_pool_dic[pool_name].objs,1)
        if fun.is_not_null(obj) then
            fun.set_gameobject_scale(obj,1,1,1)
            fun.set_active(obj,defaultActive)
            return obj
        end
    else
        --log.r("Instantiate n not long  "..pool_name )
        if  fun.is_null(GoPool.go_pool_dic[pool_name].clone ) then
            log.r("pool  clone  clone 原型  被删  "..pool_name.."       ")
            Cache.load_prefabs(AssetList[pool_name],pool_name,function(obj)
                local go = fun.get_instance(obj)
                GoPool.go_pool_dic[pool_name].clone = go
            end)
        end
        if fun.is_not_null(GoPool.go_pool_dic[pool_name].clone)  then
            local obj = fun.get_instance(GoPool.go_pool_dic[pool_name].clone,GoPool.go_pool_dic[pool_name].parent)
            fun.set_gameobject_scale(obj,1,1,1)
            fun.set_active(obj,defaultActive)
            GoPool.refresh_pool_min_count(pool_name)
            return obj
        end
    end
    return nil
end

function GoPool.push(pool_name,obj,parent)
    if not GoPool.isInit then GoPool.init() end
    if not fun.is_null(obj) then
        if GoPool.go_pool_dic[pool_name] then
            if #GoPool.go_pool_dic[pool_name].objs >= GoPool.go_pool_dic[pool_name].max_size then
                Destroy(obj)
                return
            end
            table.insert(GoPool.go_pool_dic[pool_name].objs, obj)
        else
            GoPool.go_pool_dic[pool_name] = {max_size = 10,clone = obj, parent = parent,objs ={obj} ,minCount = 1,minTime = os.time() }
        end
        if string.find(obj.name, "%(Clone%)") then
            obj.name =  string.gsub(obj.name, "%(Clone%)", "")
        end
        fun.set_active(obj, false)
        fun.set_transform_pos(obj.transform, 5000, 0, 0, true)
        fun.set_gameobject_scale(obj, 1, 1, 1)
    end
end

function GoPool.insert_pool(prefab_name,go_child)
    GoPool.go_pool_dic[prefab_name] = GoPool.go_pool_dic[prefab_name] or {}
    table.insert(GoPool.go_pool_dic[prefab_name],go_child)
end

function GoPool.remove_pool(prefab_name)
    GoPool.go_pool_dic[prefab_name] = GoPool.go_pool_dic[prefab_name] or {}
    local go_child = table.remove(GoPool.go_pool_dic[prefab_name])
    return go_child
end

function GoPool.clear()
    for k,go_list in pairs(GoPool.go_pool_dic) do
        for _,go in ipairs(go_list) do Destroy(go) end
    end
    GoPool.go_pool_dic = {}
end

--- 协程分帧Destroy go_pool_dic中的对象
function GoPool.destroy_go_pool_dic()
    if GoPool.coroutine_destroy_go_pool_dic then
        return
    end
    GoPool.coroutine_destroy_go_pool_dic = coroutine.start(function()
        for k,go_list in pairs(GoPool.go_pool_dic) do
            if k~= "FlyRewardhit" and not string.find(k,"ackpot") and not string.find(k,"ingo")  then
                for _,go in ipairs(go_list.objs) do
                    if not fun.is_null(go) then
                        Destroy(go)
                        WaitForEndOfFrame()
                        WaitForEndOfFrame()
                    end
                end
                go_list.objs = {}
            end
        end
        GoPool.coroutine_destroy_go_pool_dic = nil
    end)
end

--- 协程分帧Destroy go_pool_dic中的对象
function GoPool.destroy_go_pool_unactive_dic()
    if GoPool.coroutine_destroy_go_pool_dic then
        return
    end
    GoPool.coroutine_destroy_go_pool_dic = coroutine.start(function()
        for k,go_list in pairs(GoPool.go_pool_dic) do
            if k~= "FlyRewardhit" and not string.find(k,"ackpot") and not string.find(k,"ingo")  then
                for _,go in ipairs(go_list.objs) do
                    if not fun.get_active_self(go) then
                        Destroy(go)
                        WaitForEndOfFrame()
                    end
                end
                go_list.objs = {}
            end
        end
        GoPool.coroutine_destroy_go_pool_dic = nil
    end)
end

--- 停止分帧Destroy go_pool_dic中的对象
function GoPool.stop_destroy_go_pool_dic()
    if GoPool.coroutine_destroy_go_pool_dic then
        coroutine.stop(GoPool.coroutine_destroy_go_pool_dic)
        GoPool.coroutine_destroy_go_pool_dic = nil
    end
end


function GoPool.dump()
    log.g("go_pool",GoPool.go_pool_dic)
end

function GoPool:Key_Include(tab, key)
    for k, v in pairs(tab) do
        if k == key then
            return true
        end
    end
    return false
end

--- 获取ef_Bingo_click的对象池数量
function GoPool.get_bingo_click_pool_count()
    local count = 0
    for k,go_list in pairs(GoPool.go_pool_dic) do
        if k == "ef_Bingo_click" then
            count = #go_list
        end
    end
    return count
end

--- ef_Bingo_click的对象池扩容
function GoPool.bingo_click_pool_add()
    if GoPool.go_pool_dic and GoPool.go_pool_dic[ef_Bingo_click_pool_name] and  GoPool.go_pool_dic[ef_Bingo_click_pool_name].clone ~= nil then
        local obj = fun.get_instance(GoPool.go_pool_dic[ef_Bingo_click_pool_name].clone,GoPool.go_pool_dic[ef_Bingo_click_pool_name].parent)
        fun.set_gameobject_scale(obj,1,1,1)
        fun.set_active(obj,false)
        GoPool.push(ef_Bingo_click_pool_name,obj)
    end
end


--- 刷新当前池子的最小剩余数量
function GoPool.refresh_pool_min_count(pool_name)
    if GoPool.go_pool_dic and  GoPool.go_pool_dic[pool_name] then
        GoPool.go_pool_dic[pool_name].minCount = math.min(GoPool.go_pool_dic[pool_name].minCount, #GoPool.go_pool_dic[pool_name].objs)
    end
end

---  缩减当前池子的最小剩余数量
function GoPool.shrip_pool()
    coroutine.start(function()

    end)
end
