1.大厅icon    
    活动时间   跳转逻辑（有无任务区别）

需要接口：GetRemainTime取剩余活动时间
2.VolcanoMissionStartView       活动入口      prize奖励     描述
需要接口：
GetRemainTime取剩余活动时间
IsActivityAvailable判断活动是否开启

3.VolcanoJoinRoomView  组合集合  prize  
每次匹配完成后端下发数据之后，需要打开匹配界面，需要监听后端匹配完成通知
需要接口：
GetMapMembers取匹配到的所有玩家的数据

4.VolcanoMissionMainView  
任务主界面    
help入口    
level   players 描述 填充
icon跳礼包   
节点宝箱 提示买宝箱 跳转
buff倒计时
活动倒计时
地图   地图生成  玩家生成  宝箱生成 跳节点 
开宝箱奖励

收集物填充，进度条
收集描述走配置

复活弹窗


数据：
curLevel,levelCout,expiredtime,buffexpiredtime,




5.VolcanoMissionRewardView  最终大奖


6.VolcanoMissionHelpView   帮助页面


7.VolcanoMissionGiftPackView 礼包


------------------------------------------
model:
VolcanoMissionModel





state:状态机


init 初始化ui

UpdateRound回合更新 
updateCollect收集更新 

Faild跳失败
LevelUp跳下个节点 

Revive复活
Reward播放奖励

idle  


init----datachange---->UpdateRound------------>updateCollect
    ------------------>idle                                 


updateCollect-------isFaild---->Faild
            ---------IsLevelUp-----LevelUp


Faild---------------Revive




LevelUp----------------Reward


Reward----------idle


----------------------TODO_______________________


1.战斗后，奖励变化弹窗
2.地图tips处理
3.