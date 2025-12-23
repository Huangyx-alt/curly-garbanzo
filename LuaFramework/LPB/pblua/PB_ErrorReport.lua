-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_ErrorReport_Req  =  {
    category  =  1,-- string category , --错误类型
    string   =  2, --事件额外信息(json格式[ex1,ex2,...]，最多支持6项数据)
}

 PB_ErrorReport_Res  =  {

}