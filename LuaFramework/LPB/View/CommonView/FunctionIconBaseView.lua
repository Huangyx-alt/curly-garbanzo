
local FunctionIconBaseView = BaseView:New("FunctionIconBaseView")

function FunctionIconBaseView:New(viewName,atlasName)
    local o = {viewName = viewName,atlasName = atlasName}
    self.__index = self
    setmetatable(o,self)
    return o
end

function FunctionIconBaseView:SetFunctionData(data)
    self._functionData = data
end

function FunctionIconBaseView:GetFunctionId()
    if self._functionData then
        return self._functionData.id
    end
    return -1
end

function FunctionIconBaseView:GetFunctionSoleCity()
    if self._functionData then
        return self._functionData.sole_city
    end
end

function FunctionIconBaseView:UpdataShow()

end

function FunctionIconBaseView:OnChangeCity()
    
end

function FunctionIconBaseView:GetPosition()
    if self.go then
        return self.go.transform.position
    end
    return nil
end

function FunctionIconBaseView:GetView()
    if self.go then
        return self.go
    end
    return nil
end

function FunctionIconBaseView:GetTransform()
    if self.go then
        return self.go.transform
    end
end

function FunctionIconBaseView:GetRef()
    if self then
        return self
    end
    return nil
end

function FunctionIconBaseView:IsExpired()
    --需要时可子类重写
    return false
end

function FunctionIconBaseView:IsFunctionOpen()
    --需要时可子类重写
    return true
end

--在第一次加载得时候
function FunctionIconBaseView:IsFunctionOpenCity()
    --需要时可子类重写
    return true
end

--刷新红点
function FunctionIconBaseView:RefreshRedNum()
    --需要时可子类重写
end
function FunctionIconBaseView:OnChangeDouble()

end

function FunctionIconBaseView:OnExitDouble()
    if self.GetAnimation_ExitDouble == nil then
        if self.go then
            log.r(self.go.name .. "  not  OnExitDouble")
        end
    end
    AnimatorPlayHelper.Play(self.anim, self:GetAnimation_ExitDouble(), false, nil)
end

function FunctionIconBaseView:GetAnimation_ExitDouble()
    return "FunctionIconCuisines_doubleout"
end

function FunctionIconBaseView:SetIconManager(manager)
    self.iconManager = manager
end


return FunctionIconBaseView