local setmetatable = setmetatable
local insert = table.insert
---@class Controller
local Controller = {};
local this = Controller;
this.__index = this;


local create = coroutine.create
local resume = coroutine.resume
local insert = table.insert
local pairs = pairs
--协程执行函数
function spawn_(func, ...)
    -- return resume(create(func), ...)
    if(func == nil)then
        log.r("func is nil")
        return 
    end

    local arg = {...}
    local runFunc = function()
       func(unpack(arg))
    end
    return resume(create(function()
        xpcall(runFunc,__G__TRACKBACK__)
    end))
end

function spawn_without_excall(func, ...)
    -- return resume(create(func), ...)
    if(func == nil)then
        log.r("func is nil")
        return
    end

    local arg = {...}
    func(unpack(arg))
end


--命令管理类初始化--
function Controller.Init()
    log.w('Controller.Init----->>>');
    return setmetatable({commandList = {}, viewCommandList = {}, registerOwners = {},viewEnhanceCommandList = {}}, this);
end

--执行命令--
function Controller:ExecuteCommand(notifyName, ...)
    -- log.y("Controller:ExecuteCommand",notifyName)
    local ans = nil
    if(notifyName == nil or #notifyName==0)then 
    
        log.r("notifyName is nil")
        return 
    end

    local commandTable = self:GetCommand(notifyName);
    if commandTable ~= nil and type(commandTable) =="table" then
        --log.y("commandTable",...)
        if(commandTable.Execute==nil)then 
            log.r("command excute function is nil:"..notifyName)
            return 
        end
 	local registerOwner = self.registerOwners[notifyName]
  	if(registerOwner)then 
            ans = commandTable.Execute(registerOwner, ...);
        else
            ans = commandTable.Execute(notifyName, ...);
        end
        
    end
    local notifyList = {};
    for view, viewCommands in pairs(self.viewCommandList) do
        if viewCommands then
            for node, notifyExecute in ipairs(viewCommands) do
                if (notifyExecute.notifyName == notifyName) then
                    insert(notifyList, {view = view, exeuteItem = notifyExecute});
                end
            end
        end
    end

    if #notifyList <= 0 then
        return ans
    end
    for node, executeNode in ipairs(notifyList) do
        local exeuteItem = executeNode.exeuteItem;
        --log.r("excute notification name>>: ".. exeuteItem.notifyName)
        local func = exeuteItem.func;
        spawn_(func, ...);
    end
    return ans
    -- end
end



 
function Controller:IsRegisterCommand(commandName) 
    if(self.commandList[commandName]~=nil)then 
        return true 
    end 
    return false  
end


--添加通知--
function Controller:RegisterCommand(commandName, command,registerOwner)

    if(self.commandList[commandName]~=nil)then
        if(fun.IsEditor())then 
            local cmd = self.commandList[commandName]
            for k,v in pairs(package.loaded) do
                if(cmd==v)then 
                    log.w(commandName.." 已经注册 ",k)
                    break
                end
            end
        else
            log.w(commandName.." 已经注册，请检查是否重复注册 ")
        end
       
        return
    end

    if(command==nil)then 
        log.w(commandName .. "注册失败,没有找到对应的cmd,请检查合并")
        return 
    end
    if(registerOwner)then 
        self.registerOwners[commandName] = registerOwner
    end
    self.commandList[commandName] = command;
end

--获取通知--
function Controller:GetCommand(commandName)
    return self.commandList[commandName];
end

--移除通知--
function Controller:RemoveCommand(commandName)
    self.commandList[commandName] = nil;
end

--注册view通知列表--
function Controller:RegisterView(view)
    if not view then return end
    if view.NotifyList then
        self.viewCommandList[view.viewName] = view.NotifyList;
    end
end

--移除view通知列表--
function Controller:RemoveView(view)
    if not view then return end
    self.viewCommandList[view.viewName] = nil;
end

--注册view通知列表--
function Controller:RegisterViewEnhance(view)
    if not view then return end
    if view.NotifyEnhanceList then
        self.viewEnhanceCommandList[view] = view.NotifyEnhanceList
    end
end

--移除view通知列表--
function Controller:RemoveViewEnhance(view)
    if not view then return end
    self.viewEnhanceCommandList[view] = nil
end

--执行命令--
function Controller:ExecuteCommandEnhance(notifyName, ...)
    local notifyList = {}
    for view, viewCommands in pairs(self.viewEnhanceCommandList) do
        if viewCommands then
            for node, notifyExecute in ipairs(viewCommands) do
                if (notifyExecute.notifyName == notifyName) then
                    insert(notifyList, {view = view, exeuteItem = notifyExecute})
                end
            end
        end
    end

    for idx, executeNode in ipairs(notifyList) do
        local exeuteItem = executeNode.exeuteItem
        --log.log("ExecuteCommandEnhance notification name>>: " .. exeuteItem.notifyName)
        local func = exeuteItem.func
        spawn_(func, executeNode.view, ...)
    end
end

return Controller;