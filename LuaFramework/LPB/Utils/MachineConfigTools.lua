--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-10-28 19:13:06
]]

local Csv =  require "data/Csv"
MachineConfigTools = {}

function MachineConfigTools:Init()
    local data = Csv.Machine_ArtConfig

    for k,v in pairs(data) do
        local itemType = v.machine
        if(self[itemType] ==nil) then
            self[itemType] = {}
        end
        local key = v.name
        self[itemType][key] = v.paramer
    end
end

--[[
    @desc: 获取Machine_ArtConfig内的参数,先找当前机台的,如果当前机台没有,则找base,
    author:{author}
    time:2020-10-28 19:21:28
    --@keyName: 
    @return:
]]
function  MachineConfigTools:Get(keyName)
    local machineId = "M"..tostring(ModelList.enterMachineModel.machineId)
    if(self[machineId] and self[machineId][keyName])then
        return self[machineId][keyName]
    end

    if(self["base"] and self["base"][keyName])then
        return self["base"][keyName]
    end
    return nil
end

--MCT = MachineConfigTools