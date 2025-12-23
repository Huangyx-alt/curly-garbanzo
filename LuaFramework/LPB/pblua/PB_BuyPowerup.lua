-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_BuyPowerup_Req  =  {
    rate                =  1,-- int32 rate , --档位
    type                =  2,-- int32 type , --新版本不再使用
    cityId              =  3,-- int32 cityId ,--新版本不再使用
    couponId            =  4,-- int32 couponId ,--保留
    useCouponId        =  5,-- string useCouponId ,--使用的时候参数-唯一id
    playId              =  6,-- int32 playId ,--玩法id PLAY_ID 玩法id可以反推所属城市id
    puLevel             =  7,-- int32 puLevel ,--购买界面的等级  0-没有等级（所有） 1-普通等级 2-白银等级 3-黄金等级 4-大师等级
    betRate             =  8,-- int32 betRate ,--用户选择的下注档位
    cardNum             =  9,-- int32 cardNum ,--bingo卡片数量
}

 PB_BuyPowerup_Res  =  {
    powerups   =  1,-- repeated int32  , --卡牌ID
    jokerPowerups   =  2,-- repeated int32  , --小丑卡牌ID
    id                  =  3,-- int64 id ,--id
    groupId             =  4,-- int32 groupId , --powerUpGroup 配置ID
    playId              =  5,-- int32 playId , --playId
    level               =  6,-- int32 level , --PU卡等级
    power               =  7,-- int32 power , --PU卡分数
    puLevel             =  8,-- int32 puLevel , --pu卡界面得等级
    cardNum             =  9,-- int32 cardNum , --bingo卡片数量
}

