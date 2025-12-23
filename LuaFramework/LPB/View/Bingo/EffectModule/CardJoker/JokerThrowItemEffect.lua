---- 小丑投放道具入场效果

local BaseCardJokerEffect = require("View.Bingo.EffectModule.CardJoker.BaseCardJokerEffect")

local JokerThrowItemEffect = BaseCardJokerEffect:New()
local this = JokerThrowItemEffect

function JokerThrowItemEffect:New()
    local o = { isLoaded = false, changeSceneClear = true }
    self.__index = self
    setmetatable(o, self)
    return o
end

---基类继承
function JokerThrowItemEffect:SetInfo(info, parentObj,parentRef)
    self.data = info
    self._parentRef = parentRef
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
end

--- 播放小丑区域入场效果
function JokerThrowItemEffect:Play()
    self:SetIcon()
    fun.set_active(self.go, true)
    LuaTimer:SetDelayFunction(1, function()
        self:Fly()
    end)
end

--local sortTypeList = {}

function JokerThrowItemEffect:SetIcon()
    self.sortTypeList = {}
    local refScript = fun.get_component(self.go, fun.REFER)
    for k = 1, #self.data.itemIds do
        if not fun.is_include(self.data.itemIds[k], self.sortTypeList) then
            table.insert(self.sortTypeList, self.data.itemIds[k])
        end
    end

    if refScript then
        local count = #self.sortTypeList
        for k = 1, count do
            local flyImg = refScript:Get("fei" .. k)
            if flyImg then
                local iconName = self:GetIconName(self.sortTypeList[k])
                --local item_type = Csv.GetData("item",sortTypeList[k],"item_type")
                --local clientPos = ConvertServerPos(self.data.cardPowerUpEffect[k].posList[1])
                --local targetCell = self:GetCellObj(self.data.cardPowerUpEffect[k].cardId, clientPos)
                Cache.SetImageSprite("GameItemAtlas", iconName, flyImg)
                --self.model:SetRoundGiftData(self.data.cardPowerUpEffect[k].cardId, clientPos, self.data.itemIds[k], 0, 0, 1)
                --self:AddGiftToCell(targetCell,iconName,flyImg.gameObject,item_type,
                --        self.data.cardPowerUpEffect[k].cardId,clientPos)
                if count == 1 then
                    fun.set_rect_local_pos(flyImg, 0, 0, 0)
                end
            end
        end
        for i = count + 1, 4 do
            local flyImg = refScript:Get("fei" .. i)
            log.r("flyImg   "..i.."    false")
            if flyImg then
                fun.set_active(flyImg.gameObject, false)
            end
        end
    end
end

function JokerThrowItemEffect:Fly()
    --local firstPos = self.data.cardPowerUpEffect[1].posList[1]
    --local clientPos = ConvertServerPos(firstPos)
    --for i = 1, #self.data.cardPowerUpEffect[1].posList do
    --    self:SetCellChange(self.data.cardPowerUpEffect[1].cardId,self.data.cardPowerUpEffect[1].posList[i],2,clientPos)
    --end

    local refScript = fun.get_component(self.go, fun.REFER)
    if refScript then
        for k = 1, #self.data.itemIds do
            local flyImg = refScript:Get("fei" .. k)
            for i = 1, #self.sortTypeList do
                if self.sortTypeList[i] == self.data.itemIds[k] then
                    local fly = fun.get_instance(refScript:Get("fei" .. i).gameObject, refScript:Get("fei" .. i).gameObject.transform.parent)
                    flyImg = fun.get_component(fly, fun.IMAGE)
                    break
                end
            end
            if flyImg then
                local iconName = self:GetIconName(self.data.itemIds[k])
                local item_type = Csv.GetData("item", self.data.itemIds[k], "item_type")
                local clientPos = ConvertServerPos(self.data.cardPowerUpEffect[k].posList[1])
                local targetCell = self:GetCellObj(self.data.cardPowerUpEffect[k].cardId, clientPos)
                --Cache.SetImageSprite("GameItemAtlas",iconName,flyImg )
                self.model:SetRoundGiftData(self.data.cardPowerUpEffect[k].cardId, clientPos, self.data.itemIds[k], 0, 0, 0)
                self.model:GetRoundData(self.data.cardPowerUpEffect[k].cardId, clientPos):SetJokerChange(1, self.data.itemIds[k])
                self:AddGiftToCell(targetCell, iconName, flyImg.gameObject, item_type,
                        self.data.cardPowerUpEffect[k].cardId, clientPos)
            end
        end
    end
    for k = 1, #self.data.itemIds do
        if refScript then
            local flyImg = refScript:Get("fei" .. k)
            if flyImg then
                fun.set_active(flyImg.gameObject, false)
            end
        end
    end
    self:PlayOver()
end

function JokerThrowItemEffect:PlayEffect(targetCell)
    local obj = nil
    if self and self._parentRef then
        obj =  self:GetLoadedResource("clowndaoju_getxiao",self._parentRef,"clowndaoju_getxiao")
    end
    if obj and targetCell then
        fun.set_parent(obj, targetCell.transform, true)
        fun.set_active(obj, true)
        Destroy(obj, 2)
    end

    --Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
    --    if prefab then
    --        local obj = fun.get_instance(prefab)
    --        if obj and targetCell then
    --            fun.set_parent(obj, targetCell.transform, true)
    --            fun.set_active(obj, true)
    --            Destroy(obj, 2)
    --        end
    --    end
    --end)
end

function JokerThrowItemEffect:AddGiftToCell(target, iconName, flyObj, item_type, cardId, cellIndex)
    --for i = 1, #self.data.cardPowerUpEffect[1].posList do
    --    local clientPos = ConvertServerPos(self.data.cardPowerUpEffect[1].posList[i]    )
    --    local  JokerBg = self:GetJokerCellObj(self.data.cardPowerUpEffect[1].cardId, clientPos,"JokerBg")
    --    if JokerBg then
    --        if JokerBg then
    --            JokerBg.sprite =  AtlasManager:GetSpriteByName("JokerBattleAtlas","bcardRainbow")
    --            fun.set_active(JokerBg.gameObject,true)
    --        end
    --    end
    --end

    Event.Brocast(EventName.CardItem_Cell_Add_Item, target, iconName, flyObj, item_type, cardId, function()
        --CalculateBingoMachine.CalculateWishByCard(cardId)
        self:PlayEffect(target)
    end, true)


end

function JokerThrowItemEffect:PlayOver()
    Destroy(self.go, 5)
    log.r("JokerThrowItemEffect:PlayOver")
end

---预加载依赖的资源
function JokerThrowItemEffect:PreloadDependResource(callBack,callback2,index,data)
    Cache.load_prefabs(AssetList["clowndaoju_5ge"], "clowndaoju_5ge", function(prefab)
        if prefab then
            local instance = fun.get_instance(prefab)
            log.r("instance clowndaoju_5ge")
            if callback2 then
                callback2(instance,"clowndaoju_5ge")
            end
        end
    end)
    Cache.load_prefabs(AssetList["clowndaoju_getxiao"], "clowndaoju_getxiao", function(prefab)
        for i = 1, #data.itemIds do
            local instance = fun.get_instance(prefab)
            fun.set_active(instance,false)
            if callback2 then
                callback2(instance,"clowndaoju_getxiao")
            end
        end
    end)
    if callBack then
        callBack()
    end
end

function JokerThrowItemEffect:GetIconName(itemID)
    local puLevel = Csv.GetData("new_powerup", self.data.powerUpId, "level")
    local result = Csv.GetItemOrResource(itemID, "result")
    local iconName = Csv.GetData("item", itemID, "icon")
    --周榜还是名人堂
    if result[1] == 29 then
        if ModelList.HallofFameModel:IsActivityAvailable() then
            if puLevel == 1 then
                iconName = "PowerupJokeIcon029"
            else
                iconName = "PowerupJokeIcon030"
            end
        elseif ModelList.TournamentModel:IsActivityAvailable() then
            if puLevel == 1 then
                iconName = "PowerupJokeIcon22"
            else
                iconName = "PowerupJokeIcon14"
            end
        end
    end
    return iconName
end

return this