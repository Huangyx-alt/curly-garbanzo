
local PuzzleViewBigReward = BaseView:New()
local this = PuzzleViewBigReward
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "icon_reward1",
    "icon_reward2",
    "icon_reward3",
    "text_reward1",
    "text_reward2",
    "text_reward3",
    "text_rate",
    "text_rate_light",
    "anima",
    "rewardstar",

    "puzzle1Rewards",
    "glow",
    "bg_mask",
    "pPuzzleJtJd06kuang",
    "pPuzzleJtJdi",
    "pPuzzleReward",
    "pPuzzleReward2",
    "cgoaljddiJia",
    "pPuzzleRewardstar",

}

function PuzzleViewBigReward:New(rewardCount)
    local o = {}
    self.__index = self
    setmetatable(o,self)
    o._rewardCount = rewardCount
    return o
end

function PuzzleViewBigReward:Awake()
    self:on_init()
end

function PuzzleViewBigReward:OnEnable()
    self:RefreshInfo()
    self:ReBindImg()
end

function PuzzleViewBigReward:OnDisable()
end

function PuzzleViewBigReward:Destroy()
    self:Close()
end

function PuzzleViewBigReward:GetBigRewardPos()
    if self.rewardstar then
        return self.rewardstar.position
    end
    return Vector3.New(0,0,0)
end

function PuzzleViewBigReward:PlayBingRewardRaw(callback)
    AnimatorPlayHelper.Play(self.anima,{"idle","rewardBox_bigwin_idle"},false,callback)
end

function PuzzleViewBigReward:PlayBigRewardPosed(callback)
    AnimatorPlayHelper.Play(self.anima,{"ram","rewardBox_bigwin_ram"},false,0.5,function()
        self:RefreshInfo()--服务端还没来得及刷新，要强制刷新一下
    end,function()
        if callback then
            callback()
        end
    end)
end

function PuzzleViewBigReward:PlayBigRwardMature(callback)
    AnimatorPlayHelper.Play(self.anima,{"collect","rewardBox_bigwin_collect"},false,callback)
end

function PuzzleViewBigReward:CheckRewardCount(count)
    return self._rewardCount == count
end

function PuzzleViewBigReward:RefreshInfo(rewardRate)
    local rewards = ModelList.PuzzleModel:GetPuzzleStageReward()
    for index, value in ipairs(rewards) do
        local spName = Csv.GetItemOrResource(value.id,"more_icon")
        if spName then
            Cache.SetImageSprite("ItemAtlas",spName,self[string.format("icon_reward%s",index)])
        end
        self[string.format("text_reward%s",index)].text = fun.NumInsertComma(value.value) --tostring(value.value)
    end
    local rate = rewardRate or ModelList.PuzzleModel:GetPuzzleRewarRate()
    self.text_rate.text = string.format("x%s",rate)
    self.text_rate_light.text = string.format("x%s",rate)
end

function PuzzleViewBigReward:ReBindImg()
    if self.puzzle1Rewards then
        self.puzzle1Rewards.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPuzzleJtJd06")
    end
    if self.pPuzzleJtJd06kuang then
        self.pPuzzleJtJd06kuang.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPuzzleJtJd06kuang")
    end
    if self.pPuzzleJtJdi then
        self.pPuzzleJtJdi.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPuzzleJtJdi")
    end

    if self.pPuzzleReward then
        self.pPuzzleReward.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPuzzleReward")
    end
    if self.pPuzzleReward2 then
        self.pPuzzleReward2.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPuzzleReward")
    end
    if self.cgoaljddiJia then
        self.cgoaljddiJia.sprite = AtlasManager:GetSpriteByName("CommonAtlas","cgoaljddiJia")
    end
    if self.pPuzzleRewardstar then
        self.pPuzzleRewardstar.sprite = AtlasManager:GetSpriteByName("PuzzleAtlas","pPhotoStarBig")
    end
end

return this