-- syntax =  "proto3",

-- packageGPBClass.Message,


 PB_ShopItems  =  {
    id               =  1,-- int32  id , --商品id
    canBuyCount      =  2,-- int32  canBuyCount , --可购买次数 为-1(小于0)时 表示没有限制
    nextUnix         =  3,-- int32  nextUnix , --下次出现时间戳(服务端) 0表示没有倒计时限制
    fetchType        =  4,-- int32  fetchType , --0-默认pay_type支付方式获取 1-广告方式获取 2-免费获取
    promoBuyCount    =  5,-- int32  promoBuyCount , --促销购买次数
}