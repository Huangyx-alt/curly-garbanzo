require "Logic/Fsm/BaseFsmState"
MailItemBaseState = Clazz(BaseFsmState,"MailItemBaseState")

function MailItemBaseState:PlayEnter(fsm)
    
end


function MailItemBaseState:EnterFinish(fsm)
    
end

--阅读或者领取
function MailItemBaseState:OnReadOrGet(fsm) 
    
end

--阅读或者领取
function MailItemBaseState:OnRead(fsm) 
    
end

--观看广告
function MailItemBaseState:OnWatchAd(fsm) 
    
end

--直接领取奖励
function MailItemBaseState:OnGetReward(fsm) 

end

--faceBook领取奖励
function MailItemBaseState:OnFaceBookGet(fsm) 

end

--强制更新
function MailItemBaseState:OnUpdateGet(fsm)
    
end