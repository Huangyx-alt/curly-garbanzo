local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local ChristmasSynthesisBingoEffect = BaseBingoEffect:New("ChristmasSynthesisBingoEffect")
local this = ChristmasSynthesisBingoEffect
setmetatable(ChristmasSynthesisBingoEffect, BaseBingoEffect)




---@see  显示Bingo 特效
function ChristmasSynthesisBingoEffect:BingoEffect(mapindex, anima_name, cellIndex, cardid)
    if not self.cardView:IsCardShowing(tonumber(cardid)) then
        Event.Brocast(EventName.Event_Show_SwitchView_Small_Card_Bingo, cardid)
        local cell_obj_pos = self.cardView:GetCardCell(mapindex, cellIndex)
        self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
        return
    end
    local par = self.cardView:GetCardMap(mapindex)
    local pos = par.transform.position
    BattleEffectCache:GetPrefabFromPoolOrCache(self:GetBingoPrefabName(), par, function (eff1)
        if eff1 then
            eff1.gameObject:SetActive(false)
            UISound.play("bingo_firework")
            fun.set_gameobject_pos(eff1, pos.x, pos.y, pos.z, false)
            eff1.gameObject:SetActive(true)
            local anima = fun.get_component(eff1, fun.ANIMATOR)
            if anima then
                anima:Play(anima_name)
            end
            local cell_obj_pos = self.cardView:GetCardCell(mapindex, cellIndex)
            self:ShowCoinFlyEffect(mapindex, cell_obj_pos.transform.position)
            local prefabName = self:GetBingoPrefabName()
            BattleEffectPool:DelayRecycle(prefabName, eff1, 3)
            --Destroy(eff1,3)
        else
            log.r("hangup_bingo  null")
        end
    end, cardid)
end

function ChristmasSynthesisBingoEffect:GetBingoPrefabName()
    if ModelList.BattleModel.GetIsJokerMachine() then
        return "ChristmasSynthesisBingobingo"
    end
    return "ChristmasSynthesisBingobingo"
end

return this
