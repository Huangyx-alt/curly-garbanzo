local HallofFameGoldUpdatedPosterView = BaseView:New("HallofFameGoldUpdatedPosterView", "TournamentTrueGoldBannerAtlas")
local this = HallofFameGoldUpdatedPosterView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "anima",
    "btn_PlayNow",
    "btn_close",
    "Title",
    "Des"
}

function HallofFameGoldUpdatedPosterView:Awake()
    self:on_init()
end

function HallofFameGoldUpdatedPosterView:on_after_bind_ref()
    AnimatorPlayHelper.Play(self.anima, { "start", "HallofFameUpdatedPosterViewstart" }, false, function()

    end)
end

function HallofFameGoldUpdatedPosterView:OnEnable()
    self.Title.text = Csv.GetData("description", 1930, "description")
    self.Des.text = Csv.GetData("description", 1931, "description")
end

function HallofFameGoldUpdatedPosterView:CloseView(callBack)
    AnimatorPlayHelper.Play(self.anima, { "end", "HallofFameUpdatedPosterViewend" }, false, function()
        if callBack then callBack() end
        Facade.SendNotification(NotifyName.CloseUI, self)
    end)
end

function HallofFameGoldUpdatedPosterView:on_btn_PlayNow_click()
    self:CloseView(function()
        self:OpenNextView()
    end)
end

function HallofFameGoldUpdatedPosterView:on_btn_close_click()
    self:CloseView(function()
        self:OpenNextView()
    end)
end

function HallofFameGoldUpdatedPosterView:OpenNextView()
    local isTrueGoldUser = ModelList.PlayerInfoModel:GetIsTrueGoldUser()
    if ModelList.TournamentModel:IsActivityAvailable() then
        if isTrueGoldUser then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentBlackGoldGuideView)
        else
            Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentGuideView)
        end
    elseif ModelList.HallofFameModel:IsActivityAvailable() then
        if isTrueGoldUser then
            Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFameGoldPosterView)
        else
            Facade.SendNotification(NotifyName.ShowUI, ViewList.HallofFamePosterView)
        end
    end
end

return this

