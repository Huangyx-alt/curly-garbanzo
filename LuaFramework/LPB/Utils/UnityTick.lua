require "event"

UnityTick = {}


function UnityTick.init()

end

function UnityTick.update_tick_add(fun,obj)
    local r = UpdateBeat:CreateListener(fun,obj)
    UpdateBeat:AddListener(r)
    return r
end

function UnityTick.fixed_update_tick_add(fun,obj)
    local r = FixedUpdateBeat:CreateListener(fun,obj)
    FixedUpdateBeat:AddListener(r)
    return r
end

function UnityTick.later_update_tick_add(fun,obj)
    local r = LateUpdateBeat:CreateListener(fun,obj)
    LateUpdateBeat:AddListener(r)
    return r
end

function UnityTick.update_tick_remove(handler)
    UpdateBeat:RemoveListener(handler)
end

function UnityTick.fixed_update_tick_remove(handler)
    FixedUpdateBeat:RemoveListener(handler)
end

function UnityTick.later_update_tick_remove(handler)
    LateUpdateBeat:RemoveListener(handler)
end
