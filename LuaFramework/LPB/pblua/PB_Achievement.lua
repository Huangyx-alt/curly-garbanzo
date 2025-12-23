-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_Achievement  =  {
    type  =  1,-- int32  type , --成就类型 根据不同的类型使用不同的图标 附带iconValue一起显示  0-注册出生时间  1-累计bingo数  1-累计卡牌数  1-累计开美食袋子数  1-累计制作美食数  1-累计完成拼图数
    iconValue  =  2,-- string iconValue , --图标附带一起展示的参数 json字符串格式 参考 [[name,value],[name,value]]
    descText  =  3,-- int32 descText , --描述文本-模板id
    bottomText  =  4,-- int32 bottomText , --最下面文本-模板id

}