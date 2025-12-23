-- TODO by LwangZg 运行时热更部分
--下载时开启
local DownloadUtility = Clazz()
local this = DownloadUtility
local DownloadCommonView = require "View/CommonView/DownloadCommonView"

local DownloadState = {
    downloading = 1,  --下载中
    finish = 2,     --下载完成
    empty = 0       --没有模块
}

function DownloadUtility:New()
    local o = {}
    self.__index = self
    setmetatable(o,self)
    return o
end

--生成一个下载按钮并开始下载
function DownloadUtility:NewNode(modular_id,Node)
  self.modular_id = modular_id

  local loadDefault,data = this:CheckDownload(modular_id) 

  if loadDefault == 0 then 
      local downPname = "DownloadCommonView"
      local tmpab = AssetList[downPname]
      local data = {
          id =modular_id,
      }
    
      local downloadView = DownloadCommonView:New(data);
      Cache.load_prefabs(tmpab,downPname,function(ret)
          if ret then
              local tmpgo = Cache.create(tmpab,downPname)
              downloadView:SkipLoadShow(tmpgo,true)    
              downloadView:SetParent(Node)
              Facade.SendNotification(NotifyName.StartDownloadMachine,modular_id)
              local tmpmodData = Csv.GetData("modular",modular_id)
              if tmpmodData and tmpmodData.modular_name then
                  SDK.click_download_extrapac(tmpmodData.modular_name)
              end
          end
      end)
      return false 
  elseif loadDefault == 2 then 
    return true
  else
    return false 
  end 

end 

function DownloadUtility:CheckDownload(DownloadId)
      local MachineItemData = nil 
     local Macheindata = deep_copy( MachinePortalManager.get_portal_data_by_machine())
   
     local loadDefault = DownloadState.finish  --已下载 
     --and fun.IsEditor() == false
     if Macheindata and type(Macheindata) == "table"  then 
         for _,v in pairs(Macheindata) do
            if  ( v.moduleType == modular_type.FunctionType or v.moduleType == modular_type.playType)  and DownloadId == v.machine_id then
                 MachineItemData = deep_copy(v) 
                 break;
             end 
         end 

        if not MachineItemData then 
            log.r("MachineItemData ,not data "..DownloadId) 
             --有bug 
         else 
             local version = MachineDownloadManager.read_machine_local_version(MachineItemData.machine_id)
             if version ~= nil  then --也有可能正在下载
                 if  version >= MachineItemData.version then --已下载 
                    --TODO by LwangZg 运行时热更部分
                    if resMgr then
                        resMgr:RefreshModuleInfo(MachineItemData.name)
                    end
                     loadDefault = DownloadState.finish 
                 else 
                     if MachineDownloadManager.is_machine_downloading(MachineItemData.machine_id) then 
                         loadDefault =DownloadState.downloading --下载中
                     else 
                        loadDefault = DownloadState.empty 
                     end 
                 end 
             else 
                 log.r("  error   error  error  error  error  error status not Download ")
             end 
         end 
     end  
     return loadDefault ,MachineItemData
end 


return this