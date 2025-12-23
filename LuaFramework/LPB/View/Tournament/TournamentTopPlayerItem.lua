local TournamentTopPlayerItem = {}
local item = nil
local headRef = nil

local textScore = nil
local userName = nil
local clubName = nil
local imgHead = nil
local imageFrame = nil;
local rank = nil;
local rankBg = nil;
local giftIcon = nil;

local hasBindUI = false
local itemData = nil;


function TournamentTopPlayerItem:BindUI()
	if hasBindUI then
		return
	end
	
	local ref = fun.get_component(item, fun.REFER)
	textScore = ref:Get("textScore")
	headRef = ref:Get("HeadObjPrefab");
	imgHead = headRef:Get("imgHead")
	imageFrame = headRef:Get("imageFrame")
	userName = ref:Get("userName")
	clubName = ref:Get("clubName")
	rank = ref:Get("rank")
	rankBg = ref:Get("rankBg")
	giftIcon = ref:Get("giftIcon")
	
	hasBindUI = true
end

function TournamentTopPlayerItem:SetItem(params)
	item = params.topOneUi
	itemData = params.topOneData
	self:BindUI()
	self:InitHeadIcon()
	self:InitFrameIcon()
	self:InitName()
	self:InitScore()
	self:InitSelect();
end

function TournamentTopPlayerItem:InitHeadIcon()
	local myUid = ModelList.PlayerInfoModel:GetUid()
	local model = ModelList.PlayerInfoSysModel
	if myUid == tonumber(itemData.uid) then
		model:LoadOwnHeadSprite(imgHead)
	else
		local useAvatarName = model:GetCheckAvatar(itemData.avatar , itemData.uid)
		model:LoadTargetHeadSpriteByName(useAvatarName ,imgHead)
	end
end

function TournamentTopPlayerItem:InitFrameIcon()
	local myUid = ModelList.PlayerInfoModel:GetUid()
	local model = ModelList.PlayerInfoSysModel
	if myUid == tonumber(itemData.uid) then
		model:LoadOwnFrameSprite(imageFrame)
	else
		local useFrameName = model:GetCheckFrame(itemData.frame , itemData.uid)
		model:LoadTargetFrameSpriteByName(useFrameName , imageFrame)
	end
end

function TournamentTopPlayerItem:InitScore()
	textScore.text = fun.formatNum(itemData.score) or 0
end

function TournamentTopPlayerItem:InitName()
	userName.text = itemData.nickname
	clubName.text = itemData.clubName
end

--显示自己的边框
function TournamentTopPlayerItem:InitSelect()
	
end

return TournamentTopPlayerItem
