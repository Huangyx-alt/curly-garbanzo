MachineArtConfigBase = Clazz()

------------bigWin流程------------
MachineArtConfigBase.TOTALWIN_AFTERBIGWIN_TIME = 0.5 -- bigwin结束后再播放totalwin的滚动时长

------------freeSpin流程------------
MachineArtConfigBase.freespin_trigger_click_dialog_delay_change_model = 1.3--freesin触发时,点完弹窗延时n秒后切换场景

------------holdSpin流程------------
MachineArtConfigBase.holdspin_trigger_delay_show_dialog = 0.8--holdspin触发时,延时显示弹窗


---------------BaseGame通用流程------------
MachineArtConfigBase.kickback_pre_time = 0 --距离最低点提前多久播show动画




------------翻牌子玩法流程------------
MachineArtConfigBase.turncard_trigger_click_dialog_delay_change_model = 0.8--翻牌子触发时,点完弹窗延时n秒后切换场景

------------所有对战玩法结算通用流程--------------
MachineArtConfigBase.battle_result_win_item_show_delta_time = 0.6--对战结算两个结果滑入的时间间隔





function  MachineArtConfigBase:Get(keyName)
    
    if(self[keyName]) then 
        return self[keyName] 
    end
    log.r(keyName .. "找不到参数值")
    return 0 
end

return MachineArtConfigBase