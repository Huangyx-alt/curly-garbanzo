--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-10-28 19:13:06
]]

local Csv =  require "data/Csv"
SystemConfigTools = {}

function SystemConfigTools:Init()
    local data = Csv.System_ArtConfig 
    self.config_list = {}
    for k,v in pairs(data) do 
        local itemType = v.system_name 
        if(self.config_list[itemType] ==nil) then 
            self.config_list[itemType] = {}
        end
        local key = v.type 
        self.config_list[itemType][key] = v.paramer
    end
    log.log("本地配置表修改", self)
end

--[[
    @desc: 获取Machine_ArtConfig内的参数,先找当前机台的,如果当前机台没有,则找base,
    author:{author}
    time:2020-10-28 19:21:28
    --@keyName: 
    @return:
]]
function  SystemConfigTools:Get(systemName, typeName)
    if(self.config_list[systemName] and self.config_list[systemName][typeName])then 
        return self.config_list[systemName][typeName]
    end
    log.r("缺少周边配置, 周边名B  ：", systemName, "类型:", typeName)
    return 0.5
end

SCT = SystemConfigTools