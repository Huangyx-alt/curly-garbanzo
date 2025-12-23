-- syntax =  "proto3",

-- packageGPBClass.Message,

--posList 说明 选择坐标数组 一般全是0（范围选择或对卡牌）或全非0（指定格子坐标） 
--元素值0表示：
--1.非指定坐标一般范围选取使用
--2.对卡牌投放
--3.非投放类直接生效powerUp
--posList元素总数量表示-技能效果在basePosType范围命中的数量

--*****powerUp-单卡使用信息************--
 PB_CardPowerUpEffect  =  {
    cardId  =  1,-- int32 cardId ,						                      --卡牌ID
    basePosType  =  2,-- int32 basePosType ,						                  --投放坐标类型-暂时保留不使用
    posList  =  3,-- repeated int32  ,                     --选择格子坐标
    numberList  =  4,-- repeated int32  ,                  --双数字时 格子坐标对应-新号码
    extraPos  =  5,-- repeated int32  ,                    --petSkill skill_type = 1 无固定图案 指定额外盖章坐标集合
}
