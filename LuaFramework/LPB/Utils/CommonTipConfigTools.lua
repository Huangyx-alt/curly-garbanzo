--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2020-10-28 19:13:06
]]

local Csv =  require "data/Csv"
CommonTipConfigTools = {}

CommonTipConfigTools.language_choose_type = 
{
    chinese =  "chinese",
    english =  "english",
}

function CommonTipConfigTools:ChangeLanguage(language_type)
    self.language_type = language_type
end

function CommonTipConfigTools:Init()
    local data = Csv.CommonTipConfig 
    self.language_type = CommonTipConfigTools.language_choose_type.english
    self.config_list = {}
    for k,v in pairs(data) do 
        local itemType = v.tip_name 
        if(self.config_list[itemType] ==nil) then 
            self.config_list[itemType] = {}
        end
        for z , w in pairs(CommonTipConfigTools.language_choose_type) do
            local key = CommonTipConfigTools.language_choose_type[z]
            self.config_list[itemType][key] = v[key]
        end
    end
    log.log("提示修改Cc", self.config_list)
end

--[[
    @desc: 获取Machine_ArtConfig内的参数,先找当前机台的,如果当前机台没有,则找base,
    author:{author}
    time:2020-10-28 19:21:28
    --@keyName: 
    @return:
]]
function  CommonTipConfigTools:GetTip(tipName)
    local language_index = self.language_type
    if(self.config_list[tipName] and self.config_list[tipName][language_index])then 
        return self.config_list[tipName][language_index]
    end
    log.r("缺少提示配置, 提示名  ：", tipName, "语言类型:", language_index)
    return ""
end
