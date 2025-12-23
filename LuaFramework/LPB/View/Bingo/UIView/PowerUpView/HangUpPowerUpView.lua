

local  GamePowerUpView  = require("View.Bingo.UIView.PowerUpView.GamePowerUpView")
local HangUpPowerUpView = GamePowerUpView:New()
local this = HangUpPowerUpView;

function HangUpPowerUpView.GetModel()

    return ModelList.HangUpModel
end

function HangUpPowerUpView:SetAutoState()
    self.auto_state = true
    fun.set_active(self.btn_auto, false)
    local powerUpCount = ModelList.BattleModel:GetCurrModel():GetPowerUps()
    if #powerUpCount > 0 then
        fun.set_active(self.off, true)
        fun.set_active(self.on, false)
        --fun.set_active(this.btn_power, true)
    end
end
return this