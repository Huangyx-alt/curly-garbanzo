local TournamentScoreBgConfig = {
	tournament = {	---周榜
		--1大背景亮色、2段位奖励背景,3奖励描边,4段位奖励奖杯台子,5段位积分背景,6点位未解锁，7点位解锁,8阶段奖励背景框,9阶段奖励积分背景,10大背景暗,11分界线,12顶部段位奖励背景
		[1] = { { 133, 82, 24, 255 }, "ZBzym111", { 170, 74, 0, 255 }, "ZBzym102", "ZBzym109", "ZBzym103", "ZBzym104", "ZBzym106", "ZBzym105", { 109, 59, 19, 255 }, "ZBzymHLight1", "ZBzym111" },
		[2] = { { 5, 114, 92, 255 }, "ZBzym211", { 0, 45, 3, 255 }, "ZBzym202", "ZBzym209", "ZBzym203", "ZBzym204", "ZBzym206", "ZBzym205", { 22, 68, 72, 255 }, "ZBzymHLight2", "ZBzym211" },
		[3] = { { 171, 88, 54, 255 }, "ZBzym311", { 176, 41, 28, 255 }, "ZBzym302", "ZBzym310", "ZBzym303", "ZBzym304", "ZBzym306", "ZBzym305", { 119, 42, 22, 255 }, "ZBzymHLight3", "ZBzym311" },
		[4] = { { 51, 121, 208, 255 }, "ZBzym411", { 8, 38, 157, 255 }, "ZBzym402", "ZBzym410", "ZBzym403", "ZBzym404", "ZBzym406", "ZBzym405", { 56, 49, 192, 255 }, "ZBzymHLight4", "ZBzym411" },
		[5] = { { 116, 45, 146, 255 }, "ZBzym511", { 126, 0, 194, 255 }, "ZBzym502", "ZBzym510", "ZBzym503", "ZBzym504", "ZBzym506", "ZBzym505", { 103, 26, 158, 255 }, "ZBzymHLight5", "ZBzym511" },
		[6] = { { 113, 41, 30, 255 }, "ZBzym612", { 57, 15, 12, 255 }, "ZBzym602", "ZBzym610", "ZBzym603", "ZBzym604", "ZBzym606", "ZBzym605", { 46, 19, 11, 255 }, "ZBzymHLight6", "ZBzym612" },
	},
	halloffame = {	---名人堂
		--			1大背景亮色、		2段位奖励背景,	  3奖励描边,	  4段位奖励奖杯台子,5段位积分背景,6点位未解锁，7点位解锁,    8阶段奖励背景框,9阶段奖励积分背景,10大背景暗,11分界线,12顶部段位奖励背景
		[1] = { { 133, 82, 24, 255 }, "MRTzym111", { 170, 74, 0, 255 }, "ZBzym102", "ZBzym109", "ZBzym103", "ZBzym104", "ZBzym106", "ZBzym105", { 109, 59, 19, 255 }, "ZBzymHLight1", "MRTzym111" },
		[2] = { { 5, 114, 92, 255 }, "MRTzym211", { 0, 45, 3, 255 }, "ZBzym202", "ZBzym209", "ZBzym203", "ZBzym204", "ZBzym206", "ZBzym205", { 22, 68, 72, 255 }, "ZBzymHLight2", "MRTzym211" },
		[3] = { { 171, 88, 54, 255 }, "MRTzym311", { 176, 41, 28, 255 }, "ZBzym302", "ZBzym310", "ZBzym303", "ZBzym304", "ZBzym306", "ZBzym305", { 119, 42, 22, 255 }, "ZBzymHLight3", "MRTzym311" },
		[4] = { { 51, 121, 208, 255 }, "MRTzym411", { 8, 38, 157, 255 }, "ZBzym402", "ZBzym410", "ZBzym403", "ZBzym404", "ZBzym406", "ZBzym405", { 56, 49, 192, 255 }, "ZBzymHLight4", "MRTzym411" },
		[5] = { { 116, 45, 146, 255 }, "MRTzym511", { 126, 0, 194, 255 }, "ZBzym502", "ZBzym510", "ZBzym503", "ZBzym504", "ZBzym506", "ZBzym505", { 103, 26, 158, 255 }, "ZBzymHLight5", "MRTzym511" },
		[6] = { { 113, 41, 30, 255 }, "MRTzym612", { 57, 15, 12, 255 }, "ZBzym602", "ZBzym610", "ZBzym603", "ZBzym604", "ZBzym606", "ZBzym605", { 46, 19, 11, 255 }, "ZBzymHLight6", "MRTzym612" },
	},

}

local this = TournamentScoreBgConfig


local mt = {
	__index = function(t,k)
		--return TournamentScoreBgConfig["halloffame"][k]
		if ModelList.TournamentModel:CheckOpenTournament() then
			return TournamentScoreBgConfig["tournament"][k]
		else
			return TournamentScoreBgConfig["halloffame"][k]
		end
	end}
setmetatable(this,mt)
mt.__metatable = false


return TournamentScoreBgConfig