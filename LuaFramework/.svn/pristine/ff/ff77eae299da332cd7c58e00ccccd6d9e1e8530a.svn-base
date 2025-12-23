local BaseBingoEffect = Clazz(ClazzBase,"BaseBingoEffect")
local this = BaseBingoEffect
BaseBingoEffect.__index = BaseBingoEffect
this.coin_time = {}

function BaseBingoEffect:SetCardView(cardView,cotainer)
    self.cardView = cardView
    self.container = cotainer
    this.coin_time = {}
    self:Init()
end

function BaseBingoEffect:Init(id)

end

function BaseBingoEffect:GetCardView()
    return self.cardView
end

function BaseBingoEffect:GetBingoEffectName(sign,self_bingo)
    local play_name =""
    if self_bingo then
        if sign == 2 then
            play_name = "ef_Bingopcard_click_bingo_show"
        elseif sign == 3 then
            play_name = "ef_Bingopcard_click_jackpot_show_blue"
        end
    else
        if sign == 1 then
            play_name = "bingo_show_red"
        elseif sign == 2 then
            play_name = "bingo_show"
        elseif sign == 3 then
            play_name = "jackpot_show"
        end
    end
    return play_name
end

--达成Bingo后出动效
function BaseBingoEffect:ShowBingoOrJackpot(bingoData, cb)
    for k, v in pairs(bingoData) do
        local mIndex = k
        local needForbidCard, unlockLevel, maxBingoCount = ModelList.BattleModel:GetCurrModel():CheckIsMaxBingo(mIndex)
        needForbidCard = needForbidCard and v.bingo >= maxBingoCount
        if v.jackpot  == 0 then
            --中间默认格子盖章先隐藏
            self.cardView:EnableDefaultOpenCellSign(mIndex, false)
            
            local anima_name, spineCom, spineAnimName = self:GetBingoAnimaName(v.bingo, needForbidCard)
            --Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            --self:CheckTopThreeBingo(v,mIndex)
            self:BingoEffect(mIndex, v.first_num, {
                anima_name = anima_name,
                spineCom = spineCom,
                spineAnimName = spineAnimName,
                needForbidCard = needForbidCard,
                unlockLevel = unlockLevel,
            }, function()
                --默认格子改变盖章效果
                local num = v.bingo > 4 and 4 or v.bingo
                local animName = string.format("bingo0%s", num)
                self.cardView:SetDefaultOpenCell(animName, mIndex, num + 1)

                fun.SafeCall(cb)
            end)
            
            --格子变色
            self.cardView:ChangeCellBgOnBingo(mIndex)
        else
            Event.Brocast(EventName.Box_Bingo_Coins,0)
            self:JackpotEffect(mIndex, "jackpot", "enter", v.first_num, mIndex, cb)
        end
    end
end

function BaseBingoEffect:GetBingoAnimaName(bingoCount, needForbidCard)
    --local cityID = ModelList.BattleModel:GetGameCityPlayID()
    --local cfg = table.find(Csv["new_bingo_reward"], function(k, v)
    --    if v.city_play_id ~= cityID then
    --        return
    --    end
    --    return bingoCount == v.bingo
    --end)
    --bingoCount = cfg and cfg.effects or bingoCount
    
    local anima_name, spineCom, spineAnimName = "bingo", "bingo_spine", "enter"
    if bingoCount == 2 then
        anima_name = needForbidCard and "doublebingo_enter" or "doublebingo"
        spineCom = "doublebingo_spine"
        spineAnimName = needForbidCard and "enter" or "play"
    elseif bingoCount == 3 then
        anima_name = "triplebingo"
        spineCom = "triplebingo_spine"
        spineAnimName = "play"
    elseif bingoCount == 4 then
        anima_name = "quadrabingo"
        spineCom = "quadrabingo_spine"
        spineAnimName = "play"
    elseif bingoCount >= 5 then
        anima_name = "jackpot"
        spineCom = "jackpot_spine"
        spineAnimName = "enter"
    end
    return anima_name, spineCom, spineAnimName
end


--- 显示金币飞特效
function BaseBingoEffect:ShowCoinFlyEffect(mapindex,pos)
    --local time_index = mapindex..UnityEngine.Time.time..#this.coin_time
    --this.coin_time[time_index] = LuaTimer:SetDelayFunction(0.2,function()
    --    if self.cardView then
    --        if ModelList.TournamentModel:CheckOpenTournament() then
    --            self.cardView:IconFlyEffect(mapindex,pos)
    --        else
    --            self.cardView:CoinsFlyEffect(mapindex,pos)
    --        end
    --        if this.coin_time[time_index]  then
    --            LuaTimer:Remove(this.coin_time[time_index] )
    --        end
    --    end
    --end, nil, LuaTimer.TimerType.Battle)
end

function BaseBingoEffect:GetBingoPrefabName()
    --if ModelList.BattleModel.GetIsJokerMachine() then
    --    return "efBingobingoClown"
    --end
    return "BingoEffect"
end

---@see  显示Bingo 特效
function BaseBingoEffect:BingoEffect(cardid, cellIndex, args, cb)
    args = args or {}
    
    local mapObj = self.cardView:GetCardMap(cardid)
    local prefabName = self:GetBingoPrefabName()
    local recycleTime = args.anima_name == "jackpot" and 1.28 or 3
    local callCbDelay = args.anima_name == "jackpot" and 1.28 or 2.25
    
    if args.needForbidCard then
        --达到bingo上限，卡牌禁用，特效不消失
        recycleTime = 0
    end
    
    BattleEffectCache:GetSkillPrefab_BingoBang(cardid, prefabName, mapObj, recycleTime, function(eff1)
        if not IsNull(eff1) then
            UISound.play("bingo_firework")
            
            local anima = fun.get_component(eff1, fun.ANIMATOR)
            if anima then
                anima:Play(args.anima_name)
            end
            
            local refer = fun.get_component(eff1, fun.REFER)
            if not string.is_empty(args.spineAnimName) then
                local spine = refer:Get(args.spineCom)
                if not IsNull(spine) then
                    spine:PlayByName(args.spineAnimName, false)
                    
                    if args.needForbidCard then
                        LuaTimer:SetDelayFunction(1, function()
                            spine:PlayByName("idle", true)
                        end)
                    end
                end
            end

            if args.needForbidCard and args.unlockLevel then
                --local Mask = refer:Get("Mask")
                --fun.set_active(Mask, false)
                
                local UnlockTip = refer:Get("UnlockTip")
                fun.set_active(UnlockTip, true)
                if not IsNull(UnlockTip) then
                    UnlockTip.text = string.format("Unlocks at level %s", args.unlockLevel)
                end
            end
            
            --local cell_obj_pos = self.cardView:GetCardCell(cardid,cellIndex)
            --self:ShowCoinFlyEffect(cardid,cell_obj_pos.transform.position)
            
            LuaTimer:SetDelayFunction(callCbDelay, cb)
        else
            fun.SafeCall(cb)
        end
    end)
end

--显示Jackpot 特效
function BaseBingoEffect:JackpotEffect(mapindex,anima_name,spineAnimName, cellIndex, cardid, cb)
    if not self.cardView:IsCardShowing(tonumber(cardid) ) then return end
    local mapObj = self.cardView:GetCardMap(mapindex)
    local prefabName = self:GetBingoPrefabName()
    BattleEffectCache:GetSkillPrefab_BingoBang(cardid, prefabName, mapObj, 3, function(eff1)
        if not IsNull(eff1) then
            UISound.play("jackpot_firework")
            local anima = fun.get_component(eff1,fun.ANIMATOR)
            if anima then
                anima:Play(anima_name)
            end

            if not string.is_empty(spineAnimName) then
                local refer = fun.get_component(eff1, fun.REFER)
                local spine = refer:Get(string.format("%s_spine", anima_name))
                if not IsNull(spine) then
                    spine:PlayByName(spineAnimName, false)
                end
            end
            
            --self:ShowCoinFlyEffect(mapindex, mapObj.transform.position)
            LuaTimer:SetDelayFunction(2.25, cb)
        else
            fun.SafeCall(cb)
        end
    end)
end

--- 配置bingo特效在BingoEffectContainer内的层级
function BaseBingoEffect:SetBingoSibling(obj)
    local gameType = ModelList.BattleModel:GetGameCityPlayID()
    local bingo_sibling = Csv.GetData("new_game_effect_cache",gameType,"bingo_sibling")
    if bingo_sibling == 2 then
        fun.SetAsFirstSibling(obj)
    elseif bingo_sibling == 1 then
        fun.SetAsLastSibling(obj)
    end
end

--- 前三个bingo.增加BingoFirst效果
function BaseBingoEffect:CheckTopThreeBingo(data,cardId)
    for i = 1, #data.th do
        if data.th[i] == 1 then
            local target = self:GetCardView():GetCardMap(tonumber(cardId))
            --BattleEffectCache:GetSkillPrefabFromCache("BingoFrist",target,nil,3,cardId,0)
            BattleEffectCache:GetPrefabFromCache("BingoFrist",target,function(go)
                if go then
                    Destroy(go,3)
                end
            end,cardId,0)
        elseif  data.th[i] == 2 then
            local target = self:GetCardView():GetCardMap(tonumber(cardId))
            --BattleEffectCache:GetSkillPrefabFromCache("BingoFrist",target,function(obj)
            --    if obj then
            --        local anim = fun.get_component(obj,fun.ANIMATOR)
            --        if anim then
            --            anim:Play("FristBingo2")
            --        end
            --    end
            --end,3,cardId,0)
            BattleEffectCache:GetPrefabFromCache("BingoFrist",target,function(go)
                if go then
                    local anim = fun.get_component(go,fun.ANIMATOR)
                    if anim then
                        anim:Play("FristBingo2")
                    end
                    Destroy(go,3)
                end
            end,cardId,0)
        elseif  data.th[i] == 3 then
            local target = self:GetCardView():GetCardMap(tonumber(cardId))
            BattleEffectCache:GetPrefabFromCache("BingoFrist",target,function(go)
                if go then
                    local anim = fun.get_component(go,fun.ANIMATOR)
                    if anim then
                        anim:Play("FristBingo3")
                    end
                    Destroy(go,3)
                end
            end,cardId,0)
        end
    end
end

function BaseBingoEffect:New(name)
    local o ={name = name}
    setmetatable(o,{__index = BaseBingoEffect})
    return o
end

function BaseBingoEffect:CoutinueSetPool(obj,effectName)
    if obj then
        BattleEffectPool:CreateBattleEffect(effectName,obj)
        obj.gameObject:SetActive(false)
        Destroy(obj)
    end
end

return this