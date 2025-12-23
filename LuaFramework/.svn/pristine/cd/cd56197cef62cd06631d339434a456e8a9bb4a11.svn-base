
local TournamentRankNextTrophy = BaseView:New("TournamentRankNextTrophy")
local this = TournamentRankNextTrophy
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items ={
    "textSlider",
    "imageTrophy",
    "textNextTrophy",
    "sliderProgress",
    "canvasgroup",
}


function TournamentRankNextTrophy:New(lastTiers)
    local o = {}
    self.__index = self
    self.lastTiers = lastTiers
    setmetatable(o,self)
    return o
end

function TournamentRankNextTrophy:Awake()
    self:on_init()
end

function TournamentRankNextTrophy:OnEnable()
    self:ShowProgress()
    self:ShowInfo()
end

function TournamentRankNextTrophy:OnDisable()
end

function TournamentRankNextTrophy:OnDestroy()
    self.hasInitData = false
    self.lastTiers = nil
end

function TournamentRankNextTrophy:ShowInfo()
    if self.hasInitData == true then
        return
    end
    self.hasInitData = true
    self:ShowTrophyImage()
end

function TournamentRankNextTrophy:ShowTrophyImage()
    local tiers = self:GetTiers()
    local trophyName = fun.GetCurrTournamentActivityImg(tiers)
    Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
        if sprite then
            self.imageTrophy.sprite = sprite
        end
    end)
end

function TournamentRankNextTrophy:ShowProgress()
    local model = ModelList.TournamentModel
    local nextTiersPer = model:GetRankNextTiersPer()
    local nextTiersNeedScore = model:GetRankNextTiersNeedScore()
    local colorScore = string.format("%s%s%s", "<color=#FEEDA7>" , nextTiersNeedScore  ,"</color>" )
    self.textNextTrophy.text = string.format(Csv.GetDescription(1303), colorScore)
    self.textSlider.text = string.format("%s%s",nextTiersPer, "%")
    
    self.sliderProgress.fillAmount = nextTiersPer *0.01
end

function TournamentRankNextTrophy:AnimOpenView()
    if self:CheckHasOpen() then
        --避免重复缩放动画
        return
    end
    self.canvasgroup.alpha = 1
    fun.set_gameobject_scale(self.go,0,1,1)
    Anim.scale_to_x(self.go,1, 0.25)
end

function TournamentRankNextTrophy:AnimCloseView()
    Anim.scale_to_xy(self.go,0, 1, 0.35,  function()
        self.canvasgroup.alpha = 0
    end)
end

--进入下一级奖杯
function TournamentRankNextTrophy:ShowNextTrophyFull()
    fun.set_active(self.textNextTrophy, false)
    local currentValue = self.sliderProgress.fillAmount
    Anim.do_smooth_float_update(currentValue,1,0.6,function(num)
        self.sliderProgress.fillAmount = num
        self.textSlider.text = string.format("%.0f%s", num * 100 , "%")
    end,nil) 
end

--第一名 然后积分有变化
function TournamentRankNextTrophy:AnimRefreshRankData(rank_index)
    local model = ModelList.TournamentModel

    local nextTiersPer = model:GetRankNextTiersPer()
    local nextTiersNeedScore = model:GetRankNextTiersNeedScore()
    local colorScore = string.format("%s%s%s", "<color=#FEEDA7>" , nextTiersNeedScore  ,"</color>" )

    local currentValue = self.sliderProgress.fillAmount
    Anim.do_smooth_float_update(currentValue,nextTiersPer * 0.01,0.6,function(num)
        self.sliderProgress.fillAmount = num
        self.textSlider.text = string.format("%.0f%s", num * 100 , "%")
    end,
    function()
        self.textNextTrophy.text = string.format(Csv.GetDescription(1303), colorScore)
    end) 

end


function TournamentRankNextTrophy:GetTiers()
    local model = ModelList.TournamentModel
    local tiers = 1
    if  self.lastTiers then
        if model:CheckTargetMaxTrophy(self.lastTiers) then
            --展示的就是最高等级了
            tiers = self.lastTiers
        else
            tiers = self.lastTiers + 1
        end
        --初始用展示奖励数据 防止在bingo结算时 后台发送了 7204 覆盖了上次的奖杯等级
        self.lastTiers = nil
    elseif model:CheckIsMaxTrophy() then
        --已经满级了
        tiers = model:GetTotalTournamentTrophy()
    else
        --没满级
        local tier, difficulty = model:GetTiers()
        tiers = tier + 1
    end
    return tiers
end


function TournamentRankNextTrophy:RefreshNextTrophy(lastTiers)
    self.lastTiers = lastTiers
    self.hasInitData = false
    fun.set_active(self.textNextTrophy, true)
    self:ShowProgress()
    self:ShowInfo() 
end

function TournamentRankNextTrophy:CheckHasOpen()
    if self.go and self.go.transform.localScale.x >= 1 then
        return true
    end
    return false
end



return this