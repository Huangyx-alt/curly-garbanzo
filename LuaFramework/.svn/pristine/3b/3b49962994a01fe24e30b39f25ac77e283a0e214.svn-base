--阶段奖励item
local HallofFameStageInfoItem = BaseView:New("HallofFameStageInfoItem")
local this = HallofFameStageInfoItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local TournamentScoreBgConfig = require "View/Tournament/TournamentScoreBgConfig"

this.auto_bind_ui_items ={
	"stageAward",
	"textScore",
	"lock",
	"unLock",
	"bg",
	"scoreBg",
	"anima",
	"stageItemRoot",
	"stageIEfRoot",
	"zuanshi_xing"
}

function HallofFameStageInfoItem:New()
	local o = {}
	self.__index = self
	setmetatable(o,self)
	return o
end

function HallofFameStageInfoItem:Awake()
	self:on_init()
end

function HallofFameStageInfoItem:OnEnable()
	self._init = true
	self._isPlayAnim = false
end

function HallofFameStageInfoItem:OnDisable()
	self._init = nil
	--self._data = nil
	self._isPlayAnim = nil
	self.bgIndex = nil
	self._ratio = nil
	self.forceLock = false
	self.startScore = nil
end

function HallofFameStageInfoItem:SetLockVisible(data,myScore, startScore , forceLock)


	if  myScore and myScore >= data.score and (startScore == nil or (startScore and startScore >= data.score) ) then
		fun.set_active(self.unLock,true)
		fun.set_active(self.lock,false)
		if self.anima then
			self.anima:Play("changeidle")
		end
	else
		fun.set_active(self.unLock,false)
		fun.set_active(self.lock,true)
		if self.anima then
			self.anima:Play("idle")
		end
	end
end

function HallofFameStageInfoItem:SetData(data,bgIndex,myScore,ratio,startScore,forceLock)
	self._data = data
	self.bgIndex = bgIndex
	self._ratio = ratio
	self._myScore = myScore
	self.forceLock = forceLock or false
	self.startScore = startScore or nil
	if self._init then
		self:SetBg()
		self.textScore.text = fun.NumInsertComma(data.score)

		self:SetLockVisible(self._data,self._myScore, self.startScore ,self.forceLock)

		local view = require("View/CommonView/CollectRewardsItem")
		local item = view:New()
		item:SetReward(data.reward[1],true)
		item:SkipLoadShow(self.stageAward.gameObject)	
		
		--设置特效 减少dc
		if self.zuanshi_xing and self.stageIEfRoot then
			local ef = fun.get_instance(self.zuanshi_xing,self.stageIEfRoot)
			ef.transform.position = self.stageAward.transform.position
			fun.set_active(ef,true)
		end
	end
end

function HallofFameStageInfoItem:SetBg()
	self.bg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas", TournamentScoreBgConfig[self.bgIndex][8])
	self.scoreBg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas", TournamentScoreBgConfig[self.bgIndex][9])
	self.unLock.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas", TournamentScoreBgConfig[self.bgIndex][7])
	self.lock.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas", TournamentScoreBgConfig[self.bgIndex][6])
	local out_line = fun.get_component(self.textScore, "Outline")
	local color = TournamentScoreBgConfig[self.bgIndex][3]
	out_line.effectColor = Color.New(color[1] / 255, color[2] / 255,color[3] / 255, 1)
end

--奖励飞行动画
function HallofFameStageInfoItem:FlyRewardToTopArea()
	if self._isPlayAnim then
		return
	end
	
	fun.set_active(self.unLock,true)
	fun.set_active(self.lock,false)
	
	self._isPlayAnim = true
	local pos = self.stageAward.transform.position
	UISound.play("weekly_round_reward")
	
	if self.anima then
		self.anima:Play("change")
	end
	
	for i = 1, #self._data.reward do	
		Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,pos,self._data.reward[i].id ,function()
				Event.Brocast(EventName.Event_currency_change)
			end,nil,i-1)
	end
end

return this