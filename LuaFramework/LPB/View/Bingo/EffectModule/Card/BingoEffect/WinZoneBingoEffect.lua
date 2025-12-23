local BaseBingoEffect = require("View.Bingo.EffectModule.Card.BingoEffect.BaseBingoEffect")

local WinZoneBingoEffect = BaseBingoEffect:New("WinZoneBingoEffect")
local this = WinZoneBingoEffect
setmetatable(WinZoneBingoEffect, BaseBingoEffect)
local private = {}

function WinZoneBingoEffect:ShowBingoOrJackpot(bingoData)
    for k, v in pairs(bingoData) do
        local mIndex = k
        if v.jackpot  == 0 then
            local anima_name = self:GetBingoAnimaName(v.bingo)
            Event.Brocast(EventName.Box_Bingo_Coins, v.bingo)
            self:CheckTopThreeBingo(v,mIndex)
            self:BingoEffect(mIndex, anima_name, v.first_num, mIndex)
        else
            Event.Brocast(EventName.Box_Bingo_Coins,0)
            self:JackpotEffect(mIndex, "victorybingo", v.first_num, mIndex)
        end
        private.PlayBingoAudio(v.jackpot == 0)
    end
end

function WinZoneBingoEffect:GetBingoAnimaName(bingoCount)
    return "bingo"
end

---------------------------------------------------------------
function private.PlayBingoAudio(isBingo)
    if isBingo then
        UISound.play("Bingo")
    else
        UISound.play("winzoneVictorybingo")
    end
end

return this