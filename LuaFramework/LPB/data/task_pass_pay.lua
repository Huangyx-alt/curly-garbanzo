--auto generate by unity editor
local task_pass_pay = {
[1] = {1,{"0","12","13","14","18","19","20","36","37","38","39","40","53","54","55"},2.99,53,{10,240},"task_pass_2.99",1100},
[2] = {2,{"21","22","56","57"},4.99,54,{10,400},"task_pass_4.99",800},
[3] = {3,{"23","24","25","26","27","28","29","30","31","32","33","34","35","58","59","60","61","62","63","64","65","66","67","68","69","70"},7.99,55,{10,640},"task_pass_7.99",650},
}

local keys = {id = 1,user_type_bi = 2,price_1 = 3,product1_id = 4,price_1_item = 5,cehuakan_1 = 6,bonus = 7}
local mt = {
            __index = function(t, k)
                local id = keys[k]
                if id then 
                    return t[id] 
                end 
                return nil
            end
        }
        for _, t in pairs(task_pass_pay) do
            setmetatable(t, mt)
        end
        mt.__metatable = false

return task_pass_pay
