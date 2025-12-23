-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_GameCardInfo.proto",
-- import"PB_PowerUpData.proto",
-- import"PB_CardPos.proto",
-- import"PB_GroupBagOpenItem.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_JokerCardData.proto",


--****** ���淨-gameLoad *********--
 PB_GameLoadPiggyBankgy_Req  =  {
    cardNum             =  1,-- int32 cardNum ,--��Ƭ����
    rate                =  2,-- int32 rate ,--����
    cityId              =  3,-- int32 cityId ,--����ID
    powerUpId           =  4,-- int64 powerUpId ,--powerUpId
    couponId            =  5,-- int32 couponId ,--�Ż�ȯid ����
    useCouponId        =  6,-- string useCouponId ,--ʹ���Ż�ȯ��Ψһid
    playId              =  7,-- int32 playId ,--�������淨���id = city_play��id
    hideCardAuto        =  8,-- int32 hideCardAuto ,--�Ƿ������ؿ����Զ�����-�������� 0-������ 1-����
}

 PB_GameLoadPiggyBankgy_Res  =  {
    gameId                                       =  1,-- string gameId ,--��Ϸid
    cardsInfo                  =  2,-- repeated PB_GameCardInfo ,--����bingo����
    jackpot                              =  3,-- repeated int32  ,--ÿ�ſ��Ƿ���γ�jackPot 0,1
    bingoLeft                                     =  4,-- int32 bingoLeft ,--ʣ��bingos����
    powerUps                             =  5,-- repeated int32  ,--��Ϸ����powerUps ��ʱ�������ʹ��-powerUpData
    hintTime                                      =  6,-- int32 hintTime ,--������hintTime����ʱ���
    systemTime                                    =  7,-- int32 systemTime ,--��������ǰʱ���
    spendResourceId                               =  8,-- int32 spendResourceId ,--��Ϸ��ʼ������Դid
    rewardResourceId                              =  9,-- int32 rewardResourceId ,--��Ϸ������Ҫ������Դid-��һ�к͵�����
    callCd                                        =  1,-- int32 callCd 0,--�������кż��
    collectIds                           =  1,-- repeated int32 1 ,--���п����ռ�����Ʒ��Դid����
    publishNumbers                       =  1,-- repeated int32 2 ,--�кź���-Ŀǰ�ͻ��˲�ʹ��
    type                                          =  1,-- int32 type 3,--0��������Ϸ����0Ϊ��������id
    bingoRuleId                          =  1,-- repeated int32 4 ,--����bingo�жϹ���id
    jackpotRuleId                        =  1,-- repeated int32 5 ,--����jackpot�жϹ���id
    bingoLeftTick                        =  1,-- repeated int32 6 ,--�ۼ�ʱ���� �ͻ��� ������Ϸ������ ��λ��1/100��
    robotIds                             =  1,-- repeated int32 7 ,--robotIds����
    powerUpData                 =  1,-- repeated PB_PowerUpData 8,--����powerUp����
    cardCallHitPos                  =  1,-- repeated PB_CardPos 9,--���ֿ�-���нк���������
    cardAllHitPos                   =  2,-- repeated PB_CardPos 0,--���ֿ�-���п�����������
    bingoMax                                      =  2,-- int32 bingoMax 1,--�����bingo��-����ǰ���������
    powerUpCd                                     =  2,-- float powerUpCd 2,--powerUpʹ��cd
    powerUpAcc                                    =  2,-- int32 powerUpAcc 3,--powerUp��������
    mixCallNumbers                       =  2,-- repeated int32 4 ,--��ѡ�����к�
    --int32 hasJackpotReward                            =  25,--�Ƿ����jackpot��������Ч
    groupBagOpenItem       =  2,-- repeated PB_GroupBagOpenItem 6,--�������п���ʳ���Ӵ򿪺�Ľ���,˳���ȡ-˳���
    activityStatus                 =  2,-- repeated PB_ItemInfo 7,--�״̬ id-�id, value- 0 = δ����,1 = ������
    ext                                          =  2,-- string ext 8,--��չ�ֶ�json��ʽ
    jokerData                 =  2,-- repeated PB_JokerCardData 9,--����С������
}
