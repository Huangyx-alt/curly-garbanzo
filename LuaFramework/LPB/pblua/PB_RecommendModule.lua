-- syntax =  "proto3",
-- packageGPBClass.Message,

 PB_RecommendModule  =  {
    recommend  =  1,-- int32 recommend ,--主推玩法，直接解锁玩法
    banner  =  2,-- int32 banner ,--banner推荐  玩法ID--1.16开始废弃
    pop  =  3,-- int32 pop ,--弹窗推荐  玩法ID
    entrance  =  4,-- repeated int32  ,--首页入口位置, feature_enter 表ID
    moduleList  =  5,-- repeated Module ,--玩法排列图标
    banners  =  6,-- repeated int32  ,--多个banner 指定顺序
    endTime  =  7,-- int64 endTime ,  -- 结束时间
}

 Module{
    id  =  1,-- int32 id , --玩法ID配置
    value  =  2,-- int32 value ,--模块图标类型
}
