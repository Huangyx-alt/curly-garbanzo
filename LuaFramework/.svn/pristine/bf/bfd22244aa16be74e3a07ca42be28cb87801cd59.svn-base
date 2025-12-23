local BaseOrder = require "PopupOrder/BaseOrder"
local PopupOrder = Clazz(BaseOrder,"")
local this = PopupOrder

function PopupOrder.Execute()
	Event.AddListener(EventName.Event_show_tournament_score_view,this.Finish)
	
	if not ModelList.TournamentModel:IsActivityAvailable() then
		this.Finish()
		return
	end
	
	if this.CheckLvOpen() then
		if ModelList.TournamentModel:CheckHasStateAward() then
			local oldScore,oldTier = ModelList.TournamentModel:GetStateAwardScore();
			local tier = ModelList.TournamentModel:GetTiers()
			local isUpTier = nil;
			if oldTier ~= nil then
				isUpTier = oldTier ~= tier;
			end
			Facade.SendNotification(NotifyName.ShowUI, ViewList.TournamentScoreView,nil,false,
				{isUpTier = isUpTier,oldScore = oldScore,lastWeekTier = oldTier})
		else
			this.Finish()	
		end
	else
		this.Finish()
	end
end

function PopupOrder.Finish()
	Event.RemoveListener(EventName.Event_show_tournament_score_view,PopupOrder.Finish)
	log.g("brocast  EventName.Event_popup_order_finish ")
	Event.Brocast(EventName.Event_popup_order_finish,true)
end

function PopupOrder.CheckLvOpen()
	local openLevel = ModelList.TournamentModel:GetUnlockTournamentLv()
	local myLevel = ModelList.PlayerInfoModel:GetLevel()

	return myLevel >= openLevel
end

return PopupOrder