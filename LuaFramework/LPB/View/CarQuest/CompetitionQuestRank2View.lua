local CompetitionQuestRank2View = BaseDialogView:New('CompetitionQuestRank2View')
local this = CompetitionQuestRank2View
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local ItemEntityCache = {}

this.auto_bind_ui_items = {
    "anima",
    "rankTopPanel",
    "btn_collect",
    "personParent", --底部
    "img_countdown"
}

function CompetitionQuestRank2View:Awake()
end

function CompetitionQuestRank2View:OnEnable()
    --收到结束时的奖励信息
    UISound.play("racinglist")

    Facade.RegisterView(self)
end

function CompetitionQuestRank2View:on_after_bind_ref()
  
    self:InitView()
end

function CompetitionQuestRank2View:InitView()
    --前三名
    local racingdata = ModelList.CarQuestModel:GetRacingData()
    local Rect =fun.get_component(self.personParent,fun.RECT)
    local lastScore = 1000000000;--有一定数值溢出得风险
    local firstScore = 0;
    
    
    if (racingdata and racingdata.showRankList ) then 
        local index = 0
        for _,v in pairs( racingdata.showRankList) do 
            local item = fun.find_child(self.rankTopPanel,"Person"..tostring(v.order))
            if item then 
                self:SetImgHead(item,v)
            end 
            if lastScore >= v.score then 
                lastScore = v.score
            end
            if firstScore <= v.score then 
                firstScore = v.score
            end 
            -- local downItem = fun.find_child(self.personParent,"Person"..tostring(index)) 
            -- if downItem then 
            --     self:SetImgHeadDown(downItem,v,Rect)
            -- end 
        end 

        local ratedata = {first =firstScore ,last = lastScore}
        log.g("firstScore = ".. tostring(firstScore).." lastScore= "..tostring(lastScore))
        for _,v in pairs( racingdata.showRankList) do 
            index = index + 1
            local downItem = fun.find_child(self.personParent,"Person"..tostring(index)) 
            if downItem then 
                fun.set_active(downItem,false)

                if v.order == 0 then 
                    fun.set_active(downItem,true)
                    self:SetImgHeadDown(downItem,v,Rect,ratedata)
                end 
                
            end 
        end 
    end 

    self.img_countdown.text =  "S"..tostring(racingdata.groupId ) 

end

function CompetitionQuestRank2View:SetImgHead(item,data)
    local ref = fun.get_component(item,fun.REFER)
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)
    local imgHead = ref:Get("img_head")
    local imageFrame = ref:Get("imageFrame")
    local Tip = ref:Get("Tip")
    if fun.is_not_null(imgHead) then
        if data.robot == 0 then
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
        else
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
        end

        local model = ModelList.PlayerInfoSysModel
        model:LoadOwnFrameSprite(imageFrame)
        if isSelf then 
            Tip.text = "YOU"
            Tip.color = Color(251/255, 219/255, 100/255, 1)
        else 
            Tip.text = data.nickname
            Tip.color = Color(1, 1, 1, 1)
        end 

    end 
end 

function CompetitionQuestRank2View:SetImgHeadDown(item,data,rect,ratedata)
    local downWidth = rect.rect.width 
    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)
    local ref = fun.get_component(item,fun.REFER)
    local imgHead = ref:Get("img_head")
    local imageFrame = ref:Get("imageFrame")
    local Tip = ref:Get("Tip")
    local itemPos = fun.get_gameobject_pos(item,true)
    local ratio =((data.score - ratedata.last) /(ratedata.first - ratedata.last)) +0.1 ;
    local model = ModelList.PlayerInfoSysModel
    
    ratio = ratio > 1 and 1 or ratio


    log.g("SetImgHeadDown ratio " .. tostring(ratio).." socre =".. tostring(data.score))
    fun.set_gameobject_pos(item ,downWidth *ratio,itemPos.y,itemPos.z,true)
    if fun.is_not_null(imgHead) then 
        if data.robot == 0 then
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(imgHead)
        else
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, imgHead)
        end

        model:LoadOwnFrameSprite(imageFrame)

        if isSelf then 
            fun.set_gameobject_scale(item,0.54,0.54,1)
            fun.set_active(Tip,true)
        else 
            fun.set_gameobject_scale(item,0.45,0.45,1)
            fun.set_active(Tip,false)
        end 

    end 
end 

function CompetitionQuestRank2View:OnDisable()
    Facade.RemoveView(self)
end

function CompetitionQuestRank2View:GetItemViewInstance(index)
    local view = require "View/GiftPack/GiftPackSweetmeats/GiftPackSweetmeatsItem"
    local view_instance = nil
    
    if ItemEntityCache[index] == nil then
        local item = fun.find_child(self.rankTopPanel,"Person"..tostring(v.order))

        if item ~= nil then 
            fun.set_active(item,true)
            view_instance = view:New()
            view_instance:SkipLoadShow(item)
            ItemEntityCache[index] = view_instance
        end 
       
    
    else
        view_instance = ItemEntityCache[index]
    end 
    
    return view_instance
end 


function CompetitionQuestRank2View:CloseSelf()
   
    Facade.SendNotification(NotifyName.CloseUI, self)
end

local startTime =0
--手动领取奖励并开启活动选择界面
function CompetitionQuestRank2View:on_btn_collect_click()
    if  UnityEngine.Time.time  - startTime <6 then 
        return
    end 
    startTime =UnityEngine.Time.time
    ModelList.CarQuestModel.ReqRacingRankReward()
   
end

function CompetitionQuestRank2View.OnGetRankReward()
    AnimatorPlayHelper.Play(this.anima, {"end","CompetitionQuestRankView_end"},false,function()
        Facade.SendNotification(NotifyName.ShowUI,ViewList.ActivitesChoiceView)
        --Event.Brocast(EventName.Event_popup_competition_finish)
        Facade.SendNotification(NotifyName.CloseUI, this)
    end)
end 



function CompetitionQuestRank2View:OnForceExit(params)
    self:CloseSelf()
end

--设置消息通知
this.NotifyList =
{
    {notifyName = NotifyName.CarQuest.GetRankReward, func = this.OnGetRankReward}
}

return this