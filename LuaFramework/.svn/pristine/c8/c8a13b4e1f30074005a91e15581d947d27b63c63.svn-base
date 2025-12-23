---@class LogicEntry 逻辑入口开关
local LogicEntry = BaseClass("LogicEntry")

function LogicEntry.__init(self)
	
end

function LogicEntry.__delete(self)
	self:OnDestroy()
end

function LogicEntry.OnLoad(self)
   
end

function LogicEntry:BingoBangRun()
	---@class BingoBangEntry
	_G.BingoBangEntry = require "Logic.BingoBangEntry"
	_G.GlobalArtConfig = require "Logic.GlobalArtConfig"
	print("新的bang业务 LogicEntry:BingoBangRun")
end

function LogicEntry:LivePartyBingoRun()
	---@class LivePartyBingoEntry
	_G.LivePartyBingoEntry = require "Logic.LivePartyBingoEntry"

	if _G.MainRequireLua ~= nil then
        _G.MainRequireLua()
    end
	log.log("旧的lpb业务 LogicEntry:LivePartyBingoRun")
end

function LogicEntry:GlobalRedirect()
	IsNull = Util.IsNull
	log.log("全局重定向 LogicEntry:GlobalRedirect")
end

function LogicEntry:NetworkStart()
	_G.Network.Start()
	log.g(" LogicEntry:Network.Start ")
end

-- 获取名字
function LogicEntry.GetName(self)
	return self.__name
end

return LogicEntry

