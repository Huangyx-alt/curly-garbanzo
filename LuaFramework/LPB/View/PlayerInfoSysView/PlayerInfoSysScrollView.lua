require "Logic.ObjectPool"

-- 无限循环列表
PlayerInfoSysScrollView = Clazz()

PlayerInfoSysScrollView.scroller = nil                -- InfiniteScroller(CS脚本实例)
PlayerInfoSysScrollView.scroll_rect = nil
PlayerInfoSysScrollView.scroll_content = nil
PlayerInfoSysScrollView.item_class = nil
PlayerInfoSysScrollView.springback_threshold = 150    -- 回弹判定阈值
PlayerInfoSysScrollView.springback_time = 0.5         -- 回弹时间长度
PlayerInfoSysScrollView.auto_springback = true        -- 自动回弹
PlayerInfoSysScrollView.show_count_before = 1         -- 前面显示个数
PlayerInfoSysScrollView.show_count_after = 1          -- 后面显示个数
PlayerInfoSysScrollView.index_first_in_all = 1        -- 整个列表第一个item的序号

function PlayerInfoSysScrollView.create(para)
    local r = PlayerInfoSysScrollView:new()
    r:init(para)
    return r
end

function PlayerInfoSysScrollView:init(para)
    
    self.data = para.data
    self.item_count = #para.data
    self.scroller = para.scroller
    self.item_class = para.item_class           -- 个体控制类
    self.item_prefab = para.item_prefab         -- 个体预制体
    self.scroll_callback = para.scroll_callback -- 滑动回调

    self.scroll_rect = self.scroller:GetScrollRect()
    self.scroll_content = self.scroll_rect.content
    self.rect_transform = fun.get_component(self.scroller,fun.RECT)
    self.item_space = para.item_space
    local size = fun.get_rect_delta_size(self.item_prefab)
    self.screen_width = size.x
    self.screen_height = size.y
    self.view_port = self.scroll_rect.viewport
    self.view_port_size = fun.get_rect_delta_size(self.view_port)
    self:SetStartToEndIndex( )

    self.index_last_in_all = self.item_count - self.index_first_in_all + 1          -- 整个列表最后一个item的序号

    self:UpdateContentSize()
    fun.set_rect_local_pos_x(self.scroll_content, 0)

    self.item_list = {} -- 当前对象列表
    self.cache_list = {} -- 缓存列表
    self.start_index = self:GetStartIndex(0)
    self.last_index = self:GetLastIndex(0, self.start_index) 
    self:update_location()
    self:update_show()


    -- 注册列表回调
    self.scroller:RegCallback(
        function(x) -- 位置变化回调
            self:on_scroll(x)
        end, 
        function(x) -- 停止拖拽回调
            self:on_drag_end(x)
        end,
        function(x) -- 开始拖拽回调
            self:on_drag_begin(x)
        end
    )
end

function PlayerInfoSysScrollView:UpdateData(data)
    self.data = data -- 机台列表数据
    self.item_count = #self.data
    self:UpdateUseItem()
    self:UpdateContentSize()    
    self:update_show()
end

function PlayerInfoSysScrollView:ShowDelete(uid)
    for k , v in pairs(self.item_list) do
        if v.click_uid == uid then
            local item = self.item_list[k]
            item:ShowRemoveAnim()
        end
    end
end

function PlayerInfoSysScrollView:DeleteIndex(uid)
    local delete_index

    for k , v in pairs(self.item_list) do
        if v.click_uid == uid then
            delete_index = k
            break
        end
    end
    
    if delete_index then
        self:hide_item(delete_index)
    else
        log.log("错误删除没有序号" , uid)
        Facade.SendNotification(NotifyName.System.FriendsView.UpdateBtnState, true)
    end
end

function PlayerInfoSysScrollView:UpdateOneData(index, data)
    if self.data[index] then
        self.data[index] = data
        self:UpdateCellData(index)
    end
end

function PlayerInfoSysScrollView:UpdateUseItem()
    local index_first = self.start_index
    local index_last = self.last_index
    local data_num = #self.data

    --这里要优化下
    for k , v in pairs(self.item_list) do
        if k >= index_last then
            self:hide_item(k)
        end
    end

    for i = 1 , data_num do
        if i >= index_first and i <= index_last then 
            self:UpdateCellData(i)
        end
    end
end

function PlayerInfoSysScrollView:UpdateCellData(index)
    if self.item_list[index] and self.data[index]  then
        local item = self.item_list[index]
        item:set_data(index,self.data[index])
        item:show()
    end
end

function PlayerInfoSysScrollView:ChangeIndexRange(y)
    self.start_index = self:GetStartIndex(y)
    self.last_index = self:GetLastIndex(y, self.start_index) 

end


function PlayerInfoSysScrollView:on_scroll(y)
    self:ChangeIndexRange(y)
    self:update_show()
end

function PlayerInfoSysScrollView:on_drag_begin(x)
    self.begin_pos_x = x
end

function PlayerInfoSysScrollView:on_drag_end(x)
    --2021/11/15 新加内容 结束拖拽关闭玩家操作UI
    Facade.SendNotification(NotifyName.System.FriendsView.OutCloseControlView)
    
end

function PlayerInfoSysScrollView:get_index_by_x(x)
    local t = math.ceil(-x / self.screen_height + 0.5)
    return t
end


function PlayerInfoSysScrollView:TestLog()
end

-- 回收一条
function PlayerInfoSysScrollView:hide_item(index)
    local item = self.item_list[index]
    if item then
        table.insert(self.cache_list,item)
        self.item_list[index] = nil
        item:hide()
    end
end

--删除后数据重新排列
function PlayerInfoSysScrollView:DeleteToUpdateOrder()

end

-- 显示一条
function PlayerInfoSysScrollView:show_item(index)
    if self.item_list[index] then
         return 
    end

    if self.data[index] == nil then return end
    local item = table.remove(self.cache_list)
    if not item then
        item = self.item_class.Create(index, self.item_prefab, self.scroll_content)
    end
    self.item_list[index] = item
    item:set_data(index,self.data[index])
    item:show()
    local x = self.screen_height * (index - 0.5) + (index - 1) * self.item_space
    item:set_local_position_x(x)
end

-- 销毁
function PlayerInfoSysScrollView:destroy()
    self.scroller:UnRegCallback()
    if self.item_list then
        for _, item in pairs(self.item_list) do
            item:destroy()
        end
        self.item_list = {}
    end
    if self.cache_list then
        for _, item in pairs(self.cache_list) do
            item:destroy()
        end
        self.cache_list = {}
    end
end

-- (刷新)定位到新位置
function PlayerInfoSysScrollView:update_location()
    local x = -self.screen_height * (self.start_index - 1)
    self.scroll_content.anchoredPosition = Vector3.New(0,x,0)
end

--设置显示开头到结尾可以有几个
function PlayerInfoSysScrollView:SetStartToEndIndex()
    local view_size_y = self.view_port_size.y
    local temp_one_use_size = self.screen_height  + self.item_space 
    self.max_use_num = math.ceil(view_size_y / temp_one_use_size ) + 1
end

function PlayerInfoSysScrollView:GetStartIndex(y)
    local current_y = -y
    local num = #self.data
    local content_pos = self.scroll_content.transform.localPosition
    -- self.item_space = 0
    self.up_offset = 0
    self.down_offset = 0
    
    local fake_start_index = 1
    local current_start_index = 1
    if current_y > 0 then
        --超过最上面了
        for i = 1 , num do
            if current_y >= (i * self.screen_height ) + ( i - 1) * self.item_space  then
                --这些都是被越过的
                fake_start_index = i
            else
                if fake_start_index  then
                    current_start_index = i
                    break
                end
            end
        end
    elseif current_y < 0 then
        --被拉到了下面 上面和第一个显示 有一段空隙
        current_start_index = 1
    else
        current_start_index = 1
        --不动
    end
    return current_start_index
end


function PlayerInfoSysScrollView:GetLastIndex(y, start_index)
    local num = #self.data
    local current_last = self.max_use_num + start_index
    if num < current_last  then
        --可展示数量超过最大数据量
        current_last = num
    end
    -- log.log("MOP更新结束结点", y ,self.total_width , current_last)
    return current_last
end

-- 更新显示
function PlayerInfoSysScrollView:update_show()
    self:_show_by_index(self.start_index)
    self.scroll_callback(self.start_index)
end

-- 显示序号
function PlayerInfoSysScrollView:_show_by_index(index)
    self:ChangeIndexRange(-self.scroll_content.transform.localPosition.y)       
    local index_first = self.start_index
    local index_last = self.last_index
    local data_num = #self.data

    for i = 1 , data_num do
        if i >= index_first and i <= index_last then 
            self:show_item(i)
        else
            self:hide_item(i)
        end
    end
end


function PlayerInfoSysScrollView:InitUnUse()
    for k , v in pairs(self.item_list) do
        
    end
end

-- 恢复触摸控制
function PlayerInfoSysScrollView:enable_touch()  
    fun.get_component(self.scroll_rect.viewport,fun.IMAGE).raycastTarget = true
end

-- 禁用触摸控制
function PlayerInfoSysScrollView:disable_touch()
    fun.get_component(self.scroll_rect.viewport,fun.IMAGE).raycastTarget = false 
end

function PlayerInfoSysScrollView:UpdateContentSize()
    self.total_width = self.screen_height * self.item_count +  (self.item_count - 1) * self.item_space
    self.scroll_content.sizeDelta = Vector2.New(0,self.total_width)
end

function PlayerInfoSysScrollView:UpdateBtnState(state)
    log.log("按钮状态变化", state)
    for k , v in pairs(self.item_list) do
        local item = self.item_list[k]
        item:UpdateBtnState(state)
    end
end