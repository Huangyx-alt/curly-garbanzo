local BingoPassItemBaseState = require "View/Bingopass/states/BingoPassItemBaseState"
local BingoPassItemMatureState = Clazz(BingoPassItemBaseState,"BingoPassItemMatureState")

function BingoPassItemMatureState:OnEnter(fsm,previous,...)
    local isFree,param = select(1,...)
    if 1 == isFree then
        fsm:GetOwner():PlayFreeMatureAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    elseif 2 == isFree then
        -- body
        fsm:GetOwner():PlayFeeMatureAnima(param)
        fsm:GetOwner():PlayCircleAnima(param)
        fsm:GetOwner():PlayRestAnima(param)
    else
        fsm:GetOwner():PlayBottomMatureAnima(param)
    end  
end

function BingoPassItemMatureState:OnLeave(fsm)
end

function BingoPassItemMatureState:Change2Achieve(fsm,...)
    if fsm then
        self:ChangeState(fsm,"BingoPassItemAchieveState",...)
    end
end

function BingoPassItemMatureState:ClickPassItem(fsm)
    if fsm then
        fsm:GetOwner():on_btn_collect_click()
    end
end

return BingoPassItemMatureState