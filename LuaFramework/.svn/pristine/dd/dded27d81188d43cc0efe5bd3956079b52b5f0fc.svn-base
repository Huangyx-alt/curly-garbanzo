-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- import"PB_PagePuzzle.proto",
-- packageGPBClass.Message,

 PB_PuzzleState  =  {
    currentPuzzle  =                  1,--	int32  currentPuzzle , --当前拼图在城市全部拼图列表中的下标
    totalPuzzle  =                    2,--	int32  totalPuzzle , --总共M张拼图
    process  =                        3,--	int32  process , --进度数量--当前拼图已有碎片数量
    target  =                         4,--	int32  target , --目标数量--当前拼图需要碎片数量
    completed  =                      5,--	bool   completed , --是否完成目标--当前拼图
    rewarded  =                       6,--	bool   rewarded , --奖励是否领取--当前拼图
    puzzleItemId  =                   7,--	int32  puzzleItemId , --拼图碎片Id--当前拼图需要的碎片id
    state  =                  8,--	repeated int32  ,--拼图格子填充状态 按照连续位置 1-已填充 0-未填充
    reward  =           9,--	repeated PB_ItemInfo ,--完成拼图可获得的奖励
    pagePuzzleNum  =                  1,--	int32  pagePuzzleNum 0, --当页拼图数量--废弃
    pageCurrentIndex  =               1,--	int32  pageCurrentIndex 1, --进行中的拼图 在当页拼图列表中所属下标,其左边已完成,右边未开始
    pageCompleted  =                  1,--	bool   pageCompleted 2, --当页是否完成目标
    pageRewarded  =                   1,--	bool   pageRewarded 3, --当页奖励是否领取
    pageReward  =       1,--	repeated PB_ItemInfo 4,--当页奖励数据【大奖】
    pagePuzzle  =     1,--	repeated PB_PagePuzzle 5,--当页 所有拼图进度数据 数组
    pageRewardBet  =                  1,--	int32  pageRewardBet 6,--当页 拼图奖励倍数
}