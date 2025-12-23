require("View/Bingo/EffectPool/GoPool")
--  缓存战斗中需要 频繁出现且数据多的特效
BattleEffectPool = Clazz(ClazzBase, "BattleEffectPool")
local this = BattleEffectPool

local skillContainer = nil
local bingoContainer = nil
local bindEffectes = {}

---@field  EffectObjContainer
local source = nil

function BattleEffectPool:New()

end

function BattleEffectPool:CreateBattleEffect(sourceRef, cb)
    source = sourceRef
    skillContainer = sourceRef.SkillContainer
    bingoContainer = sourceRef.BingoContainer
    bindEffectes = {}
    
    --this:ReplacePrefabWithJoker()
    GoPool.init()
    
    local playID = ModelList.CityModel.GetPlayIdByCity()
    local effectConfig = Csv.GetData("new_game_pool_effect", playID, "effect_config")
    
    coroutine.start(function()
        table.walk(effectConfig, function(v)
            local poolName, prefabName, initSize, maxSize = v[1], v[2], v[3], v[4]
            local prefab = sourceRef[prefabName]
            if fun.is_not_null(prefab) then
                GoPool.CreatePool(poolName, initSize, maxSize, prefab, prefab.transform.parent)
                WaitForEndOfFrame()
            end
        end)
        self:CreatePowerEffectPool(sourceRef)
        fun.SafeCall(cb)
    end)
end

function BattleEffectPool:CreatePowerEffectPool(sourceRef)
    local puEffectRoot = sourceRef["BingoBangPuEffectContainer"]
    if fun.is_not_null(puEffectRoot) then
        fun.eachChild(puEffectRoot, function(child)
            local childName = child.name
            GoPool.CreatePool(childName, 2, 4, child, puEffectRoot)
            WaitForEndOfFrame()
        end)
    end
end

function BattleEffectPool:Get(poolName, targetObj, defaultActive)
    if defaultActive == nil then
        defaultActive = true
    end
    local obj = GoPool.pop(poolName, defaultActive)
    if not fun.is_null(obj) then
        if targetObj then
            fun.set_same_position_with(obj, targetObj)
        end
        fun.set_active(obj, defaultActive)
        return obj
    end
    return nil
end

function BattleEffectPool:GetAndBind(poolName, targetObj, cardId, recycleTime, addCover, parentLayer)
    local obj = GoPool.pop(poolName)
    if fun.is_not_null(obj) and fun.is_not_null(targetObj) then
        local coverObj = nil
        fun.set_same_position_with_but_z_zero(obj, targetObj)
        if addCover then
            fun.set_active(obj, false)
            coverObj = UnityEngine.GameObject.New("Cover")
            fun.set_parent(coverObj, obj.transform.parent, true)
            fun.set_same_position_with(coverObj, targetObj)
            fun.set_parent(obj, coverObj, true)
        end
        if not cardId then
            cardId = -1
        else
            cardId = tonumber(cardId)
        end
        table.insert(bindEffectes, { target = targetObj, go = obj, cardId = cardId, coverObj = coverObj })
    end
    fun.set_active(obj, true)
    if recycleTime then
        this:DelayRecycleAndunBind(poolName, obj, recycleTime, parentLayer)
    end
    return obj
end

function BattleEffectPool:Recycle(poolName, obj)
    if not Util.IsNull(obj) then
        BattleEffectCache:RemoveBindEffect2(obj)
        return GoPool.push(poolName, obj)
    end
    skillContainer = nil
    bingoContainer = nil
    bindEffectes = {}
    source = nil
end

--- 回收方法2，如果没有对应的池子，就创建一个新的池子
function BattleEffectPool:Recycle2(poolName, obj, parent)
    if not Util.IsNull(obj) then
        BattleEffectCache:RemoveBindEffect2(obj)
        fun.set_parent(obj, parent)
        return GoPool.push(poolName, obj, parent)
    end
end

function BattleEffectPool:DelayRecycle(poolName, obj, delay)
    LuaTimer:SetDelayFunction(delay, function()
        if obj then
            fun.set_active(obj, false)
            if fun.is_not_null(obj) and ModelList.BattleModel:IsGameing() then
                BattleEffectPool:Recycle(poolName, obj)
                if fun.is_not_null(obj) then
                    fun.set_transform_pos(obj.transform, 5000, 5000, 0, true)
                end
                BattleEffectCache:RemoveBindEffect2(obj)
            end
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function BattleEffectPool:DelayRecycleAndunBind(poolName, obj, delay, parentLayer)
    LuaTimer:SetDelayFunction(delay, function()
        if obj then
            fun.set_active(obj, false)
            this:CheckRemoveBind(obj, parentLayer)
            if not Util.IsNull(obj) and obj and ModelList.BattleModel:IsGameing() then
                BattleEffectPool:Recycle(poolName, obj)
                if fun.is_not_null(obj) then
                    fun.set_transform_pos(obj.transform, 5000, 5000, 0, true)
                end
            end
        end
    end, nil, LuaTimer.TimerType.Battle)
end

function BattleEffectPool:ShowWithAutoRecycle(poolName, targetObj, delay, callback)
    local obj = this:Get(poolName, targetObj)
    if callback then
        callback(obj)
    end
    this:DelayRecycle(poolName, obj, delay)
    return obj ~= nil and true or false
end

function BattleEffectPool:Release()
    GoPool.clear()
    bindEffectes = {}
    skillContainer = nil
end

function BattleEffectPool:FollowTargetObj()
    for i = 1, #bindEffectes do
        if not Util.IsNull(bindEffectes[i].target) and not Util.IsNull(bindEffectes[i].coverObj) then
            fun.set_same_position_with(bindEffectes[i].coverObj, bindEffectes[i].target)
        elseif not Util.IsNull(bindEffectes[i].target) and not Util.IsNull(bindEffectes[i].go) then
            fun.set_same_position_with(bindEffectes[i].go, bindEffectes[i].target)
        end
    end
    for i = #bindEffectes, 1, -1 do
        if Util.IsNull(bindEffectes[i].target) or Util.IsNull(bindEffectes[i].go) then
            if bindEffectes[i].coverObj and not Util.IsNull(bindEffectes[i].coverObj) then
                Destroy(bindEffectes[i].coverObj)
            end
            table.remove(bindEffectes, i)
        end
    end
end

local ContainerType = { "CellChipContainer", "GetGiftContainer", "FlyGiftContainer",
                        "FoodBagContainer", "CellContainer", "PowerUpContainer", "BingoContainer", "SkillContainer",
                        "BoxContainer" }
---@see 获取特效容器
---@param containerType
function BattleEffectPool:GetContainer(containerType)
    if source then
        return source[tostring(containerType)]
    end
    return nil
end

--- 检查有单卡绑定关系的特效是否全部隐藏
function BattleEffectPool:CheckRemoveBind(obj, parentLayer)
    for i = #bindEffectes, 1, -1 do
        if Util.IsNull(bindEffectes[i].target) or Util.IsNull(bindEffectes[i].go) then
            if bindEffectes[i].coverObj and not Util.IsNull(bindEffectes[i].coverObj) then
                Destroy(bindEffectes[i].coverObj)
            end
            table.remove(bindEffectes, i)
        elseif bindEffectes[i].go == obj then
            if bindEffectes[i].coverObj then
                if not parentLayer or parentLayer == 2 then
                    fun.set_parent(obj, obj.transform.parent.parent)
                elseif parentLayer == 3 then
                    fun.set_parent(obj, obj.transform.parent.parent.parent)
                end
                Destroy(bindEffectes[i].coverObj)
            end
            if bindEffectes[i].coverObj and not Util.IsNull(bindEffectes[i].coverObj) then
                Destroy(bindEffectes[i].coverObj)
            end
            table.remove(bindEffectes, i)
        end
    end
end

--- 检查有单卡绑定关系的特效是否全部隐藏
function BattleEffectPool:CardHideAllBindEffect()
    for i = #bindEffectes, 1, -1 do
        if not bindEffectes[i].isJackpot then
            fun.set_active(bindEffectes[i].go, false)
        end
    end
end

--- 检查有单卡绑定关系的特效是否全部隐藏
function BattleEffectPool:IsCardHideAllBindEffect(cardID)
    for i = #bindEffectes, 1, -1 do
        if cardID then
            if cardID == bindEffectes[i].cardId then
                if fun.get_active_self(bindEffectes[i].go) then
                    return false
                end
            end
        else
            if fun.get_active_self(bindEffectes[i].go) then
                return false
            end
        end
    end
    return true
end

--- 小丑机台，单独替换几个特效
function BattleEffectPool:ReplacePrefabWithJoker()
    --特色玩法要使用本身的效果
    local checkType = ModelList.BattleModel:GetGameType() == PLAY_TYPE.PLAY_TYPE_NORMAL
    if checkType and ModelList.BattleModel.GetIsJokerMachine() then
        if source.get then
            Cache.load_prefabs(AssetList["getClown"], "getClown", function(prefab)
                if prefab then
                    local go = fun.get_instance(prefab, source.get.transform.parent)
                    source.get = go
                end
            end)
        end
        if source.get_fast then
            Cache.load_prefabs(AssetList["getFastClown"], "getFastClown", function(prefab)
                if prefab then
                    local go = fun.get_instance(prefab, source.get_fast.transform.parent)
                    source.get_fast = go
                end
            end)
        end
        if source.ClickNoCall then
            Cache.load_prefabs(AssetList["ClickNoCallClown"], "ClickNoCallClown", function(prefab)
                if prefab then
                    local go = fun.get_instance(prefab, source.ClickNoCall.transform.parent)
                    source.ClickNoCall = go
                end
            end)
        end
    end
end

