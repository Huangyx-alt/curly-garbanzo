HangUpBetView = BaseChildView:New();
local this = HangUpBetView;

this.parentObj = nil
this.parent = nil


function HangUpBetView:Init(parent_obj,bingoView)
    this:on_init(parent_obj)
    --[[local rate = ModelList.CityModel:GetBetRate()
    if rate and rate> 1 then
        bingoView.GoldRate.text = tostring(rate).."X"
        bingoView.DiamondRate.text = tostring(rate).."X"
    else
        fun.set_active(bingoView.GoldRate.transform.parent.gameObject,false)
    end
    --]]
    --fun.set_active(bingoView.GoldRate.transform.parent.gameObject,false)
end



function HangUpBetView:on_x_update()

end

return this