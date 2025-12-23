-- syntax =  "proto3",
-- import"PB_WeekRankPlayer.proto",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_WeekStageInfo  =  {
    score                               =  1,-- int32  score ,--分数--作为展示分割线
    minScore                            =  2,-- int32  minScore ,--阶段区间较小分数
    stagePlayerNum                      =  3,-- int32  stagePlayerNum ,--阶段区间玩家人数
    status                              =  4,-- int32  status ,--状态 0-未达到score不可领取 1-已经达到score未领取 2-已经达到score已领取
    reward                =  5,-- repeated PB_ItemInfo ,--分数达到score时 可领取的阶段奖励
    showPlayers     =  6,-- repeated PB_WeekRankPlayer ,--当 showPlayers非空【< = 5】直接展示，不展示stagePlayerNum

}