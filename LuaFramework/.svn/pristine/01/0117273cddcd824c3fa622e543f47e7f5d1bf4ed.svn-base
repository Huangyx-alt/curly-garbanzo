require "View/CommonView/HallRobotMsgView"

MsgScrollView = BaseView:New("MsgScrollView")
local this = MsgScrollView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "content",
    "chat_item",
    "msg_scrollrect",
    "content_temp",
    "viewport"
}

local robot_msg_list = {}
local offset = 0;

function MsgScrollView:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function MsgScrollView:Awake()
    self:on_init()
end

function MsgScrollView:OnEnable()
    self:InitMsg()
    self._timer = Timer.New(function()
        self:OnHeartBeat()
    end,0.5,-1)
    self._timer:Start()
    self:RecordRandomCD()
end

function MsgScrollView:InitMsg()
    fun.set_rect_local_pos_y(self.viewport,-1844)
    if #robot_msg_list <= 0 then
        self._adjust = function()
            self:CreatRobotMsg()
        end
    else
        local isnull = false
        for index, value in ipairs(robot_msg_list) do
            if Util.IsNull(value.go) then
                isnull = true
                local go = self:GetChatItem(index - 1)--fun.get_instance(self.chat_item,self.content_temp)
                fun.set_active(go,true)
                value:SkipLoadShow(go)
                value:ResetChat()
            end
        end
        if not isnull then
            local height = 24;
            for index, value in ipairs(robot_msg_list) do
                fun.set_parent(value.go,self.content,false)
                robot_msg_list[index]:SetPosition(Vector2.New(0, -height))
                height = height + robot_msg_list[index]:GetSizeDelta().y + offset
            end
        end
    end
    Anim.scroll_to_y(self.viewport.transform,0,0.6,function()
        self:SetToggleStiff(true)
    end)
end

function MsgScrollView:OnHeartBeat()
    if self._adjust then
        self._adjust()
        self._adjust = nil
    end
    if self.msg_cd and self._cdTimePoint then
        if os.time() - self._cdTimePoint >= self.msg_cd then
            self:RecordRandomCD()
            self:CreatRobotMsg()
        end
    end
end

function MsgScrollView:RecordRandomCD()
    local random_cd = Csv.GetControlByName("city_message_cd")
    if random_cd then
        self._cdTimePoint = os.time() --UnityEngine.Time.time
        self.msg_cd = math.random(random_cd[1][1],random_cd[1][2])
    end
end

function MsgScrollView:GetChatItem(index)
    --[[
    local childCount = fun.get_child_count(self.content_temp)
    local chatItem = nil
    local childIndex = index or 0
    if childCount > 0 and childIndex < childCount then
        chatItem = nil --fun.get_child(self.content_temp,childIndex)
    end
    if chatItem == nil then
        chatItem = fun.get_instance(self.chat_item,self.content)
    else
        chatItem = chatItem.gameObject
    end
    
    return chatItem
    --]]
    return fun.get_instance(self.chat_item,self.content)
end

function MsgScrollView:CreatRobotMsg()
    local height = 24;
    local robot_msg = nil
    local lenth = fun.get_table_size(robot_msg_list)
    local resetPos = false

    if lenth >= 10 then
        robot_msg = robot_msg_list[1]
        table.remove(robot_msg_list,1)
        robot_msg.go.transform:SetAsLastSibling()
        resetPos = true
    else
        local go = self:GetChatItem() --fun.get_instance(self.chat_item,self.content_temp)
        fun.set_parent(go,self.content,false)
        fun.set_active(go,true)
        robot_msg = HallRobotMsgView:New()
        robot_msg:SkipLoadShow(go)
    end

    ---[[
    for i = 1, #robot_msg_list do
        if resetPos then
            robot_msg_list[i]:SetPosition(Vector2.New(0, -height))
        end
        height = height + robot_msg_list[i]:GetSizeDelta().y + offset
    end
    if resetPos then
        local pos = self.content.transform.anchoredPosition
        self.content.transform.anchoredPosition = Vector2.New(pos.x, pos.y - (robot_msg:GetSizeDelta().y + offset))
    end
    --]]

    table.insert(robot_msg_list,robot_msg)
    robot_msg:SetChat()

    if self.msg_scrollrect then
        self.msg_scrollrect:SetRefresh(true)
    end
end

function MsgScrollView:OnDisable()
    self:on_close()
end

function MsgScrollView:on_close()
    if self._timer then
        self._timer:Stop()
        self._timer = nil
    end
    if self._adjust then
        self._adjust = nil
    end
end

function MsgScrollView:OnDestroy()
    self:Close()
end