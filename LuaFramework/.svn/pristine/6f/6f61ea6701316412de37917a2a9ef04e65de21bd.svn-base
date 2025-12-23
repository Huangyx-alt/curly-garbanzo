--段位奖励item
local HallofFameTierInfoItem = BaseView:New("HallofFameTierInfoItem")
local this = HallofFameTierInfoItem
this.viewType = CanvasSortingOrderManager.LayerType.None

local TournamentScoreBgConfig = require "View/Tournament/TournamentScoreBgConfig"

this.auto_bind_ui_items ={
	"tierTarget",
	"textScore",
	"trophyBg",
	"tierRewards",
	"Content",
	"CommonItem",
	"bg1",
	"txtBg",
	"bg",
	"bg3",
	"icon_1",
	"icon_2",
	"bgover",
	"zuanshi_xing",
	"stageIEfRoot"
}

local anim = nil

function HallofFameTierInfoItem:New()
	local o = {}
	self.__index = self
	setmetatable(o,self)
	return o
end

function HallofFameTierInfoItem:Awake()
	self:on_init()
end

function HallofFameTierInfoItem:OnEnable()
	self._init = true
	--self:OnShow()
end

function HallofFameTierInfoItem:OnShow()
	
end

function HallofFameTierInfoItem:OnDisable()
	self._init = nil
	self._data = nil
	self.reward_item = nil
	self.bgIndex = nil
end

function HallofFameTierInfoItem:SetStage(isArrive)
	if self.bgover then
		fun.set_active(self.bgover,isArrive)
	end
	local img = fun.get_component(self.tierRewards,fun.IMAGE)
	img.enabled = not isArrive
	local colorA = isArrive and 180 / 255 or 1
	self.trophyBg.color = Color.New(1,1,1,colorA)
end

function HallofFameTierInfoItem:SetData(data,bgIndex)
	self._data = data
	self.bgIndex = bgIndex
	if self._init and self._data then
		--显示奖杯图标
		local trophyName = fun.GetCurrTournamentActivityImg(self._data.tier)
		Cache.load_sprite(AssetList["trophyName"],trophyName,function(sprite)
				if fun.is_not_null(sprite) and self and fun.is_not_null(self.tierTarget) then
					self.tierTarget.sprite = sprite
				end
			end)
		--显示积分
		local scoreRange = ModelList.HallofFameModel:GetScoreRangeByTiers(self._data.tier)
		self.textScore.text = fun.NumInsertComma(scoreRange[2])
		--设置背景
		self:SetBg()
		--显示奖励
		self:SetRewardItem()
	end	
end

function HallofFameTierInfoItem:SetRewardItem()
	local view = require("View/CommonView/CollectRewardsItem")

	if self.reward_item == nil then
		self.reward_item = {}
	end

	if self._data and self._data.tierReward then
		local itemIndex = 0
		for key, value2 in pairs(self._data.tierReward) do
			itemIndex = itemIndex + 1
			if self.reward_item[itemIndex] then
				self.reward_item[itemIndex]:SetReward(value2)
				fun.set_active(self.reward_item[itemIndex].go.transform,true)
			else
				local go = fun.get_instance(self.CommonItem,self.Content)
				local item = view:New()
				item:SkipLoadShow(go)
				item:SetReward(value2,true)
				--- todo: 这里需要缓存起来，不然界面销毁了还会继续执行
				LuaTimer:SetDelayFunction(0.2,function()
						if fun.is_not_null(self.zuanshi_xing)  and fun.is_not_null(self.stageIEfRoot)  then
							local ef = fun.get_instance(self.zuanshi_xing,self.stageIEfRoot)
							ef.name="headEffect"
							ef.transform.position = go.transform.position;
							fun.set_active(ef,true)
						end
					end,nil,LuaTimer.TimerType.UI)
				
				table.insert(self.reward_item,item)
			end
		end
		if itemIndex < #self.reward_item then
			for i = itemIndex + 1, #self.reward_item do
				self.reward_item[i]:Close()
				self.reward_item[i] = nil
			end
		end
	end
end	

function HallofFameTierInfoItem:SetBg()
	--框
	if self.bg then
		self.bg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",TournamentScoreBgConfig[self.bgIndex][8])
	end
	self.trophyBg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",TournamentScoreBgConfig[self.bgIndex][4])
	self.txtBg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",TournamentScoreBgConfig[self.bgIndex][5])
	--背景
	if self.bg1 then
		self.bg1.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",TournamentScoreBgConfig[self.bgIndex][2])
	end
	
	local isTrueGol = ModelList.HallofFameModel:CheckIsTrueGoldUser()
	if self.bg3 then
		self.bg3.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",TournamentScoreBgConfig[self.bgIndex][12])
		--if isTrueGol then
			--fun.set_gameobject_pos(self.bg3,0,37,0,true)
		--else
			--fun.set_gameobject_pos(self.bg3,0,5,0,true)
		--end
		
		local spName = "ZBJfJlxxLbDi"
		if self.bgIndex == 6 then
			spName = "ZBzym611"
		end
		
		local rewardBg = fun.get_component(self.tierRewards,fun.IMAGE)
		rewardBg.sprite = AtlasManager:GetSpriteByName("HallofFameScoreAtlas",spName)
	end
	
	if self.icon_1 and self.icon_2 then
		local isShow = isTrueGol
		fun.set_active(self.icon_1,isShow)
		fun.set_active(self.icon_2,isShow)
	end
end

--奖励飞行动画
function HallofFameTierInfoItem:PlayTierAwardAnim(data,targetPos,callBack)
	UISound.play("weekly_round_up")
	for i = 1, #data do
		if not self.reward_item  then
			--打开 HallofFameScoreView 生成全部地图时 会卡顿 self.reward_item 有可能出现空情况
			log.log("错误奖励发放有问题 a" , i , data)
			if callBack then
				callBack()
			end
			return
		end
		if not self.reward_item[i] then
			--打开 HallofFameScoreView 生成全部地图时 会卡顿 self.reward_item 有可能出现空情况
			local rewardItemNUm = GetTableLength(self.reward_item)
			log.log("错误奖励发放有问题 b" , i   ,data,  rewardItemNUm)
			if callBack then
				callBack()
			end
			return
		end
		local pos = self.reward_item[i]:GetPosition()
		Facade.SendNotification(NotifyName.ShopView.FlyRewardEffcts,pos,data[i].id ,function()
			if i == #data and callBack then
					callBack()
			end
		end,nil,nil,targetPos)
	end
end

return this
