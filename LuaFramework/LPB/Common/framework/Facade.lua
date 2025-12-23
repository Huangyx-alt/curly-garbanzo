--require 'Common/framework/NotifyName'
require 'Common/framework/FrameDefine'
require 'Common/framework/Message'
local Controller = require 'Common/framework/Controller'


local select = select
local insert = table.insert

function HandleNotifyParams(...)
    local view, args = nil, {};
    local count = select('#', ...);
    for index = 1, count do
        if index == 1 then view = select(1, ...);
        else
            local tempArg = select(index, ...);
            insert(args, index - 1, tempArg);
        end
    end
    return view, args;
end



Facade = {};
local controller;			--消息管理--

--初始化外观，注册通知消息--
function Facade.InitFramework()
    log.r("Facade Init Framework");
    if(controller==nil)then 
        controller = Controller.Init();
    end 
end

--注册通知到指定的命令--
function Facade.RegisterCommand(commandName, commandTable,register)
    controller:RegisterCommand(commandName, commandTable,register);
end

--移除消息--
function Facade.RemoveCommand(commandName)
    controller:RemoveCommand(commandName);
end

--注册View通知列表--
function Facade.RegisterView(view)
    controller:RegisterView(view);
end

--移除View通知列表--
function Facade.RemoveView(view)
    controller:RemoveView(view);
end

--注册View通知列表Enhance--
function Facade.RegisterViewEnhance(view)
    controller:RegisterViewEnhance(view)
end

--移除View通知列表Enhance--
function Facade.RemoveViewEnhance(view)
    controller:RemoveViewEnhance(view)
end

--移除View通知列表--
function Facade.IsRegisterCommand(cmd_name)
    return controller:IsRegisterCommand(cmd_name);
end

--发送消息体并执行--
function Facade.SendNotification(notifyName, ...)
    if controller then
        controller:ExecuteCommandEnhance(notifyName, ...)
        return controller:ExecuteCommand(notifyName, ...);
    end
end

return Facade;