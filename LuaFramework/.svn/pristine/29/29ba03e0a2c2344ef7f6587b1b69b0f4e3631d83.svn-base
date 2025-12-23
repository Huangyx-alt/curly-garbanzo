local ClubPagItem = BaseView:New("ClubPagItem")
local this = ClubPagItem

this.viewType = CanvasSortingOrderManager.LayerType.None
 
this.auto_bind_ui_items = {
    "clock_zong",
    "left_time_txt", --时间
    "btn_send",
    "btn_get",
    "Text",
    "Count", -- 表现
    "btn_package",
} 

function ClubPagItem:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function ClubPagItem:OnEnable(data)
    -- Facade.RegisterView(this)
    self.data = data
  
end

-- {
--     level
--     pag
-- }

function ClubPagItem:UpdateData(data)
    self.data = data

    local count = fun.table_len(self.data.pag)
    if  count > 0 then 
        
        fun.set_active(self.Count,true)
        fun.set_active(self.btn_get,false)
        fun.set_active(self.btn_send,true)
        fun.set_active(self.clock_zong,true)
        
        self.Text.text = tostring(count)
        self:UpdateTime()
    else 
        fun.set_active(self.Count,false)
        fun.set_active(self.btn_get,true)
        fun.set_active(self.btn_send,false)
        fun.set_active(self.clock_zong,false)
        
    end 

end

function ClubPagItem:UpdateTime() --1秒一次
    if not self.data or not self.data.pag then 
        return 0
    end 

    if #self.data.pag <= 0 then 
        return 0
    end     

    --取出最短时间
    local time = 9999999999999 
    for _,v in pairs(self.data.pag) do
        if v.unix <time then 
            time = v.unix
        end 
    end 

    local tmpTime = time - os.time()

   self.left_time_txt.text =  fun.SecondToStrFormat(tmpTime) 

   return tmpTime - 0
end

function ClubPagItem:on_btn_send_click()
    if not self.data or not self.data.pag then 
        log.r("not self.data not self.data ClubPagItem")
        return 
    end 

      --取出最短时间
      local id = nil 
      local time = 9999999999999 

      for _,v in pairs(self.data.pag) do
          if v.unix <time and v.unix > os.time() then 
              time = v.unix
              id = v.id
          end 
      end 

      if id ~= nil then 
        ModelList.ClubModel.C2S_ClubGiftPackageSend(id) 
      end 
   
end

function ClubPagItem:on_btn_get_click()
    --跳转到商店 --
    Facade.SendNotification(NotifyName.ShopView.PopupShop,PopupViewType.show,nil,nil,nil)
end

function ClubPagItem:on_btn_package_click()
    Facade.SendNotification(NotifyName.ShowUI, ViewList.ClubReqGiftPacketHelpView,nil,nil,self.data.level)
end

return this