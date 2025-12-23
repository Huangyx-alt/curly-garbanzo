UnlimitScroll = Clazz()

UnlimitScroll.scroll_rect = nil --scroll rect
UnlimitScroll.content = nil --scroll content
UnlimitScroll.max_item = 0 --最大显示多少item
UnlimitScroll.max_showed_item = 0 --当前屏幕最多显示多少个item
UnlimitScroll.item_height = 0 --item的高度
UnlimitScroll.item_space = 0 --item空间
UnlimitScroll.top_offset = 0 --item的顶部偏移（整体）

--data_list=数据table，item=item元素的基类，click_callback=点击事件
function UnlimitScroll:init(data_list,item,click_callback)
    self.item_list = {}
    self.item_data_list = data_list
    self.click_callback = click_callback
    self.content = self.scroll_rect.content
    self.item_base = self.content:GetChild(0).gameObject
    self.item_dis = self.item_height+self.item_space --计算item实际占用高度
    self.drag_index = nil
    self:add_slider_event()
    self.content.sizeDelta = Vector2.New(self.content.sizeDelta.x, self.max_item * self.item_dis+ self.top_offset);
    self:init_items(item)
end

function UnlimitScroll:add_slider_event()
    Util.AddScrollRectChangeCallBack(self.scroll_rect,function(vec2)
        local drag_dis = self.content.anchoredPosition.y
        local index = math.floor(drag_dis/self.item_dis)
        if index == -1 then return end
        local new_drag_index = self.drag_index
        self.drag_index = index
        while(new_drag_index~=index) do
            if index>new_drag_index then
                local y = -((new_drag_index + self.max_showed_item) * self.item_dis) - self.top_offset
                if math.abs(math.abs(y)-self.content.sizeDelta.y)<=0.01 then
                    --下一个item插入的地方不符合预期，直接返回
                    self.drag_index = new_drag_index
                    return
                end

                local item = self.item_list[1]
                table.remove(self.item_list,1)
                item.transform.localPosition = Vector3.New(0, y , 0);
                table.insert(self.item_list,item)
                new_drag_index = new_drag_index+1
            else
                local y = -((new_drag_index-1) * self.item_dis) - self.top_offset;
                if y>0 then
                    --下一个item插入的地方不符合预期，直接返回
                    self.drag_index = new_drag_index
                    return
                end

                local item = self.item_list[#self.item_list]
                table.remove(self.item_list,#self.item_list)
                item.transform.localPosition = Vector3.New(0, y , 0)
                table.insert(self.item_list,1,item)
                new_drag_index = new_drag_index-1
            end
        end
        
    end)
end

function UnlimitScroll:init_items(item)
    --当前显示最大item个数比总数还多的话，只显示总数个item
    if self.max_showed_item>=#self.item_data_list then
        self.max_showed_item = #self.item_data_list
    end

    for i=0,self.max_showed_item-1 do
        -- local item = fun.get_instance(self.item_base,self.content)
 
        -- item.name = "item " .. i
        local item = item:create_new(self.click_callback,self.item_data_list[i+1],self.item_base,self.content,i)
        item.go.name = "item " .. i
        --i下标x这个item所占总长度+这个item自身的长度（需要注意item的pivot位置） 
        item.transform.localPosition = Vector3.New(0, -(i * self.item_dis) - self.top_offset, 0);
        table.insert(self.item_list,item)
    end
    self.drag_index = 0
end

function UnlimitScroll:clear_items()
    if self.item_list then
        for i, v in ipairs(self.item_list) do
            v:destroy()
        end
    end
    self.item_list = {}
end