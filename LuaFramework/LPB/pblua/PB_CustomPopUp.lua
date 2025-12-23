-- syntax =  "proto3",

-- packageGPBClass.Message,


--弹框字段
 PB_CustomPopUp  =  {
    type  = 1,-- int32 type ,--弹框类型--参考-CUSTOM_POP_UP_TYPE
    msg  = 2,-- string msg ,--弹框文字
    ext  = 3,-- string ext ,--拓展字段-空字符或者json

}