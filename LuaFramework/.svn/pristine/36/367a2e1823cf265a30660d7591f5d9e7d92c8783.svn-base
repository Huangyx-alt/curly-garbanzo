local ClubMessageBaseItem = BaseView:New()

function ClubMessageBaseItem:Updata()
    log.r("error !!!!!!")
end

function ClubMessageBaseItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end

--子类复写
function ClubMessageBaseItem:UpdateTime()

end 

--展示动画 子类复写
function ClubMessageBaseItem:ShowAnima()

end

--判断是否可以领取 
function ClubMessageBaseItem:CanGetReward()
    return false 
end

return ClubMessageBaseItem 