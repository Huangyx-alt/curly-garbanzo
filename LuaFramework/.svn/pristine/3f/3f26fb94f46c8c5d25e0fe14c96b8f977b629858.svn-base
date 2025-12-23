--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]


local BaseTaskDataComponent = class("BaseTaskDataComponent")
local this = BaseTaskDataComponent

 
function BaseTaskDataComponent:ctor(id)
    self.id = id 
end

function BaseTaskDataComponent:UpdateData(data)
    self.data = data 
end

function BaseTaskDataComponent:UpdateOneTaskData(data)
    if self.data and data then
        for i = 1, #self.data do
            for k = 1, #data do
                if self.data[i].taskId == data[k].taskId then
                    self.data[i] = data[k]
                end
            end
        end
    end
end


function BaseTaskDataComponent:HasReward()
    --TODO
    return false 
end


return BaseTaskDataComponent