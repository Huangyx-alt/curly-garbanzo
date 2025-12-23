---未读已领

MailItemNReadAGetState = Clazz(MailItemBaseState,"MailItemNReadAGetState")

function MailItemNReadAGetState:OnEnter(fsm)
    fsm:GetOwner():NotReadAlrGet()
end

function MailItemNReadAGetState:OnLeave(fsm)

end

function MailItemNReadAGetState:EnterFinish(fsm)
    --   self:ChangeState(fsm,"PuzzleOriginalState")
end

function MailItemNReadAGetState:OnReadOrGet(fsm) 
    if fsm then 
        fsm:GetOwner():OnReadClick()--阅读事件
    end 
end

function MailItemNReadAGetState:OnWatchAd(fsm) 
    if fsm then 
        fsm:GetOwner():OnWatchAdClick()--阅读事件
    end 
end

function MailItemNReadAGetState:OnFaceBookGet(fsm)
    if fsm then 
        fsm:GetOwner():OnFacebookClick()--faceBook
    end 
end

--强制更新
function MailItemNReadAGetState:OnUpdateGet(fsm)
    if fsm then 
        fsm:GetOwner():OnUpdateClick()--
    end 
end