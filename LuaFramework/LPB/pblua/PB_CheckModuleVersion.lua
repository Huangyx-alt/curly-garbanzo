-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ModuleVersion.proto",

 PB_CheckModuleVersion_Req  =  {
    appId  =  1,-- string appId , --应用ID
    bigVersion  =  2,-- string bigVersion , --主应用大版本号
    smallVersion  =  3,-- int32 smallVersion , --主应用小版本号
    moduleId  =  4,-- string moduleId , --模块ID （不传默认查全部）
    version  =  5,-- string version , --模块版本号（跟module对应）
}

 PB_CheckModuleVersion_Res  =  {
    moduleList  =  1,-- repeated ModuleVersion , --模块版本列表
    groups  =  2,-- repeated ModuleGroup , --分组列表
}

 ModuleGroup  =  {
    groupType  =  1,-- int32 groupType , --分组类型，1推荐（大图），2普通
    moduleIdList  =  2,-- repeated int32  , --分组列表
}