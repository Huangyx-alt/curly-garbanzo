--下载时开启
local DownloadCityUtility = BaseView:New("DownloadCityUtility")
local this = DownloadCityUtility
local ItemEntityCache = {}
local windowView = nil

function DownloadCityUtility:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

function DownloadCityUtility:Awake()
    self:on_init()
end

function DownloadCityUtility:OnEnable(data)
  -- this.update_x_enabled = true
  Facade.RegisterView(this)

  -- --下载网络问题
  -- if  Network.isConnect == false then
  --   UIUtil.show_common_popup(977,true,nil)
  -- end
end

function DownloadCityUtility:OnDisable()
  Facade.RemoveView(this)
  for _, v in pairs(ItemEntityCache) do
    v:Close()
  end
  ItemEntityCache ={}
  if windowView then
    Facade.SendNotification(NotifyName.HideDialog, windowView)
  end
  this.update_x_enabled = false
  this:stop_x_update()
end

function DownloadCityUtility:OnDestroy()
  Facade.RemoveView(this)
  for _, v in pairs(ItemEntityCache) do
    v:Close()
  end
  ItemEntityCache ={}
  if windowView then
    Facade.SendNotification(NotifyName.HideDialog, windowView)
  end
  this.update_x_enabled = false
  this:stop_x_update()
end 


function DownloadCityUtility.AddEntity(item)
    if not item then 
      return 
    end 
    local data = item:getSelfData()
    if data ~= nil and data.id ~= nil and not ItemEntityCache[data.id]  then
        ItemEntityCache[data.id] = item
    end 

end

function DownloadCityUtility.isAlreayAdd(id)
    if not ItemEntityCache[id]  then 
      return false 
    end 

    return true 
end

function DownloadCityUtility:GetTransform()
  if self.go then
      return self.go.transform
  end
  return nil
end

---------------------------------下载更新

function DownloadCityUtility.OnEventUpdate(id,progress,size)
  for _, v in pairs(ItemEntityCache) do
    local data = v:getSelfData()
    if data ~= nil and data.id ==id  then 
        v:OnEventUpdate(id,progress,size)
    end 
  end
end

function DownloadCityUtility.OnEventSuccess(id)
    for _, v in pairs(ItemEntityCache) do
        local data = v:getSelfData()
        if data ~= nil and data.id ==id  then 
            v:OnEventSuccess(id)
        end 
    end
    this.update_x_enabled = false
    this:stop_x_update()
end

function DownloadCityUtility.OnEventError(id)
  for _, v in pairs(ItemEntityCache) do
    local data = v:getSelfData()
    if data ~= nil and data.id ==id  then 
        v:OnEventError(id)
    end 
  end

  this.update_x_enabled = false
  this:stop_x_update()
end


function DownloadCityUtility.OnEventStart(id)
  for _, v in pairs(ItemEntityCache) do
    local data = v:getSelfData()
    if data ~= nil and data.id ==id  then 
        v:OnEventStart(id)
    end 
  end
  
  this.update_x_enabled = true
  this:start_x_update()
end

function DownloadCityUtility.OnEventStop(id)
  for _, v in pairs(ItemEntityCache) do
    local data = v:getSelfData()
    if data ~= nil and data.id ==id  then 
        v:OnEventStop(id)
    end 
  end

  this.update_x_enabled = false
  this:stop_x_update()
end

function DownloadCityUtility:on_x_update()
  if  Network.isConnect == false then 
      --在下载得都
      for _, v in pairs(ItemEntityCache) do
          v:GetIsLoadingStateAndChange() 
      end
      
      if #ItemEntityCache == 0 then 
          return ;
      end 

      if not windowView then
        windowView = UIUtil.show_common_popup(977,true,function()
            this.update_x_enabled = false
            this:stop_x_update()
          end)
      end

  end

end



this.NotifyList = {
    {notifyName = NotifyName.Event_machine_download_update, func = this.OnEventUpdate},
    {notifyName = NotifyName.Event_machine_download_success_view, func = this.OnEventSuccess},
    {notifyName = NotifyName.Event_machine_download_error, func = this.OnEventError},
    {notifyName = NotifyName.Event_machine_download_start, func = this.OnEventStart},
    {notifyName = NotifyName.Event_machine_download_stop, func = this.OnEventStop},
}

return this