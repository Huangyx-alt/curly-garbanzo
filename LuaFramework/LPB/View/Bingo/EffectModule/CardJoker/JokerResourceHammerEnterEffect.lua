---- 小丑卡 资源锤 入场效果

local JokerThrowItemEffect = require("View.Bingo.EffectModule.CardJoker.JokerThrowItemEffect")

local JokerResourceHammerEnterEffect = CreateInstance_(JokerThrowItemEffect, "JokerResourceHammerEnterEffect")
local this = JokerResourceHammerEnterEffect

local BoomPosOffset = {x = -48.5, y = 48.5, z = 0}
local BoomScale = {x = 1, y = 1, z = 1}
local clowndaoju_getxiaoEffect = nil

function JokerResourceHammerEnterEffect:SetInfo(info, parentObj,parentRef)
    self.data = info
    local obj = parentRef:GetPreloadPrefab("clowndaoju_5ge")
    if obj then
        fun.set_parent(obj, parentObj, true)
        self.go = obj
    else
        Cache.load_prefabs(AssetList["clowndaoju_5ge"], "clowndaoju_5ge", function(prefab)
            if prefab then
                local obj = fun.get_instance(prefab)
                if obj then
                    fun.set_parent(obj, parentObj, true)
                    self.go = obj
                end
            end
        end)
    end
    clowndaoju_getxiaoEffect = parentRef:GetPreloadPrefab("clowndaoju_getxiao")
end


function JokerResourceHammerEnterEffect:SetIcon()
    self.data.powerUpId = 623

    local iconName = Csv.GetData("new_powerup", self.data.powerUpId, "icon")
    local refScript = fun.get_component(self.go, fun.REFER)
    if refScript then
        local flyImg = refScript:Get("fei" .. 1)
        if flyImg then
            Cache.SetImageSprite("GameItemAtlas", iconName, flyImg)
        end

        for i = 2, 4 do
            if flyImg then
                fun.set_active(refScript:Get("fei" .. i), false)
            end
        end
    end
end

function JokerResourceHammerEnterEffect:Fly()
    local refScript = fun.get_component(self.go, fun.REFER)
    if refScript then
        local flyImg = refScript:Get("fei1")

        -- 飞资源锤
        table.each(self.data.cardPowerUpEffect, function(cardPowerUpEffect)
            local clientPos = ConvertServerPos(cardPowerUpEffect.posList[1])
            --设置格子数据
            self:SetCellChange(cardPowerUpEffect.cardId, clientPos, 6, cardPowerUpEffect.extraPos)

            --clone
            local obj = fun.get_instance(flyImg.gameObject, flyImg.gameObject.transform.parent)
            local targetCell = self:GetJokerCellObj(cardPowerUpEffect.cardId, clientPos)

            fun.set_parent(obj, targetCell.transform)
            Anim.move(obj, 0, 0, 0, 0.6, true, 1, function()
                fun.set_alpha(obj, 0.2)
                self:PlayEffect(targetCell, cardPowerUpEffect)
            end)
            Anim.scale(obj, BoomScale.x, BoomScale.y, BoomScale.z, 1, true)
        end)

        fun.set_active(flyImg.gameObject, false)
        self:PlayOver()
    end
end

function JokerResourceHammerEnterEffect:PlayEffect(targetCell, cardPowerUpEffect)
    if fun.is_not_null(clowndaoju_getxiaoEffect) then
        if  targetCell then
            fun.set_parent(clowndaoju_getxiaoEffect, targetCell.transform, true)
            fun.set_active(clowndaoju_getxiaoEffect, true)
        end
        Destroy(clowndaoju_getxiaoEffect, 2)
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
end

function JokerResourceHammerEnterEffect:PlayOver()
    Destroy(self.go, 0.2)
end

---预加载依赖的资源
function JokerResourceHammerEnterEffect:PreloadDependResource(callBack,callback2,index)
    --Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
    --    if callBack then
    --        callBack()
    --    end
    --end)

    this:CoroutineLoadResource(function()
        --coroutine.wait(index)
        Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
            if prefab then
                local instance = fun.get_instance(prefab)
                log.r("instance clowndaoju_getxiao")
                if callback2 then
                    callback2(instance,"clowndaoju_getxiao")
                end
            end
        end)
        --WaitForFixedUpdate()
        Cache.load_prefabs(AssetList["clowndaoju_5ge"], "clowndaoju_5ge", function(prefab)
            if prefab then
                local instance = fun.get_instance(prefab)
                --log.r("instance clowndaoju_5ge")
                if callback2 then
                    callback2(instance,"clowndaoju_5ge")
                end
            end
        end)
        if callBack then
            callBack()
        end
    end)


end

return this