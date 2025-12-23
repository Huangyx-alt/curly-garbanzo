require "State/Common/CommonState"

local TournamentTrophyView = BaseView:New("TournamentTrophyView","TournamentAtlas")
local this = TournamentTrophyView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole

this.auto_bind_ui_items = {
    "btn_close",
    "img_portrait",
    "slid_exp",
    "text_leaf",
    "text_exp",
    "text_userName",
    "text_tournament",
    "trophy_item",
    "content",
    "anima",
    "imageFrame",
}

function TournamentTrophyView:Awake(obj)
    self:on_init()
end

function TournamentTrophyView:OnEnable(params)
    Facade.RegisterView(self)
    CommonState.BuildFsm(self,"TournamentTrophyView")
    self:SetInfo()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"in","TournamentRewardViewenter2"},false,function()
            self._fsm:GetCurState():DoCommonState1Action(self._fsm,"CommonOriginalState")
        end)
    end)
    self:RebindSprite()
end

function TournamentTrophyView:OnDisable()
    Facade.RemoveView(self)
    CommonState.DisposeFsm(self)
end

function TournamentTrophyView:on_btn_close_click()
    self._fsm:GetCurState():DoOriginalAction(self._fsm,"CommonState1State",function()
        AnimatorPlayHelper.Play(self.anima,{"out","TournamentRewardViewexit2"},false,function()
            Facade.SendNotification(NotifyName.CloseUI,self)
        end)
    end)
end

function TournamentTrophyView:CheckIsPlayer(uid)
    local myUid = ModelList.PlayerInfoModel.GetUid()
    return myUid == uid
end

function TournamentTrophyView:SetInfo()
    local playerInfo = ModelList.TournamentModel:GetPlayerInfo()
    if playerInfo then
        if self:CheckIsPlayer(playerInfo.uid) then
            self.text_exp.text = tostring(playerInfo.exp)
            self.slid_exp.value = playerInfo.exp / playerInfo.fullExp
            Cache.SetImageSprite("HeadAtlas",fun.get_strNoEmpty(playerInfo.avatar, "xxl_head016"),self.img_portrait)
            self.text_userName.text = string.format("User_%s",playerInfo.uid)
        else
            local model = ModelList.PlayerInfoSysModel

            if playerInfo.nickname == nil or playerInfo.nickname == "" then
                local robotName = Csv.GetData("robot_name",tonumber(playerInfo.uid),"name")
                if robotName then
                    self.text_userName.text = robotName
                else
                    self.text_userName.text = string.format("User_%s",playerInfo.uid)
                end
            else
                self.text_userName.text = tostring(playerInfo.nickname)
            end

            if playerInfo.avatar and playerInfo.avatar ~= "" then
                model:LoadTargetHeadSprite(playerInfo.avatar , self.img_portrait)
            else
                model:LoadRobotTargetHeadSprite(playerInfo.uid , self.img_portrait)
            end
            
            if playerInfo.frame and playerInfo.frame ~= "" then
                model:LoadTargetFrameSprite(tostring(playerInfo.frame) , self.imageFrame)
            else
                model:LoadRobotTargetFrameSprite(playerInfo.uid,  self.imageFrame)
            end

            --判断数据需要从前端配置表获取
            if playerInfo.robot == 1 or not playerInfo.fullExp or playerInfo.fullExp == 0 or playerInfo.fullExp == "" then
                local level = Csv.GetData("robot_name",tonumber(playerInfo.uid),"level")
                self.text_leaf.text = level or 1
                local expPer = Csv.GetData("robot_name",tonumber(playerInfo.uid),"exp") or 0
                local per = tonumber(expPer)
                self.text_exp.text = string.format("%s%s", per * 100 , "%")
                self.slid_exp.value = per
            else
                self.text_leaf.text = playerInfo.level
                self.text_exp.text = tostring(playerInfo.exp)
                self.slid_exp.value = playerInfo.exp / playerInfo.fullExp
            end

        end

        local view = require("View/Tournament/TrophyItem")
        for index, value in ipairs(playerInfo.tiersMedal) do
            local go = fun.get_instance(this.trophy_item,this.content)
            local item = view:New(value)
            item:SkipLoadShow(go)
            fun.set_active(go.transform,true)
        end
    end
end

--- 此处会有一个丢资源白图问题，重新绑定一次
function TournamentTrophyView:RebindSprite()
    if self.go then
        local child = fun.find_child(self.go,"SafeArea/Image")
        if child then
            self:RebindChildSprite("SafeArea/Image","ZBTcGrxxDi02")
            self:RebindChildSprite("SafeArea/ZBTcGrxxTx","ZBTcGrxxTx")
            self:RebindChildSprite("SafeArea/ZBTcTiaoMu02","ZBTcTiaoMu02")
            self:RebindChildSprite("SafeArea/ZBTcTiaoMu02/ZBTcGrCd","ZBTcGrCd")
        end
    end
end

function TournamentTrophyView:RebindChildSprite(path, spriteName)
    local child = fun.find_child(self.go,path)
    if child then
        local img = fun.get_component(child,fun.IMAGE)
        if img then
            img.sprite = AtlasManager:GetSpriteByName("TournamentAtlas",spriteName)
        end
    end
end

this.NotifyList =
{

}

return this