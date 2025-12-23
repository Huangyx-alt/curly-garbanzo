---未读未领

MailItemNReadNGetState = Clazz(MailItemBaseState,"MailItemNReadNGetState")

function MailItemNReadNGetState:OnEnter(fsm)
    fsm:GetOwner():NotReadNotGet()
    --切换成未读未领状态
end

function MailItemNReadNGetState:OnLeave(fsm)

end

function MailItemNReadNGetState:EnterFinish(fsm)
 --   self:ChangeState(fsm,"PuzzleOriginalState")
end

function MailItemNReadNGetState:OnReadOrGet(fsm) 
    if fsm then 
        fsm:GetOwner():OnReadClick()--阅读事件
    end 
end

function MailItemNReadNGetState:OnWatchAd(fsm) 
    if fsm then 
        fsm:GetOwner():OnWatchAdClick()--阅读事件
    end 
end

function MailItemNReadNGetState:OnGetReward(fsm) 
    if fsm then 
        fsm:GetOwner():OnGetClick()--阅读事件
    end 
end


function MailItemNReadNGetState:OnFaceBookGet(fsm)
    if fsm then 
        fsm:GetOwner():OnFacebookClick()--faceBook
    end 
end

--强制更新
function MailItemNReadNGetState:OnUpdateGet(fsm)
    if fsm then 
        fsm:GetOwner():OnUpdateClick()--
    end 
end