ArtConfig = {}

--------------------------下面的参数还需要用到的请移到备份来，后面没有移上来的统一删除掉----------------


--------------------------下面的参数还需要用到的请移到备份来，后面没有移上来的统一删除掉----------------

--------------------------通用参数--------------------------------

ArtConfig.BaseSceneLoading_Process_Move_Speed = 0.25                 --基础加载界面，进度条加载速度
ArtConfig.EnterGameLoading_Process_Move_Speed = 0.1                 --进入游戏加载界面，进度条加载速度

ArtConfig.Show_DialogView_Time = 0.3                        --显示提示窗口时间
ArtConfig.Hide_DialogView_Time = 0.2                       --隐藏提示窗口时间

ArtConfig.WAKEUP_DELAY = 0.5
ArtConfig.PAYLINE_HIT_MISS_SYMBOL = 0

-- BINGO 调试签到天数
ArtConfig.BINGO_DEBUG_DAYS = 25

-- BINGO 调试开关
ArtConfig.BINGO_DEBUG_MODE = false

-- BINGO 调试是否可签
ArtConfig.BINGO_DEBUG_READY = true

-- 玩家金币增长时间
ArtConfig.USER_COIN_ADD_TIME = 0.2

--玩家钻石增长时间
ArtConfig.USER_DIAMOND_ADD_TIME = 0.2

ArtConfig.Bgm_fadein_time = 2.0   --背景音渐入时间

ArtConfig.delay_play_superwin = 0.75  --状态机延时进入superwin
ArtConfig.delay_play_superwin_sound = 0.4  --状态机延时播放superwin音效
ArtConfig.Superwin_number_rolling_time =  7   --bigwin数字滚动时间
ArtConfig.SuperWin_delay_enable_btn_time = 0.3 --bigwin 延时开启可点击的按钮时间
ArtConfig.SuperWin_To_BaseGame_time = 3   --bigwin跳basegame下的时间
ArtConfig.SuperWin_Show_time = 10   --bigwin持续时间
------------------------------------------------------------------

ArtConfig.ANIMATION_FRAME_RATE = 60

ArtConfig.FIX_UPDATE_FRAME_RATE = 50
ArtConfig.FIX_UPDATE_INTERVAL = 1000/ArtConfig.FIX_UPDATE_FRAME_RATE

------------------------转轴相关参数------------------------------

-- AutoSpin有中奖线时 进入下一次Spin前播放中奖线的条数
ArtConfig.AUTOSPIN_LINES_BEFORE_NEXT = 2

-- 转轴干预后SPIN按钮禁用的时间
ArtConfig.BTN_SPIN_FORBID_TIME = 1

-- 转轴干预后SPIN按钮禁用的概率
ArtConfig.BTN_SPIN_FORBID_RATE = 0.5




-- 自动旋转 中奖 下次前的等待时间 (从小奖金币跳动结束开始计算)
ArtConfig.AUTOSPIN_DELAY_WITH_PRIZE = 1.5

-- 自动旋转 未中奖 下次前的等待时间 (从小奖金币跳动结束开始计算)
ArtConfig.AUTOSPIN_DELAY_WITHOUT_PRIZE = 0.8

-- TOTALWIN 淡出前的延迟
ArtConfig.TOTALWIN_FADEOUT_DELAY = 0.5

-- TOTALWIN 淡入时间
ArtConfig.TOTALWIN_FADEIN_TIME = 0.25

-- TOTALWIN 淡出时间
ArtConfig.TOTALWIN_FADEOUT_TIME = 0.25
-- 每条中奖线播放时间
ArtConfig.PAYLINE_PLAY_TIME_EACH = 1
-- 触发Feature时 进入Feature播放中奖线的条数
ArtConfig.LINES_BEFORE_FEATURE = 1

ArtConfig.PAYLINE_SHOW_DURATION = ArtConfig.PAYLINE_PLAY_TIME_EACH * 1000
ArtConfig.PAYLINE_SHOW_DURATION_TICKS = math.ceil(ArtConfig.PAYLINE_SHOW_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

--中奖线，在中了feature时skip时间
ArtConfig.PAYLINE_SKIP_ON_FEATURE_DURATION = ArtConfig.PAYLINE_SHOW_DURATION * ArtConfig.LINES_BEFORE_FEATURE
ArtConfig.PAYLINE_SKIP_ON_FEATURE_DURATION_TICKS = math.ceil(ArtConfig.PAYLINE_SKIP_ON_FEATURE_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

--中奖线，在中AUTO模式时skip时间
ArtConfig.PAYLINE_SKIP_ON_AUTO_SPIN_DURATION = ArtConfig.PAYLINE_SHOW_DURATION * ArtConfig.AUTOSPIN_LINES_BEFORE_NEXT
ArtConfig.PAYLINE_SKIP_ON_AUTO_SPIN_DURATION_TICKS = math.ceil(ArtConfig.PAYLINE_SKIP_ON_AUTO_SPIN_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

ArtConfig.FEATRUE_SCATTER_TRIGGER_COUNT_MIN = 3

--scatter 播放动画时间
ArtConfig.SCATTER_ANIM_DURATION = 2 * 1000
ArtConfig.SCATTER_ANIM_DURATION_TICKS = math.ceil(ArtConfig.SCATTER_ANIM_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

--闪电提前消失
ArtConfig.LIGHT_HIDE_DURATION = 200
ArtConfig.LIGHT_HIDE_DURATION_TICKS = math.ceil(ArtConfig.LIGHT_HIDE_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

--转轴底中文字自动切换时间
ArtConfig.INFORMATION_TOGGLE_DURATION = 3000
ArtConfig.INFORMATION_TOGGLE_DURATION_TICKS = math.ceil(ArtConfig.INFORMATION_TOGGLE_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)

ArtConfig.TOTAL_WIN_NUM_ROLL_SPEED_FACT = 0.6

--QUEEN BOARD 数字增长延迟
ArtConfig.LIGHTNING_FEED_BACK_DELAY = 500
ArtConfig.LIGHTNING_FEED_BACK_DELAY_TICKS = math.ceil(ArtConfig.LIGHTNING_FEED_BACK_DELAY/ArtConfig.FIX_UPDATE_INTERVAL)

ArtConfig.PYRAMID_SCATTER_ANIMATION_DURATION = 2000
ArtConfig.PYRAMID_SCATTER_ANIMATION_DURATION_TICKS = math.ceil(ArtConfig.PYRAMID_SCATTER_ANIMATION_DURATION/ArtConfig.FIX_UPDATE_INTERVAL)



-----FreeSpin --------------------------------
--FreeSpin开始前的延时
ArtConfig.DELAY_FREESPIN_BEGIN = 2

-- FreeSpin 打铃开始前的延迟
ArtConfig.DELAY_BEFORE_FREESPIN_RING = 1

-- FreeSpin 打铃开始后的延迟
ArtConfig.DELAY_AFTER_FREESPIN_RING = 2

-- FreeSpin 结算音效开始前的延迟
ArtConfig.DELAY_BEFORE_FREESPIN_RESULT = 1

-- FreeSpin 结算音效开始后的延迟
ArtConfig.DELAY_AFTER_FREESPIN_RESULT = 2

ArtConfig.TREASURE_NORMAL_TO_FREESPIN_TIME = 1


-----------------美人鱼动画效果------------------------------

-- 美人鱼 合并动画 时间
ArtConfig.MERMAID_ANIM_TIME = 1 --3

-- 美人鱼 默认层级
ArtConfig.MERMAID_BASE_LAYER = 2

-- 美人鱼 完整高度
ArtConfig.MERMAID_ANIM_HEIGHT = 612 --618

-- 美人鱼 单格高度
ArtConfig.MERMAID_ICON_HEIGHT = 204 --206

-- 美人鱼 单格宽度
ArtConfig.MERMAID_ICON_WIDTH = 286 --289

-- 美人鱼 大图标 高度
ArtConfig.MERMAID_BIG_ICON_HEIGHT = 612 --616

-- 美人鱼 大图标 宽度
ArtConfig.MERMAID_BIG_ICON_WIDTH = 858 --911

-----------------金币飞行参数-------------------------------------
-- 默认
ArtConfig.COIN_FLY_PARAMETER = {
    -- 默认金币飞行参数
    {time = 1.3, count = 18, interval = 0.06},
    -- 右上（商城Bonus奖励）
    {time = 1.3, count = 18, interval = 0.06},
    -- 中间（视频奖励弹窗，购买）
    {time = 1, count = 50, interval = 0.06},
    -- 弹窗中位置不固定的（任务，邮件等）
    {time = 1.3, count = 18, interval = 0.06},
    -- 右下（每日转盘）
    {time = 1.3, count = 18, interval = 0.06},
    -- 中下（ruby wheel）
    {time = 1.3, count = 18, interval = 0.06},
    --升级
    {time = 1.3, count = 1, interval = 0},

    {time = 1.3, count = 18, interval = 0.06},
    {time = 1.3, count = 18, interval = 0.06},
    {time = 1.3, count = 18, interval = 0.06},

    --海星
    {time = 1.3, count = 18, interval = 0.06},

    -- 七天回归
    {time = 1.3, count = 9, interval = 0.06},
}

---------------------闪电特效-----------------------------------
ArtConfig.Hold_SPin_Increase_Time = 1.5
ArtConfig.Hold_Spin_El_Result_DeltaTime = 1.1 --hold spin 结算闪电间隔

---------------------------龙凤 start ------------------------------------
--10019 再次获得free spin次数
ArtConfig.FREESPIN_ADD_10019 = 3
ArtConfig.FREESPIN_ADD_STOP_10019 = 1.0

ArtConfig.DP_Go_To_Model_Delay = 5  --触发HoldSpin后，没有任何操作时进入Feature的等待时间
ArtConfig.Jackpot_Reward_Delay = 5  --jackpot奖励弹窗的相应等待时间
ArtConfig.Enter_Attack_State_Delay = 6  --有Attack加入，用于显示文字attack add 提示
ArtConfig.Enter_Boost_State_Delay = 5

ArtConfig.Show_Attack_UI_Delay = 5    --第一次攻击时显示攻击UI
ArtConfig.Close_Attack_UI_Delay = 1.5    --攻击UI关闭间隔，影响被攻击时间

ArtConfig.Show_Upgrade_UI_Delay = 5    --第一次攻击时显示攻击UI
ArtConfig.Close_Upgrade_UI_Delay = 1.5    --攻击UI关闭间隔，影响被攻击时间

ArtConfig.Normal_Spin_Jackpot_Delay = 0.2  --普通模式中，闪电特效的延迟时间

--结算，后面要修改结算动画细节，需要重构-----------------
ArtConfig.Battle_Result_Alert_Show_Time = 3  --显示battle over
ArtConfig.Battle_Result_Show_Team_Credit = 5  --显示两队XX:XX

ArtConfig.Battle_Show_PlayerInfo_Time = 2                   --进入对战前，显示头像及玩家信息的延迟时间
ArtConfig.Battle_Enter_Door = 3                            --进入对战前，到开门动画的时间

ArtConfig.Battle_FreeSpin_Count = 8                         --战斗中，freeSpin的次数

ArtConfig.Battle_Show_DuiHuaKuang_UI_Delay = 4               --进入战斗，开门后到显示对战图的间隔
ArtConfig.Battle_Enter_ScrollRolling_State_Delay = 2      --进入战斗，开门后到显示棋盘的间隔时间(比上面长一点)

ArtConfig.Battle_Count_Score_Delta_Time = 0.5           --结算金币时，回收动画间距
ArtConfig.Battle_Result_End_Wait_Time = 3             --战斗结束后,停留的时间

ArtConfig.Battle_FreeSpin_Delta_Time = 1.5           --在战斗过程中，触发额外步数(freeSpin)后，显示动画，回到正常spin的间隔
ArtConfig.Battle_Start_ScorollRoling_Delay = 3     --进入战斗后，显示对战信息，以及开始进入spin状态的时间

ArtConfig.Battle_Show_Final_Round = 1.5              --在战斗过程中，提示最后一步
ArtConfig.Battle_Spin_Attack = 0.8                   --战斗中，发动攻击的间隔(火球降落的间隔)

ArtConfig.Battle_Show_FreeSpinBoard_UI_Delay = 0.5       --设置X秒后，在顶部弹出FreeSpin计数板
ArtConfig.Battle_Spin_Attack_End_Delay = 4               --一轮攻击结束后，下一次的攻击时间或回到正常spin的时间
ArtConfig.Battle_Show_Attack_UI_Delay = 1                --在战斗中，显示Attack图(龙凤)的间隔时间
ArtConfig.Battle_Next_SpinRolling_Delay = 4              --在战斗中，转轴转动的间隔时间(决定何时停)
ArtConfig.Battle_Next_SpinRolling_Wait_Delay = 2         --在战斗中，转轴停止后，停留的时间

ArtConfig.Battle_Start_Upgrade_Delay = 0.2               --启动Upgrade状态的时间
ArtConfig.Battle_Clear_Upgrade_UI_Delay = 0.5             --表示Upgrade已经完毕，清除Upgrade的特效图
ArtConfig.Battle_Enter_Upgrade_Delay = 1.5               --进入UpgradeTrigger状态，判断是否还有Upgrade，否则进入正常Spin
ArtConfig.Battle_ClosePanel_Upgrade_Delay = 4            --关闭Upgrade提示图的时间
ArtConfig.Battle_Show_Upgrade_Grid_UI_Delay = 5          --显示Upgrade特效图(给每个格子)时间
ArtConfig.Battle_Close_Upgrade_Grid_UI_Delay = 1.5

ArtConfig.DP_HoldSpin_Bomb_ShowTime = 1  --- HoldSpin里Bomb爆炸后等待一定时间后更新Bonus数值.
ArtConfig.Battle_Wait_After_Scroll_Rolling = 4
---------------------------龙凤 end ------------------------------------

---------------------------M10002辣椒人机台----------------------
ArtConfig.RapidChillWheelDisappearDelay = 2
--------------------------end --------------------------------------

---------------------------M10003旷工机台----------------------
ArtConfig.Hold_Spin_Collect_Result_DeltaTime = 1 --hold spin 结算bonus数量间隔

ArtConfig.Hold_Spin_Delay_CreateReelTime = 1.5    --火球过后创建轴
ArtConfig.Hold_Spin_Delay_ShowReel = ArtConfig.Hold_Spin_Delay_CreateReelTime + 0.2    --火球过后创建轴,再淡入显示
ArtConfig.Hold_Spin_ShowReel_Time = 1       --轴淡入时间 
ArtConfig.Hold_Spin_ShowLock_Time = ArtConfig.Hold_Spin_Delay_ShowReel + ArtConfig.Hold_Spin_ShowReel_Time   --再显示锁

ArtConfig.Hold_Spin_ShowUnLock_Time = ArtConfig.Hold_Spin_ShowLock_Time+1   --解锁时间
ArtConfig.Hold_Spin_Frist_RollingTime = ArtConfig.Hold_Spin_ShowUnLock_Time +2
--------------------------end --------------------------------------
---------------------------M10005海洋机台---------------------
ArtConfig.PayLine_Delta_Time = 1.5 --消除之前中奖线播放的时间
ArtConfig.Bubble_Fly_Time = 1.5 --气泡飞行的时长
ArtConfig.EnterBattleMinWaittingTime = 5
ArtConfig.BeforeWheel1StartRollTime = 2 --从转盘1出现动画开始播放到转盘1转动之间长
ArtConfig.Wheel1EndRollToShowNextBoard = 2 --从转盘1转动停止到下一个弹窗出现之时长
ArtConfig.WheelTotalWinShowTime = 2 --当次转盘获得奖励界面显示时长
ArtConfig.BeforeWheel2StartRollTime = 2 --从转盘2出现动画开始播放到转盘2转动之间长
ArtConfig.Wheel1EndRollToWheel3Show = 2 --从转盘2转动停止到开始播放转盘3出现动画之时长
ArtConfig.BeforeWheel3StartRollTime = 2 --从转盘3出现动画开始播放到转盘3转动之间长
ArtConfig.Wheel1EndRollToTopWinnerShow = 2 --从转盘3转动停止到top winner弹窗出现动画之时长
ArtConfig.MyTotalWinTextRollingTime = 0.5 --当前积分滚动时长
ArtConfig.MyTotalWinShowTime = 1.2 --当前总分界面展示时间
ArtConfig.NextRoundShowTime = 1.5  --下一轮界面显示时长
ArtConfig.TimeFromBoard2CloseToTreasureShow = 1.5 --转盘2关闭到宝箱出现的时长
ArtConfig.TreasureBoxShowTime = 1 --宝箱下落动画开播到下一个转盘出现时长
ArtConfig.WheelStopToHideWheel3Time = 1 -- 转盘3停转到转盘3开始消失间隔
ArtConfig.Wheel3CloseToTreasureBoxOpen = 2 --转盘3消失到宝箱开启时间间隔
ArtConfig.TreasureBoxOpenTime = 1.5 --宝箱开启时间
ArtConfig.TopWinnerShowTime = 2 --topWinner界面展示时间
---------------------------end--------------------------------

---------------------------周边---------------------
ArtConfig.LimitNameNum = 17 --带有头像框的名字限制字符数
---------------------------end---------------------