local TournamentRankUpView = {}
local itemView = require("View/CommonView/CollectRewardsItem")

local topOneRewardItem = nil          --榜单第一名奖励节点
local topOneItemList = nil
local myNewRewardItem = nil          --玩家自己最新奖励节点
local myNewRewardList = nil

local creatTopOneItem = {}
local creatMyNewRewardItem = {}

local startAward = nil;
local topAward = nil;
local exitCallback = nil;
local tier = nil;

--奖励位置/旋转组合
local itemGroup =
{
	[1] =
	{
		[1] = {pos = {x = -5 , y = 293 , z= 0},rotate = {x = 0 , y = 0 , z = 0}}
	},
	[2] =
	{
		[1] = {pos = {x = -113 , y = 292 , z= 0},rotate = {x = 0 , y = 0 , z = 13}},
		[2] = {pos = {x = 107 , y = 292 , z= 0},rotate = {x = 0 , y = 0 , z = -13}},
	},
	[3] =
	{
		[1] = {pos = {x = -232 , y = 250 , z= 0},rotate = {x = 0 , y = 0 , z = 27}},
		[2] = {pos = {x = -5 , y = 293 , z= 0},rotate = {x = 0 , y = 0 , z = 0}},
		[3] = {pos = {x = 222 , y = 244 , z= 0},rotate = {x = 0 , y = 0 , z = -27}},
	},
	[4] =
	{
		[1] = {pos = {x = -306 , y = 192 , z= 0},rotate = {x = 0 , y = 0 , z = 27}},
		[2] = {pos = {x = -113 , y = 293 , z= 0},rotate = {x = 0 , y = 0 , z = 13}},
		[3] = {pos = {x = 107 , y = 292 , z= 0},rotate = {x = 0 , y = 0 , z = -13}},
		[4] = {pos = {x = 305 , y = 189 , z= 0},rotate = {x = 0 , y = 0 , z = -27}},
	},
}


function TournamentRankUpView:OnDestroy()
	for k, v in pairs(creatTopOneItem) do
		if v then
			fun.set_active(v,false)
		end
	end
	for k, v in pairs(creatMyNewRewardItem) do
		if v then
			fun.set_active(v,false)
		end
	end
end

function TournamentRankUpView:OnDisable()
	creatTopOneItem = {};
	creatMyNewRewardItem = {};
end

function TournamentRankUpView:OnEnable(params)
	topOneRewardItem = params.topOneRewardItem
	topOneItemList = params.topOneItemList
	myNewRewardItem = params.myNewRewardItem
	myNewRewardList = params.myNewRewardList
	startAward = params.startAward;
	topAward = params.topAward;
	tier = params.tier;
	self:InitView()
end

function TournamentRankUpView:InitView()
	--self:SetTrophyName();
	self:InitMyNewReward();
	self:InitTopOneReward();
	UISound.stop_loop("weeklyincrease")
end

function TournamentRankUpView:InitMyNewReward()
	for k , v in ipairs(startAward) do
		local grid = self:GetGride(myNewRewardItem, myNewRewardList,creatMyNewRewardItem,k);
		local item = itemView:New()
		item:SetReward(v)
		item:SkipLoadShow(grid)
		fun.set_active(grid,true)
	end
end

function TournamentRankUpView:GetGride(prefab,parent,list,index)
	local grid = list[index];
	if grid == nil then
		grid = fun.get_instance(prefab, parent)
		table.insert(list, grid);
	end

	return grid;
end

function TournamentRankUpView:InitTopOneReward()
	local itemNum = GetTableLength(topAward)
	for i = 1 , itemNum do
		if i <= 4 then
			local itemUiData = self:GetItemUiData(itemNum , i)
			if itemUiData then
				local grid = self:GetGride(topOneRewardItem, topOneItemList,creatTopOneItem,i);
				grid.transform.localPosition = itemUiData.pos
				grid.transform.eulerAngles = itemUiData.rotate
				local item = itemView:New()
				item:SetReward(topAward[i])
				item:SkipLoadShow(grid)
				fun.set_active(grid,true)
			end
		end
	end
end

function TournamentRankUpView:GetItemUiData(totalNum , index)
	if itemGroup[totalNum] and itemGroup[totalNum][index] then
		return itemGroup[totalNum][index]
	end
	return nil
end

return TournamentRankUpView

