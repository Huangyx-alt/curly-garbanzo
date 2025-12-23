-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_MiniGameBoxLayerList  =  {
    layNo                                    =  1,-- int32 layNo , --层数编号 1-15层
    color                                    =  2,--	int32 color , --字体颜色 0-白色 1-棕色
    circleColor                              =  3,--	int32 circleColor , --包围字体的圆颜色 0-浅绿 1-浅黄 2-白色
    background                               =  4,--	int32 background , --方框背景  0-【5、10、15黄金背景】 1-【1-4层背景】 2-【6-9层背景】 3-【11-14层背景】
    logoStyle                                =  5,--	int32 logoStyle , --标识方式 0-小标识从左往右移动，1-小标识留在中间，层数从右往左移动
    isCurrent                                 =  6,--	bool isCurrent , --是否当前
    extraReward               =  7,--	repeated PB_ItemInfo , --额外奖励
}

