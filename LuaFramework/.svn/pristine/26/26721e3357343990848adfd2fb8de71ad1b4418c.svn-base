
TournamentSettleFlyScoreView = BaseView:New("TournamentSettleFlyScoreView")
local this = TournamentSettleFlyScoreView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog

this.auto_bind_ui_items = {
    "anima",
    "text_rewards"
}

function TournamentSettleFlyScoreView:Awake(obj)
    self:on_init()
end

function TournamentSettleFlyScoreView:OnEnable(params)
    self._init = true
    self:ReBindImg()
    self:PlayFlyScore(self._callback)
end

--- ′|àíò???μ?í??êìa
function TournamentSettleFlyScoreView:ReBindImg()
    --if self.go then
    --    local img =  fun.find_child(self.go,"ZBTmJbtb")
    --    if img then
    --        local icon = fun.get_component(img,fun.IMAGE)
    --        if icon then
    --            icon.sprite = AtlasManager:GetSpriteByName("TournamentAtlas", "ZBTmJbtb")
    --        end
    --    end
    --end
end

function TournamentSettleFlyScoreView:OnDisable()
    self._callback = nil
    self._init = nil
end

function TournamentSettleFlyScoreView:PlayFlyScore(callback,score)
    self._callback = callback
    if self._init then
        self.text_rewards.text = fun.NumInsertComma(score or 100000)
        AnimatorPlayHelper.Play(self.anima,{"TournamentSettleViewgo","TournamentSettleViewgo"},false,function()
            if self._callback then
                self._callback()
            end
        end)
    end
end

return this