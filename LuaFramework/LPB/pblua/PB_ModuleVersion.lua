-- syntax =  "proto3",

-- packageGPBClass.Message,

 ModuleVersion  =  {
    indexInList  =  1,-- int32 indexInList ,  --序号
    picResource  =  2,-- resourceInfo picResource , --模块图片资源包
    moduleId  =  3,-- int32 moduleId ,     --模块ID
    moduleName  =  4,-- string moduleName ,  --模块名称
    version  =  5,-- int32 version ,        --模块版本号  前端约定 单数字
    moduleType  =  6,-- int32 moduleType ,   --模块类型
    enterType  =  7,-- int32 enterType ,    --入口展示类型  feature_type  =  1hot  2new  3普通  4coming soon
    playId  =  8,-- int32 playId ,       --模块玩法ID
    cityId  =  9,-- int32 cityId ,       --模块城市ID
    resourceInfo  =  1,-- resourceInfo resourceInfo 0, --模块资源包
    lockLevel  =  1,-- int32 lockLevel 1,   --普通解锁等级
    vipLockLevel  =  1,-- int32 vipLockLevel 2, --VIP用户解锁等级，VIP专享
    status  =  1,-- bool status 3,       --模块开放状态  true打开  false关闭
    canUpdate  =  1,-- bool canUpdate 4,   --模块是否需要可更新  true打开  false关闭
    featureId  =  1,-- int32 featureId 5,  --featureId，对应 feature_enter 中的ID
}

 resourceInfo  =  {
    url  =  1,-- string url ,         --下载链接
    latestMd5  =  2,-- string latestMd5 ,   --包MD5
    size  =  3,-- int32 size ,         --包内存大小
}