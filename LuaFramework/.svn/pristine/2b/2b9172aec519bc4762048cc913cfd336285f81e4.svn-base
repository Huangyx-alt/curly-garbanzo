-- syntax =  "proto3",

-- packageGPBClass.Message,

--*****powerUp-单卡投放坐标和效果信息************--
 PB_PowerUpPosAndEffect  =  {
    basePos  =  1,-- int32 basePos ,                           --basePosType = 0(出现情况：,useType = 2-对卡牌投放,useType = 1-投放格子 不指定确定位置-由basePosType范围随机,useType = 0-不投放直接生效) 	
    morePos  =  4,-- repeated int32  ,    --额外坐标集合 (宠物技能命中或涂抹格子直接生效-会使用额外盖章坐标,已经盖的部分跳过) -非空则使用
    morePosNum  =  5,--	int32 morePosNum ,                        --额外坐标数量(不指定morePos的时候 按照posType范围随机选择指定数量-可能小于配置表格子数量)
}
