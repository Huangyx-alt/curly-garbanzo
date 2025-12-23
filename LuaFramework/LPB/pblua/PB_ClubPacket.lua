-- syntax =  "proto3",

-- packageGPBClass.Message,

--单个公会礼盒
 PB_ClubPacket  =  {
    id  = 1,-- string id ,--用户公会红包-唯一id
    unix  = 2,-- int32 unix ,--过期时间戳
    itemId  = 3,-- int32 itemId ,--关联的itemId
}