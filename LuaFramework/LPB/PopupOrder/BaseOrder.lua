
local BaseOrder = Clazz()

function BaseOrder.Execute()

end

function BaseOrder.NotifyCurrentOrderFinish()
    Event.Brocast(EventName.Event_popup_order_finish,true)
end

--- 是否当前order执行完毕就提前结束剩余popup
function BaseOrder.IsPreOrderFinish()
    return false
end

--- 是否当前order执行完毕就提前结束剩余popup
function BaseOrder.IsAllowPop(popKey, data)
    if data then
        if data.pop_cd then
            local lastPopTime = fun.read_value(popKey,0)
            if  os.time() - lastPopTime < data.pop_cd then
                return false
            end
        end
        if data.pop_times then
            local popTimes = fun.read_value(popKey.."_popcount",0)
            if popTimes >= data.pop_times then
                return false
            end
        end
    end
    return true
end


---刷新弹出次数和时间
---@param popKey string 保存的key
---@param data table windows表的数据
---@param cdType number 1:当前时间 2:当前时间+cd
function BaseOrder.RefreshPopTime(popKey, data,cdType)
    if data then
        if data.pop_cd then
            if not cdType then cdType = 1 end
            fun.save_value(popKey,  cdType ==1 and os.time() or os.time()+data.pop_cd)
        end
        if data.pop_times then
            local popTimes = fun.read_value(popKey.."_popcount",0)
            fun.save_value(popKey.."_popcount",popTimes+1);
        end
    end
end

---刷新弹出的日期
---@param popKey string 保存的key
---@param data table windows表的数据
---@param cdType number 1:当前时间 2:当前时间+cd
function BaseOrder.RefreshPopDay(popKey)
    if popKey then
        local currentDate = os.date("%Y-%m-%d")
        fun.save_value(popKey,tostring(currentDate))
    end
end

return BaseOrder
