local CompetitionQuestRankItem = BaseView:New("CompetitionQuestRankItem")
local this = CompetitionQuestRankItem
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
   "img_head",
   "imageFrame",
   "Tip",
   "ScoreText",
}   

function CompetitionQuestRankItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function CompetitionQuestRankItem:Awake()
    self:on_init()
end


function CompetitionQuestRankItem:OnEnable(data)
   
end

function CompetitionQuestRankItem:Updata(data)
   

    local myUid = ModelList.PlayerInfoModel:GetUid()
    local isSelf = myUid == tonumber(data.uid)
    local tipCtrl = self.Tip
  
    local img_head = self.img_head
    self.ScoreText.text = tostring(data.score) 
    if fun.is_not_null(img_head) then
        --头像
        if data.robot == 0 then
            tipCtrl.text = data.nickname
            ModelList.PlayerInfoSysModel:LoadOwnHeadSprite(img_head)
        else
          
            local avatar = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "icon"))
            avatar = fun.get_strNoEmpty(avatar, "xxl_head016")
            Cache.SetImageSprite("HeadAtlas", avatar, img_head)

            local nickname = fun.get_strNoEmpty(data.avatar, Csv.GetData("robot_name", tonumber(data.uid), "name"))
            tipCtrl.text = nickname
        end
        
        --头像框
        local model = ModelList.PlayerInfoSysModel
        local imageFrame = self.imageFrame
        if isSelf then
            model:LoadOwnFrameSprite(imageFrame)
            if data.order <= 3 then --前3名情况下
                tipCtrl.text = "You"
                tipCtrl.color = Color(251/255, 219/255, 100/255, 1)
            else 
                tipCtrl.text = data.nickname
            end 
        else

         
            if data.order <= 3 then 
                tipCtrl.color = Color(1, 1, 1, 1)
            end 

            local useFrameName = model:GetCheckFrame(nil, data.uid)
            model:LoadTargetFrameSpriteByName(useFrameName, imageFrame)
            
        end
    end
end 

function CompetitionQuestRankItem:BuildFsm()
   
end


function CompetitionQuestRankItem:DisposeFsm()
    if self._fsm then
        self._fsm:Dispose()
        self._fsm = nil
    end
end

function CompetitionQuestRankItem:GetTransform()
    if self.go then
        return self.go.transform
    end
    return nil
end


function CompetitionQuestRankItem:OnDisable()
    
end

return this