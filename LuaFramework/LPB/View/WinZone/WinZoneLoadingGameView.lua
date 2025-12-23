local SceneLoadingGameView = require("View/GameLoading/SceneLoadingGameView")
local WinZoneLoadingGameView = SceneLoadingGameView:CreateInstance("WinZoneLoadingGameView")
local this = WinZoneLoadingGameView
this.animNames = {
    enterActionName = "SceneLoadingGameViewenter",
    enterClipName = "WinZoneLoadingGameViewenter",
    exitActionName = "SceneLoadingGameViewend",
    exitClipName = "WinZoneLoadingGameViewend",
}
this.MusicName = "winzoneBattletransition"

--function WinZoneLoadingGameView:OnEnable(params)
--    self.base.OnEnable(self, params)
--    --UISound.play("winzoneBattletransition")
--    --log.r("WinZoneLoadingGameView:OnEnable")
--end

function WinZoneLoadingGameView:OnLoadSceneHomeComplete()
    self.base.OnLoadSceneHomeComplete(self)
    ModelList.WinZoneModel:ShowDisuseProcess()
end

return this