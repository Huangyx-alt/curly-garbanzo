
AdventurePickWaitState = Clazz(BaseAdventureState,"AdventurePickWaitState")

function AdventurePickWaitState:OnEnter(fsm,previous,...)
    self._cup_index = ...
    self._markTime = os.time()
    fsm:GetOwner():AskServerToPickCup()
end

function AdventurePickWaitState:OnLeave(fsm)

end

function AdventurePickWaitState:DoPickResult(fsm)
    if fsm then
        self:ChangeState(fsm,"AdventureDrawCupState",self._cup_index)
    end
end

function AdventurePickWaitState:DoPick(fsm,params)
    if os.time() - self._markTime >= 3 then
        self._markTime = os.time()
        fsm:GetOwner():AskServerToPickCup()
    end
end