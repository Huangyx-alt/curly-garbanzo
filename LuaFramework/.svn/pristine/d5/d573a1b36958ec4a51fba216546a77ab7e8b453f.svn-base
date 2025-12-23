local base = require "GamePlayShortPass/Base/BaseTaskView"
local PassTaskView = class("PassTaskView", base) 
local this = PassTaskView
this.viewName = "PassTaskView"
--- flag:短令牌 每次增加新的短令牌都要修改
local buffId = 903202

this.atlasName = "GotYouPassTaskAtlas"
this.longTaskAtlasName = "GotYouPassTaskAtlas"

function PassTaskView:GetBuffId()
    return buffId
end

function PassTaskView:OnEnable(params)
    self:BaseEnable(params)
    --- flag:短令牌 每次增加新的短令牌都要修改
    if not ModelList.GuideModel:IsGuideComplete(88) then
        ModelList.GuideModel:TriggerPassTaskView(594)
    end
end

return this