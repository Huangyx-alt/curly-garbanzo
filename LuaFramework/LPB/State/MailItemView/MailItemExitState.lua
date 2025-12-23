
MailItemExitState = Clazz(MailItemBaseState,"MailItemExitState")

function MailItemExitState:OnEnter(fsm)
  --  fsm:GetOwner():PlayEnter()
end

function MailItemExitState:OnLeave(fsm)

end

function MailItemExitState:EnterFinish(fsm)
  --  self:ChangeState(fsm,"PuzzleOriginalState")
end