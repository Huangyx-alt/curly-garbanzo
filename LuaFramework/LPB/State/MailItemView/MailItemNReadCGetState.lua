-- 未读 不用领

MailItemNReadCGetState = Clazz(MailItemBaseState,"MailItemNReadCGetState")

function MailItemNReadCGetState:OnEnter(fsm)
    fsm:GetOwner():NotReadCGet()
end

function MailItemNReadCGetState:OnLeave(fsm)

end

function MailItemNReadCGetState:EnterFinish(fsm)
 --   self:ChangeState(fsm,"PuzzleOriginalState")
end


function MailItemNReadCGetState:OnReadOrGet(fsm) 
    if fsm then 
        fsm:GetOwner():OnReadClick()--阅读事件
    end 
end

function MailItemNReadCGetState:OnWatchAd(fsm) 
    if fsm then 
        fsm:GetOwner():OnWatchAdClick()--阅读事件
    end 
end

function MailItemNReadCGetState:OnGetReward(fsm) 
    if fsm then 
        fsm:GetOwner():OnGetClick()--直接领取
    end 
end

function MailItemNReadCGetState:OnFaceBookGet(fsm)
    if fsm then 
        fsm:GetOwner():OnFacebookClick()--faceBook
    end 
end

--强制更新
function MailItemNReadCGetState:OnUpdateGet(fsm)
    if fsm then 
        fsm:GetOwner():OnUpdateClick()--
    end 
end