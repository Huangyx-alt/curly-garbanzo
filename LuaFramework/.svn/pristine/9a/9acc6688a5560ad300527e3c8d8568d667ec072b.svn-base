-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_CheckConfigUpdate_Req  =  {
    appId  =  1,-- string appId , --应用ID
    bigVersion  =  2,-- string bigVersion , --大版本号
    smallVersion  =  3,-- int32 smallVersion , --小版本号
}

 PB_CheckConfigUpdate_Res  =  {
    bigVersion  =  1,-- string bigVersion , --大版本号
    smallVersion  =  2,-- int32 smallVersion , --小版本号
    baseUrl  =  3,-- string baseUrl , --基础地址，CDN
    updates  =  4,-- repeated PB_ConfigUpdateInfo , -- 更新内容
}

 PB_ConfigUpdateInfo  =  {
    filePath  =  1,-- string filePath , -- 文件名称
    savePath  =  2,-- string savePath , -- 文件存储路径
    md5  =  3,-- string md5 , -- 文件MD5值
    size  =  4,-- int32 size , -- 文件大小
}