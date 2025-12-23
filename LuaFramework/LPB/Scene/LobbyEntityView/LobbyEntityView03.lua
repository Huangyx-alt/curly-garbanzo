require "Scene/LobbyEntityView"

local Play03LobbyEntityView = LobbyEntityView:New()
local this = Play03LobbyEntityView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima"
}

function Play03LobbyEntityView:PlayEnterLobby(callback)
    if callback then
        callback()
    end
end

return this