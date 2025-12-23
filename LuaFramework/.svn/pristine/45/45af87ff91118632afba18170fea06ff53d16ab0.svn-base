Message = {NumberMsg = {}, NormalMsg = {},NormalMsgListener ={}}
local this = Message;
this.__index = this;

--添加Msg监听
function Message.AddMessage(msgName, func, listener)
    local newMsgName = (msgName)
    this.NormalMsg[newMsgName] = func;
    if listener then
        this.NormalMsgListener[newMsgName] = listener;
    end
end

--移除Msg监听
function Message.RemoveMessage(msgName)
    local newMsgName = (msgName)
    this.NormalMsg[newMsgName] = nil;
    this.NormalMsgListener[newMsgName] = nil;
end

--广播Msg监听
function Message.DispatchMessage(msgName, ...)
    local newMsgName = (msgName)
    local func = this.NormalMsg[newMsgName];
    if func then
        local listener = this.NormalMsgListener[newMsgName];
        if listener then
            func(listener,...)
        else
            func(...)
        end
    end
end