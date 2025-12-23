
local BaseRedDot = Clazz()

function BaseRedDot:IsContainNode(node)
    return false
end

function BaseRedDot:Check(node,param)

end

function BaseRedDot:Refresh(nodeList,param)

end

function BaseRedDot:SetSingleNodeActive(node,active)
    assert(node ~= nil,"node is nil")
    if not fun.is_null(node.icon) then
        fun.set_active(node.icon,(active == nil and {false} or {active})[1])
    end
end

function BaseRedDot:SetNodeListActive(nodeList,active)
    assert(nodeList ~= nil,"nodeList is nil")
    for key, value in pairs(nodeList) do
        if not fun.is_null(value.icon) then
            fun.set_active(value.icon,(active == nil and {false} or {active})[1])
        end
    end
end

function BaseRedDot:GetInfoByReddotCount(node,keyStr)
    local active = false
    if node.redotCount then
        for key, value in pairs(node.redotCount) do
            if key ~= keyStr then
                active = active or value
            end
        end
    end
    return active
end

function BaseRedDot:SetReddotCountInfo(node,keyStr,value)
    node.redotCount = node.redotCount or {}
    node.redotCount[keyStr] = value
end

return BaseRedDot