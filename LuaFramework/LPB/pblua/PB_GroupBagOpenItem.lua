-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_BagOpenItem.proto",

 PB_GroupBagOpenItem  =  {
    itemId                              =  1,-- int32 itemId ,--美食篮子itemId 作为分组Id
    bagOpenItem       =  2,-- repeated PB_BagOpenItem ,--某组所有开美食篮子打开后的奖励,顺序获取-顺序打开
}