--WinZoneConst
local M = {}

M.TODAY_NO_LONGER_POPUP = "WinZoneTodayNoLongerPopupPoster"
M.TODAY_TIMESTAMP = "WinZoneTodayTimestamp"
M.ROUND_UNLOCK_RECORD = "RoundUnlockRecord"
M.ROUND_SELECT_RECORD = "WinZoneRoundSelectRecord"
M.FINAL_RANK_RECORD = "WinZoneFinalRankRecord"
M.MANUAL_EXIT_RECORD = "WinZoneManualExitRecord"

M.PosterToggleDefault = 0   --0不勾选，1勾选

M.GameStates =
{
    none = 0,
    chooseRound = 1,
    joinRoom = 2,
    ready = 3,

    disusePlayers = 4,
    waitSelfRelive = 5,
    waitOtherRelive = 6,
    waitClaimReward = 7,
    waitExit = 8,

    battleStage1 = 11,
}

M.PlayerStates =
{
    none = -1,
    ready = 0,
    promote = 1,
    disuse = 2,
    relive = 3,
    placeholder = 100,
}

M.LargeScreenContentType = {
    joinProgress = 1,
    topPlayerInfo = 2,
    readyCountdown = 3,
    waitOtherRelive = 4,
}

M.ReliveMinTime = 1
M.ReliveMaxTime = 3

M.TopPlayerDisplayTime = 2

M.ReadCountDownTime = 5

M.BuffId1 = 33
M.ReliveCoinId = 32

M.UseFrameCreateAvatar = true   --是否开启分帧创建头像

M.ReliveProcessMaxDuration = 30

M.ReliveTimeLimit = 0

M.MinPerPageCapacity1 = 30
M.MinPerPageCapacity2 = 15
M.MinRowNumPerPage = 6

M.PlayerCountPerRow = 5

M.PlaceholderPlayer = {
    avatar = "",
    status = M.PlayerStates.placeholder,
    uid = 3543,
    nickname = "",
    isTop = false,
    rank = 1,
    robot = 1,
    gameProps = {}
}

M.DisusePlayerInterval = 0.5
M.DisusePlayerDelay = 1
M.AutoScrollTime = 0.5

M.UsePlaceholderPlayer = true

M.ShowPromoteTipTypes = {
    succ = 1,
    fail = 2,
}

M.MinPopupReliveDialogTime = 5

M.EnterRecordMode = {
    fromPromoteView1 = 1,
    fromPromoteView2 = 2,
    fromReliveDialog = 3,
}

M.DisableRecordView = false

M.PlayId = 17

M.CelebratePromoteAnimTime1 = 1
M.CelebratePromoteAnimTime2 = 1

M.DelayShowContinueBtnTime = 3

M.ShowRestartDialogMode = {
    lose = 1,       --输了（没有拿到前3）
    win = 2,        --赢了（拿到前3）
    upgrade = 3,    --解锁了新的选局
}

M.ManualExitType = {
    lobby = 1,       --对战大厅中退出
    battle = 2,      --游戏中退出 
}

----------------------------------------音效（语音）----------------------------------------begin
M.ThirdDelay = 0
M.SecondDelay = 0
M.FirstDelay = 0
M.ThirdTime = 1.98
M.SecondTime = 1.6
M.FirstTime = 2.89

M.Welcome1Delay = 0
M.Welcome2Delay = 3
M.Welcome3Delay = 3
M.Welcome1Time = 2.1
M.Welcome2Time = 3.8
M.Welcome3Time = 2.1

M.Welcome0Delay = 1.3   --拉开帷幕用时
----------------------------------------音效（语音）----------------------------------------end

return M