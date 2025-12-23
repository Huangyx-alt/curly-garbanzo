--已读不用领
MailItemAReadCGetState = Clazz(MailItemBaseState,"MailItemAReadCGetState")

function MailItemAReadCGetState:OnEnter(fsm)
    fsm:GetOwner():AlrReadCGet()
end


function MailItemAReadCGetState:OnLeave(fsm)

end

function MailItemAReadCGetState:EnterFinish(fsm)
    --self:ChangeState(fsm,"PuzzleOriginalState")
end

function MailItemAReadCGetState:OnReadOrGet(fsm) 
    if fsm then 
        fsm:GetOwner():OnGetClick()--阅读事件
    end 
end

function MailItemAReadCGetState:OnGetReward(fsm) 
    if fsm then 
        fsm:GetOwner():OnGetClick()--直接领取
    end 
end

function MailItemAReadCGetState:OnFaceBookGet(fsm)
    if fsm then 
        fsm:GetOwner():OnFacebookClick()--faceBook
    end 
end

--强制更新
function MailItemAReadCGetState:OnUpdateGet(fsm)
    if fsm then 
        fsm:GetOwner():OnUpdateClick()--
    end 
end