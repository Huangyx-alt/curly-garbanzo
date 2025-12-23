local base = require "GamePlayShortPass/Base/BaseTaskView"
local PassTaskView = class("PassTaskView", base) 
local this = PassTaskView
this.viewName = "PassTaskView"
--- flag:短令牌 每次增加新的短令牌都要修改
local buffId = 903302

this.atlasName = "LetemRollPassTaskAtlas"
this.longTaskAtlasName = "LetemRollPassTaskAtlas"
this.longTaskIconScale = { x = 1, y = 0.9 }

function PassTaskView:GetBuffId()
    return buffId
end

function PassTaskView:OnEnable(params)
    self:BaseEnable(params)
    --- flag:短令牌 每次增加新的短令牌都要修改
    if not ModelList.GuideModel:IsGuideComplete(90) then
        ModelList.GuideModel:TriggerPassTaskView(600)
    end
end

return this
