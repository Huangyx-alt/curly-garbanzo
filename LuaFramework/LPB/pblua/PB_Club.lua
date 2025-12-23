-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubLimit.proto",
-- import"PB_ClubPlayerInfo.proto",

 PB_Club  =  {
    clubId  = 1,-- int32 clubId ,-- 公会ID，唯一
    name   = 2,-- string name , -- 公会名称
    icon   = 3,-- string icon , -- 公会头像
    profile  = 4,-- string profile , -- 公会简介
    curNum  = 5,-- int32 curNum , -- 当前人数
    totalNum  = 6,-- int32 totalNum , -- 总人数
    creatorId   = 7,-- int32 creatorId ,-- 创建者id
    creatorType  = 8,-- int32 creatorType ,-- 创建者类型  0-真人 1-机器人
    creatorName   = 9,-- string creatorName ,--创建者名称
    autoReview  = 1,-- bool autoReview 0, --自动审核
    clubLimit  = 1,-- PB_ClubLimit clubLimit 1, -- 加入公会条件限制
    members  =  1,-- repeated PB_ClubPlayerInfo 2,--query查询的时候不用此字段，fetch查询自己的公会使用
    underIcon   = 1,-- string underIcon 3, -- 公会头像背景
    nextJoinClubUnix   = 1,-- int32 nextJoinClubUnix 4,--下次可选择加入新公会时间戳 仅当前clubId = 0 当前时间戳> = 此时间戳 可以选择加入公会
}