--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY
local protoType = ProtocalType.LuaProtobuff
--激活 bingo bang 网络模块
local netConnector = require "Net.NetConnector"

Network = netConnector --覆盖lpb原来的 Network全局变量

local bingoBangNetType = true
local simulateNewbieFlag = true
local simulateSDKFlag = true
local IsReplayBattle = false

local IsInGuide = false

--战斗相关状态标识
local IsInEnterBattleSequence = false          --是否正在进战的工作流中
local IsInBattle = false                        --是否正在战斗中
local IsInBattleSignSequence = false            --是否正在触发盖章后做表现的工作流中
local IsInBattleBingoSequence = false           --是否正在触发Bingo后做表现的工作流中
local IsInBattlePreSettle = false               --是否正在进行结算流程的前置(等特效播放完、显示LastChance。。。)
local IsInBattleSettle = false                  --是否正在结算流程
local LastEndBattleTime = nil                   --上次结束战斗后返回到大厅的时间戳
local IntervalBetweenTwoBattle = 0              --距离上次进入战斗的时间间隔，用来计算战斗开始倒计时相关
--战斗相关数据缓存
local BingoQueue = {}
local BingoExecuteFlag = {}
local ManualDaubCount = 0                       --玩家手动涂抹的格子个数（不包括pu自动释放涂抹的格子）
local DaubPowerDaubCount = 0                         --使用autodaub功能，涂抹的格子个数
local MissNumberList = {}                       --玩家在对局中漏掉涂抹的数量
local LuckyBangTriggerBingoCount = 0            --通过Luck Bang触发的Bingo数量

local topMenuShowType =
{
    Home = 1,         --大厅打开菜单栏
    MachineLobby = 2 , -- 机台大厅点开菜单栏
}

local mainShopViewEvent =
{
    ReqShopData = "mainShopViewEvent.ReqShopData",
    ClickButtonPurchase = "mainShopViewEvent.ClickButtonPurchase",
    RefreshShopTypeView = "mainShopViewEvent.RefreshShopTypeView",
    ClickReqShopDailyFreeReward = "mainShopViewEvent.ClickReqShopDailyFreeReward",
}

local mainShopToggleType =
{
    Chips = 1 ,
    Gems = 2 ,
    PowerUp = 3 ,
    Items = 4,
}

local itemType =
{
    Diamond = 1 , --钻石
    Coin = 2 , -- 金币
    MagnifyingGlass = 3 , -- 放大镜
    CookieDoubleTime = 23 , --饼干双倍结算时间
    VipPoints = 10 , --vip点数
    ColorfulPU = 910804 , --彩色PU
    RedPU = 910803 , --红色PU
    PurplePU = 910802 , --紫色PU
    BluePU = 910801 , --蓝色PU
    PUSign = 910805 , --盖章PU
    PUDoubleNumber = 910806 ,--双数字PU
    PUDoubleExp = 910807 ,--双倍经验PU
    PUDoubleSignPU = 910808 ,--双倍经验PU
    PUBox = 910809 ,--箱子PU
    PUDoodlePen = 910810 ,--涂鸦笔PU
    PUBingo = 910811 ,--bingoPU
    PULuckBang = 910812 ,--luckbang PU
    PUDoubleCoin = 910813 ,--双倍金币PU
    
}

--付费消耗
local ShopPayType =
{
    Money = 0, --花真钱
    Diamond = 1, --花钻石
}

local PUItemType =
{
    PUFreeDaub = 101, --PU 随机盖1个章
    PUExtraNumber = 102, --PU 双数字
    PUDoubleXp = 103, --PU 双倍经验
    PUX2Daub = 104,   --PU 随机盖2个章
    PUChest = 105,    --PU 宝箱
    PUDauber = 106,  --PU 涂鸦笔
    PULuckyBang = 107, --PU 叫号器
    PUInstantBINGO = 108, --PU bingo
    PUDoubleWIN = 109,   --PU 双倍奖励
}


local BattleContainerType =
{
    CellEffectContainer = 1 ,     --格子效果
    PuEffectContainer = 2 ,     --pu效果
    BingoEffectContainer = 3 ,  --Bingo效果
}

--小游戏类型
local miniGameType =
{
    PiggySlots = 1  --小猪slots
    
}

local selectGameCardNum =
{
    TwoCard = 2 , --两卡
    FourCard = 4 ,--四卡
}
local selectGameCardNumString = "selectGameCardNumSaveString" --保存选卡数量的字符串

--小猪slots配置
local piggySlotsConfig =
{
    FreeSpinNum = 3 , --每张卡3次免费spin
    MaxSpinNum = 6    --每张卡6次spin
}

local loadResourceState =
{
    Exist = 1 , --资源已经下载好
    Empty = 2 , --没有资源
    Downloading = 3 ,--资源正在下载
}

--玩法类型
local machineType =
{
    Main = 1 , --主玩法
    Special = 2, -- 特殊玩法
}

--选择bet展示的道具奖励
local selectBattleReward =
{
    Cheset = 1,
    Cookie = 2,
    SeasonPass = 3, --赛季令牌
    PiggySlotsTicket = 4,
    --Tournament = 5,
}

local selectBattleConfigItemValueChange =
{
    Decrease = 1, -- 道具数量减少
    Increase = 2 , --道具数量增加
    Same = 3 ,--道具数量不变
    InitItem = 4, --道具初始化
}

local exitMachineLobbyType =
{
    ClickBackHome = 1,
    PuzzleRewardExit = 2 ,
}

local reportPurchaseState =
{
    PurchaseSuccess =1,
    PurchaseFail = 2,
}

return {
    protoType = protoType,
    network = netConnector,
    bingoBangNetType = bingoBangNetType,
    simulateNewbieFlag = simulateNewbieFlag,
    simulateSDKFlag = simulateSDKFlag,
    IsInGuide = IsInGuide,
    IsInEnterBattleSequence = IsInEnterBattleSequence,
    IsInBattle = IsInBattle,
    IsInBattleSignSequence = IsInBattleSignSequence,
    IsInBattleBingoSequence = IsInBattleBingoSequence,
    IsInBattlePreSettle = IsInBattlePreSettle,
    IsInBattleSettle = IsInBattleSettle,
    LastEndBattleTime = LastEndBattleTime,
    IntervalBetweenTwoBattle = IntervalBetweenTwoBattle,
    BingoQueue = BingoQueue,
    BingoExecuteFlag = BingoExecuteFlag,
    ManualDaubCount = ManualDaubCount,
    DaubPowerDaubCount = DaubPowerDaubCount,
    MissNumberList = MissNumberList,
    LuckyBangTriggerBingoCount = LuckyBangTriggerBingoCount,
    IsReplayBattle = IsReplayBattle,
    topMenuShowType = topMenuShowType,
    mainShopViewEvent = mainShopViewEvent,
    mainShopToggleType = mainShopToggleType,
    itemType = itemType,
    PUItemType = PUItemType,
    BattleContainerType = BattleContainerType,
    ShopPayType = ShopPayType,
    miniGameType = miniGameType,
    selectGameCardNum = selectGameCardNum,
    selectGameCardNumString = selectGameCardNumString,
    piggySlotsConfig = piggySlotsConfig,
    loadResourceState = loadResourceState,
    machineType = machineType,
    selectBattleReward = selectBattleReward,
    selectBattleConfigItemValueChange = selectBattleConfigItemValueChange ,
    exitMachineLobbyType = exitMachineLobbyType,
    reportPurchaseState = reportPurchaseState,
}
