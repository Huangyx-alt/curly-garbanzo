-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_VersionPackage.proto",

 PB_CheckAppVersion2_Req  =  {
    bigVersion  =  1,-- int32 bigVersion , --大版本号
    smallVersion  =  2,-- int32 smallVersion , --小版本号
    memory  =  3,-- double memory , --内存大小(MB)
    score  =  4,-- int32 score , --性能评分
    middleVersion  =  5,-- int32 middleVersion , --中版本号
}

 PB_CheckAppVersion2_Res  =  {
    bigVersion  =  1,-- int32 bigVersion , --最新大版本号
    smallVersion  =  2,-- int32 smallVersion , --最新小版本号
    hasUpdate  =  3,-- bool hasUpdate , --是否有更新（热更包）
    forceUpdate  =  4,-- bool forceUpdate , --是否强制更新
    quality  =  5,-- int32 quality , --资源推荐质量
    packages  =  6,-- repeated PB_VersionPackage , --更新包列表
    themeName  =  7,-- string themeName , -- UI主题名称
    hasNewUpdate  =  8,-- bool hasNewUpdate , --是否有新发布版本（如：1.19  = > 1.20, 后台设置版本为已发布状态）
    middleVersion  =  9,-- int32 middleVersion , --最新中版本号
    endVersion  =  1,-- string endVersion 0, --结束版本号
    resVersion  =  1,-- string resVersion 1, --资源版本号
    packageUrl  =  1,-- string packageUrl 2, --包链接地址
    cdnList  =  1,-- repeated string 3, --cdn地址列表
}