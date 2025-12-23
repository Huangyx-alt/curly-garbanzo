require "Common.Anim"
-- 尺寸变换动画组件
ClipHelper = Clazz()

ClipHelper.base_sorting_order = ArtConfig.MERMAID_BASE_LAYER -- 默认层级
ClipHelper.tosize_duration = ArtConfig.MERMAID_ANIM_TIME -- 尺寸变换动画时长
ClipHelper.total_height = ArtConfig.MERMAID_ANIM_HEIGHT
ClipHelper.cell_height = ArtConfig.MERMAID_ICON_HEIGHT
ClipHelper.cell_width = ArtConfig.MERMAID_ICON_WIDTH

ClipHelper.big_cell_height = ArtConfig.MERMAID_BIG_ICON_HEIGHT
ClipHelper.big_cell_width = ArtConfig.MERMAID_BIG_ICON_WIDTH

function ClipHelper:init(para)
    self.is_big = para.is_big
    self.spine_clipping = para.spine_clipping
    self.cur_size = 1
    self.rect = fun.get_component(self.spine_clipping,fun.RECT)
    self.refer = fun.get_component(self.spine_clipping,fun.REFER)
    self.fg = self.refer:Get("fg")
    self:reset()
end

function ClipHelper:update_sorting_order(order)
    if order then self.sorting_order = order end
    fun.get_component(self.spine_clipping,fun.CANVAS).sortingOrder = self.sorting_order
end

function ClipHelper:set_size(size)
    self:stop_anim()
    if self.rect then
        if self.is_big then
            self.rect.sizeDelta = Vector2.New(self.big_cell_width, self.big_cell_height)
        else
            self.rect.sizeDelta = Vector2.New(self.cell_width, self.cell_height*size)
        end
    end
    
end

function ClipHelper:set_ef_to_inactive()

end

function ClipHelper:expand_to_size(size)
    if size == 1 then
        self:set_size(1)
        return
    end
    self:set_size(size)
    self:stop_anim()
    if self.fg then fun.set_active(self.fg,true) end
    self.anim_handler = Anim.do_smooth_float_update(self.cur_size*self.cell_height,size*self.cell_height,self.tosize_duration,
    function(num) 
        if self.rect then 
            self.rect.sizeDelta = Vector2.New(self.cell_width, num)
        end
    end,
    function()
        self.anim_handler = nil
        if self.fg then fun.set_active(self.fg,false) end
    end
    )

    self.cur_size = size
end

-- 停止动画
function ClipHelper:stop_anim()
    if self.anim_handler then self.anim_handler:Kill() end
    self.anim_handler = nil
    if self.fg then fun.set_active(self.fg,false) end
end

-- 销毁
function ClipHelper:destroy()
    self:stop_anim()
end

-- 重置
function ClipHelper:reset()
    self:set_size(1)
    self.sorting_order = self.base_sorting_order
    self:update_sorting_order()
end