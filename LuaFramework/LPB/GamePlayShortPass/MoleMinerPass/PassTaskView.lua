--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2024-02-29 14:46:44
]]

local base = require "GamePlayShortPass/Base/BaseTaskView"
local PassTaskView = class("PassTaskView",base ) 
local this = PassTaskView
this.viewName = "PassTaskView"
this.atlasName = "MoleMinerPassTaskAtlas"
this.longTaskAtlasName = "MoleMinerPassTaskAtlas"

local buffId = 902602

function PassTaskView:GetBuffId()
    return buffId
end


function PassTaskView:OnEnable(params)
    self:BaseEnable(params)

    if not ModelList.GuideModel:IsGuideComplete(73) then
        ModelList.GuideModel:TriggerPassTaskView(553)
    end
end

return this 