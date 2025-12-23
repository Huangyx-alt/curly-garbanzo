
local HallCityBannerItem = require "View/HallCityBanner/HallCityBannerItem"
local HallCityRecommendGameBannerItem = HallCityBannerItem:New("HallCityRecommendGameBannerItem","RecommendGameBannerAtlas")
local this = HallCityRecommendGameBannerItem
local base = HallCityBannerItem
local  recommendId = 1

this.auto_bind_ui_items ={
    "left_time",
    "left_time_txt",
    "bg",
}

function HallCityRecommendGameBannerItem:OnEnable()
    base.OnEnable(self)
    self:InitTime()
    recommendId =  ModelList.CityModel:GetRecommendid()
    ViewTool:LoadRecommendGameSprite(self.bg)
end

function HallCityRecommendGameBannerItem:OnDisable()
    base.OnDisable(self)
end

function HallCityRecommendGameBannerItem:GetLeftTime()
    local leftTime = -1
    return leftTime
end

function HallCityRecommendGameBannerItem:HitBannerFunc()
    log.log("HallCityRecommendGameBannerItem click")

    --传入某个城市id 得参数
    local recommendId = recommendId or 4
    local recommdData =  Csv.GetData("feature_enter",recommendId)
    local cityPlayId = nil
    if recommdData ~= nil and recommdData.city_play then
        cityPlayId = recommdData.city_play
    end

    local cityplay = cityPlayId or 7
    local Macheindata = deep_copy(MachinePortalManager.get_portal_data_by_machine())
    local MachineItemData = nil
    local PlayData =  Csv.GetData("city_play",cityplay)
    if Macheindata and type(Macheindata) == "table"  then
        for _,v in pairs(Macheindata) do
            if  cityplay == v.playId then
                MachineItemData = deep_copy(v)
                break;
            end
        end

        if not MachineItemData then
            log.r("MachineItemData ,not data "..cityplay)
        else
            local version = MachineDownloadManager.read_machine_local_version(MachineItemData.machine_id)
            if version ~= nil  then --也有可能正在下载
                if  version >= MachineItemData.version then --已下载
                    local tmpmodData = Csv.GetData("modular",MachineItemData.machine_id)
                    if resMgr then
                        --TODO by LwangZg 运行时热更部分
                        resMgr:RefreshModuleInfo(tmpmodData.modular_name)
                    elseif LuaHelper.GetResManager()  then
                        LuaHelper.GetResManager():RefreshModuleInfo(tmpmodData.modular_name)
                    end


                    ModelList.BattleModel.RequireModuleLua(tmpmodData.modular_name)

                    --跳转到固定城市
                    Facade.SendNotification(NotifyName.SceneCity.Click_City_Enter,nil,PlayData.city_id,cityplay)
                else
                    if MachineDownloadManager.is_machine_downloading(MachineItemData.machine_id) then
                        --下载中
                    else
                        --未下载
                        --展示特殊玩法界面
                        Facade.SendNotification(NotifyName.ShowUI, ViewList.SpecialGameplayView,nil,nil,nil)
                    end
                end
            else
                log.r("  error   error  error  error  error  error status not Download ")
            end
        end
    end

end

return this