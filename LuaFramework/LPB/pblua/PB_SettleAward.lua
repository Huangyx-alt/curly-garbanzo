-- syntax =  "proto3",

-- packageGPBClass.Message,
 PB_SettleAward  =  {
    tip  =  1,-- int32 tip ,              --提示项-描述id--1.16版本开始不再使用
    content  =  2,-- int32 content ,          --提示内容-奖励数值
    bingoNum  =  3,-- int32 bingoNum ,         --bingo数量 -1特指jackpot，-2特指teammate bingo 前端根据此字段查description
    bingoOrder  =  4,-- int32 bingoOrder ,       --玩家bingo排名 前端根据此字段查description
    layerNum  =  5,-- int32 layerNum ,         --层度，用于特殊场景下，某个递进关系
}