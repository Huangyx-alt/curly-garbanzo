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
--- flag:短令牌 每次增加新的短令牌都要修改
local buffId = 902902

this.atlasName = "ScratchWinnerPassTaskAtlas"
this.longTaskAtlasName = "ScratchWinnerPassTaskAtlas"

function PassTaskView:GetBuffId()
    return buffId
end


function PassTaskView:OnEnable(params)
    self:BaseEnable(params)
    --- flag:短令牌 每次增加新的短令牌都要修改
    if not ModelList.GuideModel:IsGuideComplete(83) then
        ModelList.GuideModel:TriggerPassTaskView(578)
    end
end

return this 
