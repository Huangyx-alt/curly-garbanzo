local CompetitionQuestRankView = BaseDialogView:New('CompetitionQuestRankView')
local this = CompetitionQuestRankView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local ItemEntityCache = {}

this.auto_bind_ui_items = {
    "anima",
    "rankTopPanel",
    "btn_collect",
    "img_countdown"
}


function CompetitionQuestRankView:Awake()
end

function CompetitionQuestRankView:OnEnable()
    --收到结束时的奖励信息
    UISound.play("racinglist")
    Facade.RegisterView(self)
end

function CompetitionQuestRankView:on_after_bind_ref()
    
    self:InitView()
end

function CompetitionQuestRankView:OnDisable()
    Facade.RemoveView(self)
    for i, v in pairs(ItemEntityCache) do
	    v:Close()
	end
    ItemEntityCache = {}
  
end

function CompetitionQuestRankView:CloseSelf()
    
    Facade.SendNotification(NotifyName.CloseUI, self)
end

local startTime =0
function CompetitionQuestRankView:on_btn_collect_click()
    --领取奖励
    --关闭奖励
    --结束order状态
    if  UnityEngine.Time.time  - startTime <6 then 
        return
    end 
    startTime = UnityEngine.Time.time
 
    
    ModelList.CarQuestModel.ReqRacingRankReward()
   
end

function CompetitionQuestRankView:OnForceExit(params)
    self:CloseSelf()
end

function CompetitionQuestRankView:InitView()
    local racingdata = ModelList.CarQuestModel:GetRacingData()
  
    if (racingdata and racingdata.showRankList ) then 
        for _,v in pairs( racingdata.showRankList) do 
            local view_instance = this:GetItemViewInstance(v.order)
            if view_instance ~= nil then 
                view_instance:Updata(v)
            end 
        end 
    end 
    if self.img_countdown then 
        self.img_countdown.text =  "S"..tostring(racingdata.groupId ) 
    end 
end


function CompetitionQuestRankView:GetItemViewInstance(index)
    local view = require "View/CarQuest/CompetitionQuestRankItem"
    local view_instance = nil
    
    if ItemEntityCache[index] == nil then
        local item = fun.find_child(self.rankTopPanel,"Person"..tostring(index))
        if item ~= nil then 
            view_instance = view:New()
            view_instance:SkipLoadShow(item)
            ItemEntityCache[index] = view_instance
        end 
    else 
        view_instance = ItemEntityCache[index]
    end 
    

    return view_instance
end 

function CompetitionQuestRankView.OnGetRankReward()
    AnimatorPlayHelper.Play(this.anima,{"end","CompetitionQuestRankView_end"},false,function()
        Facade.SendNotification(NotifyName.ShowUI,ViewList.ActivitesChoiceView)
        --Event.Brocast(EventName.Event_popup_competition_finish)
        Facade.SendNotification(NotifyName.CloseUI, this)
    end)
end 


--设置消息通知
this.NotifyList =
{
    {notifyName = NotifyName.CarQuest.GetRankReward, func = this.OnGetRankReward}
}



return this