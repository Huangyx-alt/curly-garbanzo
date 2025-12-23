local VolcanoMissionJackpotEnableView = BaseDialogView:New("VolcanoMissionJackpotEnableView", "JackpotEnableAtlas")
local this = VolcanoMissionJackpotEnableView
this.viewType = CanvasSortingOrderManager.LayerType.Machine_Dialog
--this.isCleanRes = true
this.auto_bind_ui_items = {
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
    "ItemImage1",
    "ItemImage2",
    "ItemImage3",
    "ItemImage4"
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

local Level2Dragon = { "FireDragonJPc01", "FireDragonJPc02", "FireDragonJPc03", "FireDragonJPc04" }
local Level2ImageLeft = { "FireDragonJCMini02", "FireDragonJCMinor02", "FireDragonJCMajor02", "FireDragonJCGrand02" }
local Level2ImageRight = { "FireDragonJCMini01", "FireDragonJCMinor01", "FireDragonJCMajor01", "FireDragonJCGrand01" }

function VolcanoMissionJackpotEnableView:Awake(obj)
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

function VolcanoMissionJackpotEnableView:OnEnable()
    if not self.bet_Item then
        return
    end

    local betrate = ModelList.CityModel:GetBetRate() or 1
    self:SetJackpotIcon(betrate)
    if self.bet_Item[betrate] then
        self:SetItem(betrate)
        AnimatorPlayHelper.SetAnimationEvent(self.bet_Item[betrate], "VolcanoMissionJackpotEnableView", function()
            Facade.SendNotification(NotifyName.CloseUI, ViewList.VolcanoMissionJackpotEnableView)
        end)

        if this.audioMp3[betrate] then
            UISound.play(this.audioMp3[betrate])
        end

        fun.set_active(self.bet_Item[betrate], true, false)
    else
        -- 不存在此倍数时，直接退出
        Facade.SendNotification(NotifyName.CloseUI, ViewList.VolcanoMissionJackpotEnableView)
    end
end

function VolcanoMissionJackpotEnableView:on_close()

end

function VolcanoMissionJackpotEnableView:OnDisable()
    Event.Brocast(EventName.Event_jackpoview_hide)
end

function VolcanoMissionJackpotEnableView:OnDestroy()
    this:Close()
end

--- 当前模式下 jackpot的展示
function VolcanoMissionJackpotEnableView:SetJackpotIcon(betrate)
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

function VolcanoMissionJackpotEnableView:SetItem(betrate)
    --取展示道具
    local singleCardCost = ModelList.CityModel:GetCostCoin(1)
    if ModelList.CityModel:GetEnterGameMode() == PLAY_TYPE.PLAY_TYPE_AUTO_TICKET then
        singleCardCost = ModelList.CityModel:GetCostCoin(4) / 4
    end
    local cfg = table.find(Csv["volcano_putin"], function(k, v)
        local range = v.coin_range
        return range[1] <= singleCardCost and singleCardCost <= range[2]
    end)
    if not cfg then
        return
    end
    
    local root = self.bet_Item[betrate].transform
    
    local refer = fun.get_component(root, fun.REFER)
    local pt02, pt02_2 = refer:Get("pt02"), refer:Get("pt02_2")
    local coins1, coins2 = refer:Get("coins1"), refer:Get("coins2")
    local FireDragon = refer:Get("FireDragon")

    local itemLevel = Csv.GetItemOrResource(cfg.prop_type, "level")
    Cache.GetSpriteByName("VolcanoMissionHallBetAtlasInMain", Level2ImageLeft[itemLevel], function(sprite)
        if not fun.is_null(sprite) then
            coins2.sprite = sprite
        end
    end)
    Cache.GetSpriteByName("VolcanoMissionHallBetAtlasInMain", Level2ImageRight[itemLevel], function(sprite)
        if not fun.is_null(sprite) then
            coins1.sprite = sprite
        end
    end)
    Cache.GetSpriteByName("VolcanoMissionHallBetAtlasInMain", Level2Dragon[itemLevel], function(sprite)
        if not fun.is_null(sprite) then
            FireDragon.sprite = sprite
        end
    end)

    if self["ItemImage"..itemLevel] then
        local texture = self["ItemImage"..itemLevel].mainTexture
        if pt02 then pt02.material.mainTexture = texture end
        if pt02_2 then pt02_2.material.mainTexture = texture end
    end
end

this.NotifyList = {

}

return this


