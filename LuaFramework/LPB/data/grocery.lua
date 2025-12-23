--auto generate by unity editor
local grocery = {
[1] = {1,1,5,{0,1,2,3},{{3,1800},{10,160}},0,"1.99",0,1,0,3,"1",32,"powerup_hint"},
[2] = {2,2,0,{0,1,2,3},{{15,1800},{10,400}},0,"4.99",0,0,0,3,"1",34,"minigame_hat_1"},
[3] = {3,2,0,{0,1,2,3},{{16,3600},{10,400}},0,"4.99",0,0,0,3,"1",34,"minigame_hat_2"},
}

local keys = {id = 1,location = 2,level = 3,user_label = 4,item = 5,original_price = 6,price = 7,frequency = 8,frequency_type = 9,frequency_cd = 10,buy_cd = 11,icon = 12,product_id = 13,cehuakan = 14}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(grocery) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return grocery
