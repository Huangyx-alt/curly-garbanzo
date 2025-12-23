--已读已领
MailItemAReadAGetState = Clazz(MailItemBaseState,"MailItemAReadAGetState")

function MailItemAReadAGetState:OnEnter(fsm)
   fsm:GetOwner():AlrReadAlrGet()
end


function MailItemAReadAGetState:OnLeave(fsm)

end

function MailItemAReadAGetState:EnterFinish(fsm)
    --self:ChangeState(fsm,"PuzzleOriginalState")
end

function MailItemAReadAGetState:OnFaceBookGet(fsm)
    if fsm then 
        fsm:GetOwner():OnFacebookClick()--faceBook
    end 
end