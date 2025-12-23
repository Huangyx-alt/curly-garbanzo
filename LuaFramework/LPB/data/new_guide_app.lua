--auto generate by unity editor
local new_guide_app = {
}

local keys = {id = 1,view = 2,path = 3,startcondition = 4,param = 5,delay_time = 6,form = 7,contentparam = 8,content = 9,open_level = 10,end_level = 11,priority = 12,string_view = 13}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(new_guide_app) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return new_guide_app
