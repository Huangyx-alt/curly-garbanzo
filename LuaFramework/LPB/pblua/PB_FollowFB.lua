-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_FollowFB_Req  =  {
    firstShowFollowFacebookUnix  =  1,-- int32   firstShowFollowFacebookUnix , --首次展示时间 非首次的可传0
}

 PB_FollowFB_Res  =  {
    followFacebookUnix  =  1,-- int32   followFacebookUnix , --关注时间
    firstShowFollowFacebookUnix  =  2,-- int32   firstShowFollowFacebookUnix , --首次展示时间
}