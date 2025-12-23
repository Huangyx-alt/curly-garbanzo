
LobbyEntityView = BaseView:New("LobbyEntityView")
local this = LobbyEntityView
this.viewType = CanvasSortingOrderManager.LayerType.None

this.auto_bind_ui_items = {
    "anima"
}

function LobbyEntityView:New()
    local o = {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function LobbyEntityView:Awake()
    self:on_init()
end

function LobbyEntityView:OnEnable()
    if fun.is_not_null(self.go)  then
        self.go.transform.localScale = Vector3.one
        self.go.transform.anchorMin = Vector2.New(0,0)
        self.go.transform.anchorMax = Vector2.New(1,1)
        self.go.transform.pivot = Vector2.New(0.5,0.5)
        self.go.transform.offsetMax = Vector2.New(0,0)
        self.go.transform.offsetMin = Vector2.New(0,0)
    end
    self._init = true
    if self._enter_callback then
        self:PlayEnterLobby(self._enter_callback)
    end
end

function LobbyEntityView:OnDisable()
    self._init = nil
    self._enter_callback = nil
end

function LobbyEntityView:DestroyLobby()
    if self.go then
        Destroy(self.go)
        self.go = nil
    end
end

function LobbyEntityView:PlayEnterLobby(callback)
    self._enter_callback = callback
    if not self._init then
        return
    else
        AnimatorPlayHelper.Play(self.anima,{"enter",string.format("play%sbackgroundenter",ModelList.CityModel.GetPlayIdByCity())},false,function()
            if self._enter_callback then
                self._enter_callback()
                self._enter_callback = nil
            end
        end,0.35)
    end
end