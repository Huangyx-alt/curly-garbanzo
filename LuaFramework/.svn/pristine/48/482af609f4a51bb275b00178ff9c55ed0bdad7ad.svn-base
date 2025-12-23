
local HallMainMiniGameView = require "View/PeripheralSystem/HallMainViewMiniGame/HallMainMiniGameView"
local MiniGamePuzzleView = HallMainMiniGameView:New()
local this = MiniGamePuzzleView

this.auto_bind_ui_items = {
    "progressSlider",
    "title",
    "btn_icon",
    "redPoint",
    "textRedPoint",
    "textProgress",
    "puzzle_reward_tip",
}

function MiniGamePuzzleView:Awake()
    self:on_init()
end

function MiniGamePuzzleView:OnEnable()
    HallMainMiniGameView.OnEnable(self)
    self:UpdatePuzzleRewardTip()
end

function MiniGamePuzzleView:OnClickMiniGame()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.PuzzleView)
end

function MiniGamePuzzleView:RefreshItem()
    self:RefreshRedPoint()
    self.title.text = "PUZZLE"

    local sceneId = ModelList.CityModel:GetCity()
    local curPuzzleData = ModelList.NewPuzzleModel:GetScenePuzzlesData(sceneId)
    if curPuzzleData then
        self.progressSlider.value = curPuzzleData.collectNum / curPuzzleData.puzzleNum
        self.textProgress.text = string.format("%s%s%s", curPuzzleData.collectNum,"/" , curPuzzleData.puzzleNum)
    else
        self.progressSlider.value = 0
        self.textProgress.text = ""
    end
end

function MiniGamePuzzleView:RefreshRedPoint()
    fun.set_active(self.redPoint , false)
end

function MiniGamePuzzleView:OnDestroy()
    self:Close()
end

function MiniGamePuzzleView:GetMiniGameName()
    return "MiniGamePuzzleView"
end

function MiniGamePuzzleView:UpdatePuzzleRewardTip()
    local sceneId = ModelList.CityModel:GetCity()
    local canReward = ModelList.NewPuzzleModel:IsScenePuzzleCanReward(sceneId)
    fun.set_active(self.puzzle_reward_tip, canReward)
end

function MiniGamePuzzleView:OnReceivePuzzleReward()
    self:UpdatePuzzleRewardTip()
end

this.NotifyEnhanceList = {
    notifyName = NotifyName.PuzzleView.ReceivePuzzleReward,func = this.OnReceivePuzzleReward
}

return MiniGamePuzzleView