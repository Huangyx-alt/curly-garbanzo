require "Logic.ObjectPool"

-- 无限循环列表
InfiniteScroll = Clazz()

InfiniteScroll.scroller = nil
InfiniteScroll.scroll_rect = nil
InfiniteScroll.scroll_content = nil
InfiniteScroll.item_class = nil
InfiniteScroll.item_height = 0
InfiniteScroll.item_width = 0
InfiniteScroll.item_space = 0
InfiniteScroll.count_total = 0
InfiniteScroll.left_offset = 0
InfiniteScroll.top_offset = 0
InfiniteScroll.item_id = 0

InfiniteScroll.springback_threshold = 150   -- 回弹判定阈值
InfiniteScroll.springback_time = 0.5        -- 回弹时间长度

function InfiniteScroll.create(para)
    local r = InfiniteScroll:new()
    r:init(para)
    return r
end

function InfiniteScroll:init(para)
    log.g("InfiniteScroll:init",para)
    self.data = para.data -- 机台列表数据
    self.scroller = para.scroller
    self.scroll_rect = self.scroller:GetScrollRect()
    self.scroll_content = self.scroll_rect.content
    -- 一级参数
    self.item_class = para.item_class           -- 个体控制类
    self.item_prefab = para.item_prefab         -- 个体预制体
    self.item_height = para.item_height         -- 每个高度
    self.item_width = para.item_width           -- 每个宽度
    self.item_space = para.item_space           -- 每个间距
    self.count_total = para.count_total         -- 总个数
    self.left_offset = para.left_offset         -- 左侧空当
    self.right_offset = para.right_offset       -- 结尾空当
    self.top_offset = para.top_offset           -- 顶部空当
    self.auto_springback = para.auto_springback -- 自动回弹
    self.scroll_callback = para.scroll_callback -- 滑动回调

    -- 二级参数
    self.item_delta = self.item_width + self.item_space                             -- 每个占用长度(包括间距)
    self.item_delta_inverse = 1 / self.item_delta                                   -- 倒数
    self.view_width = self.scroller.transform.rect.width                            -- 可见范围的长度
    self.item_count_in_view = math.ceil(self.view_width / self.item_delta) + 1      -- 可见范围内总item数量
    self.index_first_in_view = 1                                                    -- 可见范围内第一个item的序号
    self.index_last_in_view = self.index_first_in_view + self.item_count_in_view - 1    -- 可见范围内最后一个item的序号
    self.index_first_in_all = 1                                                     -- 整个列表第一个item的序号
    self.index_last_in_all = self.count_total - self.index_first_in_all + 1         -- 整个列表最后一个item的序号
    self.index_now = para.index                                                     -- 当前item的序号
    self.index_first_at_last = self.count_total - self.index_first_in_all + 1 - self.item_count_in_view         -- 滑动到最后一个item时可见范围内第一个item的序号
    self.total_width = self.item_delta * (self.count_total - self.index_first_in_all + 1) + self.left_offset + self.right_offset  -- 滑动列表总长度
    self.scroll_content.sizeDelta = Vector2.New(self.total_width, self.scroll_content.sizeDelta.y)              -- 设置滑动列表长度

    self.item_list = {} -- 当前对象列表
    self.cache_list = {} -- 缓存列表
    self.current_index_list = {} -- 当前序号列表

    -- 内容初始化
    for i = self.index_first_in_view, self.index_last_in_view do
        self:show_item(i)
    end

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

-- 根据滚动列表的x找到当前对应项的序号
function InfiniteScroll:find_index_by_x(x)
    local base = (x - self.left_offset) * self.item_delta_inverse
    local min = base - 0.5
    local max = base + 0.5
    return math.ceil(max)
end

-- 列表滑动回调
function InfiniteScroll:on_scroll(x)
    self:update_by_x(x)
end

-- 更新滑动位置(序号)
function InfiniteScroll:update_by_index(index)
    local index_first = index
    local index_last = index_first + self.item_count_in_view - 1
    for i = self.index_first_in_all, self.index_last_in_all do
        if i < index_first-1 then
            self:hide_item(i)
        elseif i > index_last then
            self:hide_item(i)
        else
            self:show_item(i)
        end
    end

    self.index_first_in_view = index_first
    self.index_last_in_view = index_last
end

-- 更新滑动位置(x坐标)
function InfiniteScroll:update_by_x(x)
    self.x = x
    local index_first = self:find_index_by_x(x)
    self:update_by_index(index_first)
end

function InfiniteScroll:on_drag_begin(x)
    self.begin_pos_x = x
end

-- 拖拽结束回调
function InfiniteScroll:on_drag_end(x)
    self.end_pos_x = x
    if self.auto_springback then
        self:springback()
    end
end

-- 回收一条
function InfiniteScroll:hide_item(index)
    local item = self.item_list[index]
    if item then
        table.insert(self.cache_list,item)
        self.item_list[index] = nil
        fun.set_active(item.go,false)
    end
end

-- 显示一条
function InfiniteScroll:show_item(index)
    if self.item_list[index] then return end
    if self.data[index] == nil then return end
    local item = table.remove(self.cache_list)
    if not item then
        item = self.item_class.create(index, self.item_prefab, self.scroll_content)
    end
    item:set_data(index,self.data[index])
    self.idle_item = nil

    self.item_list[index] = item
    
    local go = item.go
    fun.set_parent(go, self.scroll_content)
 
    fun.set_active(go,true)
    go.transform:SetSiblingIndex(0) -- 新创建的对象置于对底层(避免装饰物被遮盖)
    fun.set_gameobject_scale(go,1,1,1)
    local x = self.item_delta * (index - 0.5) + self.left_offset
    fun.set_rect_local_pos(go,x,self.top_offset,0,true)
end

-- 销毁
function InfiniteScroll:destroy()
    self.scroller:UnRegCallback()
    if self.item_list and #self.item_list>0 then
        for _, item in pairs(self.item_list) do
            item:destroy()
        end
        self.item_list = {}
    end
    if self.cache_list and #self.cache_list>0 then
        for _, item in pairs(self.cache_list) do
            item:destroy()
        end
        self.cache_list = {}
    end
end

-- 回弹
function InfiniteScroll:springback()
    local threshold = self.springback_threshold
    local x = self.end_pos_x
    local delta = self.end_pos_x - self.begin_pos_x
    if delta > -threshold and delta < threshold then
        -- log.g("不跳转")
    elseif delta >= threshold then
        -- log.g("请求向后跳转")
        if self.index_now == self.count_total then
            -- log.g("不跳转")
        else
            -- log.g("向后跳转")
            self.index_now = self.index_now + 1
        end
    elseif delta <= -threshold then
        -- log.g("请求向前跳转")
        if self.index_now == 1 then
            -- log.g("不跳转")
        else
            -- log.g("向前跳转")
            self.index_now = self.index_now - 1
        end
    end
    self:scroll_to(self.index_now)
end

-- 滑动到位置
function InfiniteScroll:scroll_to_x(x, time)
    time = time or self.springback_time
    Anim.scroll_to_x(self.scroll_content,x,time,function()
    end)
end

-- 滑动到序号
function InfiniteScroll:scroll_to(index, time)
    fun.get_component(self.scroll_rect.viewport,fun.IMAGE).raycastTarget = false
    local x = -self.item_delta * (index-1)
    time = time or self.springback_time
    Anim.scroll_to_x(self.scroll_content,x,time,function()
        -- log.g("回弹完成",x)
        self.index_now = index
        fun.get_component(self.scroll_rect.viewport,fun.IMAGE).raycastTarget = true
    end)
    if self.scroll_callback then
        self.scroll_callback(index)
    end
    return index
end

-- 滑动到上一个
function InfiniteScroll:scroll_to_prev()
    local x = -self.scroll_content.anchoredPosition.x
    local index = self:find_index_by_x(x)
    return self:scroll_to(index - 1)
end

-- 滑动到下一个
function InfiniteScroll:scroll_to_next()
    local x = -self.scroll_content.anchoredPosition.x
    local index = self:find_index_by_x(x)
    return self:scroll_to(index + 1)
end

-- 定位到坐标x
function InfiniteScroll:locate_to_x(x)
    local p = self.scroll_content.anchoredPosition
    p.x = x
    self.scroll_content.anchoredPosition = p
    self:update_by_x(-x)
end

-- 定位到序号index
function InfiniteScroll:locate_to_index(index)
    self.index_now = index
    local x = self.item_delta * (index-1) + self.left_offset
    self:locate_to_x(-x)
end