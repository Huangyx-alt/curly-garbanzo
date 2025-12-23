---- 小丑卡 遥控炸弹 入场效果

local BaseCardJokerEffect = require("View.Bingo.EffectModule.CardJoker.BaseCardJokerEffect")

local JokerRemoteBombEnterEffect = BaseCardJokerEffect:New()
local this = JokerRemoteBombEnterEffect

local BoomPosOffset = { x = 48.5, y = 48.5, z = 0 }
local BoomScale = { x = 0.6, y = 0.6, z = 1 }

function JokerRemoteBombEnterEffect:New()
    local o = { isLoaded = false, changeSceneClear = true, direction = nil, targetCell = nil, objTable = {}, directionTable = {} }
    self.__index = self
    setmetatable(o, self)
    return o
end

---基类继承
function JokerRemoteBombEnterEffect:SetInfo(info, parentObj, parentRef)
    self.data = info
    self._parentRef = parentRef
    local obj = parentRef:GetPreloadPrefab("clowndaoju_Dilei")
    if obj then
        for i = 1, #self.data.cardPowerUpEffect do
            local newobj = obj
            if i > 1 then newobj = self:GetLoadedResource("clowndaoju_Dilei",parentRef,"clowndaoju_Dilei") end
            if newobj then
                fun.set_parent(newobj, parentObj, true)
                table.insert(self.objTable, newobj)
            end
        end
    else
        Cache.load_prefabs(AssetList["clowndaoju_Dilei"], "clowndaoju_Dilei", function(prefab)
            if prefab then
                for i = 1, #self.data.cardPowerUpEffect do
                    local obj = fun.get_instance(prefab)
                    if obj then
                        fun.set_parent(obj, parentObj, true)
                        table.insert(self.objTable, obj)
                    end
                end
            end
        end)
    end
end

function JokerRemoteBombEnterEffect:Play()
    local cfg = Csv.GetData("new_powerup", self.data.powerUpId, "result")
    local animaName = string.format("enter%s", cfg[2])

    if self.objTable and #self.objTable > 0 then
        for i = 1, #self.objTable do
            fun.set_active(self.objTable[i], true)
            local animator = fun.get_animator(self.objTable[i])
            if animator then
                LuaTimer:SetDelayFunction(0.55, function()
                    animator:Play(animaName)
                end)
            end
        end
    end
    LuaTimer:SetDelayFunction(1.55, function()
        self:Fly()
    end)
end

function JokerRemoteBombEnterEffect:Fly()
    -- 飞炸弹遥控器
    table.each(self.data.cardPowerUpEffect, function(cardPowerUpEffect, k)
        local clientPos = ConvertServerPos(cardPowerUpEffect.posList[1])
        --设置格子数据
        self:SetCellChange(cardPowerUpEffect.cardId, clientPos, 5, cardPowerUpEffect.extraPos)

        local obj = self.objTable[k]
        local targetCell = self:GetJokerCellObj(cardPowerUpEffect.cardId, clientPos)
        if targetCell then
            --local animator = fun.get_animator(obj)
            --if animator then
            --    animator:Play("fei")
            --end

            fun.set_parent(obj, targetCell.transform)
            Anim.move(obj, 0, 0, 0, 0.6, true, 1, function()
                self:PlayEffect(targetCell, cardPowerUpEffect)
                fun.set_gameobject_scale(obj, 1, 1, 1)
                --fun.set_alpha(obj, 0.5)
            end)
            --Anim.scale(obj, BoomScale.x, BoomScale.y, BoomScale.z, 1, true)
        end
    end)
end

function JokerRemoteBombEnterEffect:PlayEffect(targetCell, cardPowerUpEffect)
    if self._parentRef then        -- 预加载的地雷
        local obj =  self:GetLoadedResource("clowndaoju_getxiao",self._parentRef,"clowndaoju_getxiao")
        if obj and targetCell then
            fun.set_parent(obj, targetCell.transform, true)
            fun.set_active(obj, true)
            Destroy(obj, 2)
        end
    else
        Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
            if prefab then
                local obj = fun.get_instance(prefab)
                if obj and targetCell then
                    fun.set_parent(obj, targetCell.transform, true)
                    fun.set_active(obj, true)
                    Destroy(obj, 2)
                end
            end
        end)
    end



    if self._parentRef then        -- 预加载的地雷
        table.each(cardPowerUpEffect.extraPos, function(boomPos)
            boomPos = ConvertServerPos(boomPos)
            local obj =  self:GetLoadedResource("clown_Dilei",self._parentRef,"clown_Dilei")
            fun.set_name(obj, "JokerBoom")
            local cellObj = self:GetJokerCellObj(cardPowerUpEffect.cardId, boomPos)
            if cellObj then
                fun.set_parent(obj, cellObj.transform)
                fun.set_rect_local_pos(obj, BoomPosOffset.x, BoomPosOffset.y, BoomPosOffset.z)
                fun.set_gameobject_scale(obj, 1, 1, 1)
                fun.set_active(obj, true)
                --fun.set_alpha(obj, 0.5)
            end
        end)
    else
        -- 炸弹出现
        Cache.load_prefabs(AssetList["clown_Dilei"], "clown_Dilei", function(prefab)
            if prefab then
                table.each(cardPowerUpEffect.extraPos, function(boomPos)
                    boomPos = ConvertServerPos(boomPos)
                    local obj = fun.get_instance(prefab)
                    fun.set_name(obj, "JokerBoom")
                    local cellObj = self:GetJokerCellObj(cardPowerUpEffect.cardId, boomPos)
                    if cellObj then
                        fun.set_parent(obj, cellObj.transform)
                        fun.set_rect_local_pos(obj, BoomPosOffset.x, BoomPosOffset.y, BoomPosOffset.z)
                        fun.set_gameobject_scale(obj, 1, 1, 1)
                        --fun.set_alpha(obj, 0.5)
                    end
                end)
            end
        end)
    end




end

function JokerRemoteBombEnterEffect:PlayOver()
    --log.r("JokerBallSprayerEnterEffect:PlayOver")
end

---预加载依赖的资源
function JokerRemoteBombEnterEffect:PreloadDependResource(callBack,callback2,index,data)
    Cache.load_prefabs(AssetList["clown_Dilei"], "clown_Dilei", function(prefab1)
        Cache.load_prefabs(AssetList["clowndaoju_Dilei"], "clowndaoju_Dilei", function(prefab2)
            this:CoroutineLoadOtherPrefab(prefab1,prefab2,callback2,data)
        end)
    end)

    if callBack then
        callBack()
    end
end

function JokerRemoteBombEnterEffect:CoroutineLoadOtherPrefab(prefab1,prefab2,callback2,data)
    coroutine.start(function()
        if prefab2 then
            if data and data.cardPowerUpEffect  then
                for i = 1, #data.cardPowerUpEffect do
                    local instance = fun.get_instance(prefab2)
                    fun.set_active(instance,false)
                    if callback2 then
                        callback2(instance,"clowndaoju_Dilei")
                    end
                    WaitForEndOfFrame()
                end
            end
        end
        if prefab1 then
            if data and data.cardPowerUpEffect  then
                for i = 1, #data.cardPowerUpEffect do
                    if data.cardPowerUpEffect[i].extraPos then
                        for m = 1, #data.cardPowerUpEffect[i].extraPos do
                            local instance = fun.get_instance(prefab1)
                            if callback2 then
                                callback2(instance,"clown_Dilei")
                            end
                            WaitForEndOfFrame()
                        end
                    end
                end
            end
        end
        WaitForEndOfFrame()
        Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
            if prefab and data and data.cardPowerUpEffect  then
                    for i = 1, #data.cardPowerUpEffect do
                        local instance = fun.get_instance(prefab)
                        fun.set_active(instance,false)
                        if callback2 then
                            callback2(instance,"clowndaoju_Dilei")
                        end
                        WaitForEndOfFrame()
                end
            end
        end)
    end)
end

return this