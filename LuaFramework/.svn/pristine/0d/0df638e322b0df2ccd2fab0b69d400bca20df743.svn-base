local CompetitionQuestReadyRankItem = Clazz()
local this = CompetitionQuestReadyRankItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "img_head",
    "imageFrame",
    "Tip",
}

function CompetitionQuestReadyRankItem:New(rankInfo, root)
    local o = {}
    self.__index = self
    setmetatable(o, self)

    o.rankInfo = rankInfo
    o.root = root
    
    return o
end

function CompetitionQuestReadyRankItem:GetRefer(key)
    if fun.is_null(self.root) then
        return
    end
    
    if not self.refer then
        self.refer = fun.get_component(self.root, fun.REFER)
    end
    if self.refer then
        local ret = self.refer:Get(key)
        return ret
    end
end

function CompetitionQuestReadyRankItem:Show()
    if fun.is_null(self.root) then
        return
    end
    fun.set_active(self.root, true)
    
    --You标签
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(self.rankInfo.uid)
    local tipCtrl = self:GetRefer("Tip")
    fun.set_active(tipCtrl, isSelf)

    local img_head = self:GetRefer("img_head")
    if fun.is_not_null(img_head) then
        --头像
        if self.rankInfo.robot == 0 then
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(img_head)
        else
            local avatar = fun.get_strNoEmpty(self.rankInfo.avatar, Csv.GetData("robot_name", tonumber(self.rankInfo.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, img_head)
        end
        
        --头像框
        local model = ModelList.PlayerInfoSysModel
        local imageFrame = self:GetRefer("imageFrame")
        if isSelf then
            model:LoadOwnFrameSprite(imageFrame)
        else
            local useFrameName = model:GetCheckFrame(nil, self.rankInfo.uid)
            model:LoadTargetFrameSpriteByName(useFrameName, imageFrame)
        end
    end
end

return this