-- syntax =  "proto3",

-- packageGPBClass.Message,

--*******Bingo使用道具()***********--
 PB_HangUpUseItem_Req  =  {
    itemId  =  1,-- int32 itemId , 						--卡片ID	
}



--*******Bingo使用道具(5006)***********--
 PB_HangUpUseItem_Res  =  {
    itemId  =  1,-- int32 itemId , 						--卡片ID
    itemIds  =  2,--	repeated int32 ,				--剩余道具ID
}