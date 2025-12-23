local JackpotEnableViewQuest = BaseDialogView:New("JackpotEnableViewQuest", "JackpotEnableAtlas")
local this = JackpotEnableViewQuest
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
--this.isCleanRes = true
this.auto_bind_ui_items = {
    "animator2",
    "animator3",
    "animator4",
    "animator5",
    "animator6",
    "animator7",
    "animator8",
    "animator9",
    "animator10",
    "animator11",
    "font_jackpot2",
    "font_jackpot3",
    "font_jackpot4",
    "font_jackpot5",
    "font_jackpot6",
    "font_jackpot7",
    "font_jackpot8",
    "font_jackpot9",
    "font_jackpot10",
    "font_jackpot11",
    "animator2",
    "animator3",
    "animator4",
    "animator5",
    "animator6",
    "animator7",
    "animator8",
    "animator9",
    "animator10",
    "animator11",
    "font_enabled2",
    "font_enabled3",
    "font_enabled4",
    "font_enabled5",
    "font_enabled6",
    "font_enabled7",
    "font_enabled8",
    "font_enabled9",
    "font_enabled10",
    "font_enabled11",
}

this.audioMp3 = {
    [1] = "mini_jackpot",
    [2] = "mini_jackpot",
    [3] = "minor_jackpot",
    [4] = "minor_jackpot",
    [5] = "major_jackpot",
    [6] = "major_jackpot",
    [7] = "grand_jackpot",
    [8] = "grand_jackpot",
    [9] = "super_jackpot",
    [10] = "super_jackpot"
}

function JackpotEnableViewQuest:Awake(obj)
    self:on_init()

    self.bet_Item = {
        [1] = self.animator2,
        [2] = self.animator3,
        [3] = self.animator4,
        [4] = self.animator5,
        [5] = self.animator6,
        [6] = self.animator7,
        [7] = self.animator8,
        [8] = self.animator9,
        [9] = self.animator10,
        [10] = self.animator11,
    }

    self.bet_jactpot_type_icon = {
        [1] = self.font_jackpot2,
        [2] = self.font_jackpot3,
        [3] = self.font_jackpot4,
        [4] = self.font_jackpot5,
        [5] = self.font_jackpot6,
        [6] = self.font_jackpot7,
        [7] = self.font_jackpot8,
        [8] = self.font_jackpot9,
        [9] = self.font_jackpot10,
        [10] = self.font_jackpot11,
    }

    self.bet_icon = {
        [1] = self.font_enabled2,
        [2] = self.font_enabled3,
        [3] = self.font_enabled4,
        [4] = self.font_enabled5,
        [5] = self.font_enabled6,
        [6] = self.font_enabled7,
        [7] = self.font_enabled8,
        [8] = self.font_enabled9,
        [9] = self.font_enabled10,
        [10] = self.font_enabled11,
    }

end

function JackpotEnableViewQuest:OnEnable()
    if not self.bet_Item then
        return
    end

    if CityHomeScene and CityHomeScene:CheckEnterHallFromBattle() then
        log.log("游戏返回 不展示特效 JackpotEnableViewQuest")
        return
    end

    local betrate = ModelList.CityModel:GetBetRate() or 1
    self:SetJackpotIcon(betrate)
    if self.bet_Item[betrate] then
        AnimatorPlayHelper.SetAnimationEvent(self.bet_Item[betrate], "ef_Hall_Jackpotcar", function()
            Facade.SendNotification(NotifyName.CloseUI, ViewList.JackpotEnableViewQuest)
        end)

        if this.audioMp3[betrate] then
            UISound.play(this.audioMp3[betrate])
        end

        fun.set_active(self.bet_Item[betrate], true, false)
    else
        -- 不存在此倍数时，直接退出
        Facade.SendNotification(NotifyName.CloseUI, ViewList.JackpotEnableViewQuest)
    end

end

function JackpotEnableViewQuest:on_close()

end

function JackpotEnableViewQuest:OnDisable()
    Event.Brocast(EventName.Event_jackpoview_hide)
end

function JackpotEnableViewQuest:OnDestroy()
    this:Close()
end

--- 当前模式下 jackpot的展示
function JackpotEnableViewQuest:SetJackpotIcon(betrate)
    local playType = ModelList.CityModel.GetPlayIdByCity()
    local jackpot_enable = Csv.GetData("city_play", playType, "jackpot_enable")
    if jackpot_enable and #jackpot_enable > 1 then
        --- 展示bingo ，所有jackpot字体替换成bingo字体
        if jackpot_enable[1] == "1" then
            self.bet_icon[betrate].sprite = AtlasManager:GetSpriteByName(jackpot_enable[2], jackpot_enable[3])
            self.bet_icon[betrate]:SetNativeSize()
        end
    end
end

this.NotifyList = {

}

return this

