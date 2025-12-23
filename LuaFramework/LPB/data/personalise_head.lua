--auto generate by unity editor
local personalise_head = {
[1] = {1,"b_bingo_head1",0,1,101001,{1}},
[2] = {2,"b_bingo_head2",1,1,101002,{1}},
[3] = {3,"xxl_head02",0,1,101003,{20}},
[4] = {4,"xxl_head01",0,1,101004,{40}},
[5] = {5,"xxl_head03",0,1,101005,{60}}
}

local keys = {id = 1,icon = 2,default_icon = 3,unlock_type = 4,description = 5,unlock_value = 6}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(personalise_head) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return personalise_head
