local SeasonCardAlbumPageView = require "View/SeasonCard/SeasonCardAlbumPageView"
local Toolkit = require "View/SeasonCard/Toolkit"
local SeasonCardAlbumView = BaseView:New("SeasonCardAlbumView", "SeasonCardHistory")
local this = SeasonCardAlbumView
local lastBgmName

this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
fun.ExtendClass(this, fun.ExtendFunction.mutual)

this.auto_bind_ui_items = {
    "btn_close",
    "btn_help",
    "PageView",
    "PageItem",
    "AlbumItem",
    "btn_next_page",
    "btn_pre_page",
    "lbl_Indicator",
    "IndicatoPanel",
    "anima",
}

function SeasonCardAlbumView:Awake()
end

function SeasonCardAlbumView:OnEnable()
    Facade.RegisterViewEnhance(self)
    self:ClearMutualTask()
end

function SeasonCardAlbumView:on_after_bind_ref()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"enter", "SeasonCardAlbumViewenter"}, false, function() 
            self:MutualTaskFinish()
        end)
    end
    self:DoMutualTask(task)

    fun.set_active(self.AlbumItem, false)
    self:InitPageView()
    self:FillPageView()
end

function SeasonCardAlbumView:InitPageView()
    local pg = fun.get_component(self.PageView, fun.PAGEVIEW)
    self.pageViewCtr = pg

    pg:AddLuaListener("OnBeginDrag", function(idx)
        self:OnBeginDrag(idx)
    end)

    pg:AddLuaListener("OnEndDrag", function(idx)
        self:OnEndDrag(idx)
    end)

    pg:AddLuaListener("OnDrag", function(idx)
        self:OnDrag(idx)
    end)

    pg:AddLuaListener("OnIndexChange", function(idx, lastIdx)
        self:OnIndexChange(idx, lastIdx)
    end)
end

function SeasonCardAlbumView:OnBeginDrag(idx)
    log.log("SeasonCardAlbumView:OnBeginDrag", idx)
end

function SeasonCardAlbumView:OnDrag(idx)
end

function SeasonCardAlbumView:OnEndDrag(idx)
    log.log("SeasonCardAlbumView:OnEndDrag", idx)
end

function SeasonCardAlbumView:OnIndexChange(idx, lastIdx)
    log.log("SeasonCardAlbumView:OnIndexChange", lastIdx, "->", idx)
    local pageCount = self.pageViewCtr.PageCount
    --undo 临时方案，基于当前页数为3
    if math.abs(idx - lastIdx) > 1 or idx >= pageCount then
        return
    end

    self.lbl_Indicator.text = (idx + 1) .. "/" .. pageCount

    fun.enable_button_with_child(self.btn_pre_page, idx ~= 0)
    Util.SetUIImageGray(self.btn_pre_page.gameObject, idx == 0)

    fun.enable_button_with_child(self.btn_next_page, idx ~= (pageCount - 1))
    Util.SetUIImageGray(self.btn_next_page.gameObject, idx == (pageCount - 1))
end

function SeasonCardAlbumView:FillPageView()
    self.pageViewCtr:ClearAllPages()

    local albums = ModelList.SeasonCardModel:GetAlbums()
    if not albums or #albums < 1 then
        return
    end

    local pageCount = math.ceil(#albums / 9)
    for idx = 1, pageCount do
        local pageData = {}
        pageData.index = idx
        pageData.seasonIds = {}
        
        for i = (idx - 1) * 9 + 1, idx * 9 do
            if i <= #albums then
                table.insert(pageData.seasonIds, albums[i].seasonId)
            else
                break
            end
        end
        pageData.seasonCount = #pageData.seasonIds
        self:CreatePage(pageData)
    end

    self.pageViewCtr.dragEnable = pageCount > 1
    fun.set_active(self.IndicatoPanel, pageCount > 1)
    --self.lbl_Indicator.text = "1/" .. pageCount
    self:OnIndexChange(0, -1)
end

function SeasonCardAlbumView:CreatePage(pageData)
    local go = fun.get_instance(self.PageItem)
    local rt = fun.get_component(go, fun.RECT)
    fun.set_active(go, true)
    self.pageViewCtr:AddPage(rt)
    local page = SeasonCardAlbumPageView:New()
    page:SetData(pageData)
    page:SkipLoadShow(go)
end

function SeasonCardAlbumView:SetData(data)
    self.data = data
    self.seasonId = data.seasonId
end


function SeasonCardAlbumView:OnDisable()
    Facade.RemoveViewEnhance(self)
    self:RemoveTimer()
end

function SeasonCardAlbumView:RemoveTimer()
    if self.loopTime then
        LuaTimer:Remove(self.loopTime)
        self.loopTime = nil
    end
end

function SeasonCardAlbumView:CloseSelf()
    local task = function()
        AnimatorPlayHelper.Play(self.anima, {"end", "SeasonCardAlbumViewend"}, false, function()
            self:MutualTaskFinish()
            Facade.SendNotification(NotifyName.CloseUI, self)
        end)
    end
    self:DoMutualTask(task)
    --Facade.SendNotification(NotifyName.CloseUI, self)
end

function SeasonCardAlbumView:on_btn_close_click()
    self:CloseSelf()
end

function SeasonCardAlbumView:on_btn_next_page_click()
    log.log("SeasonCardAlbumView:on_btn_next_page_click")
    --self.pageViewCtr:MoveByIndex(1)
    self.pageViewCtr:NextPage()
end

function SeasonCardAlbumView:on_btn_pre_page_click()
    log.log("SeasonCardAlbumView:on_btn_pre_page_click")
    --self.pageViewCtr:MoveByIndex(-1)
    self.pageViewCtr:PrePage()
end

function SeasonCardAlbumView:OnSwitchAlbum(params)
    self:CloseSelf()
end

function SeasonCardAlbumView:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyEnhanceList =
{
    {notifyName = NotifyName.SeasonCard.SwitchAlbum, func = this.OnSwitchAlbum},
    {notifyName = NotifyName.SeasonCard.ForceExit, func = this.OnForceExit},
}

return this