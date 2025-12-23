-- syntax =  "proto3",
-- import"PB_ItemInfo.proto",
-- packageGPBClass.Message,

 PB_WeekTierStageInfo  =  {
    score                     =  1,-- int32  score ,--分数--作为展示分割线
    minScore                  =  2,-- int32  minScore ,--区间较小分数
    stagePlayerNum            =  3,-- int32  stagePlayerNum ,--区间玩家人数
    reward      =  4,-- repeated PB_ItemInfo ,--分数达到score时 可领取阶段奖励
    status                    =  5,-- int32  status ,--状态 0-未达到score不可领取 1-已经达到score未领取 2-已经达到score已领取
}