--region BaseBindView.lua
--BindView 层基类 通过传来的obj绑定，不loadprefab,也不销毁 。
--endregion
local setmetatable = setmetatable
local wait = coroutine.wait

BaseBindView = BaseView:New("BaseBindView")
local this = BaseBindView;
this.__index = this;
this.name = "bindname"
--this.luabehaviour = nil --LuaBehaviour c#代码，详细查看其
--this.update_x_enabled = false --开启独立刷新
--this.dev_mode_ui_list = {}  --Dev环境显示的uilist
--this.auto_bind_ui_items = {} --控制绑定列表
--


----创建View对象--
function BaseBindView:New(viewName, atlasName,bundleName)
    return setmetatable({viewName = viewName, atlasName = atlasName,bundleName = bundleName, isShow = false, isLoaded = false}, this);
end


--显示View对象
function BaseBindView:Show(args)
    self.args = args;
    if(self.go==nil)then
        self.go = args[1]
        self.transform = self.go.transform
        self.luabehaviour = Util.AddLuaBehaviour(self.go) --self.go:AddComponent(typeof(fun.LUABEHAVIOUR));
        --正常情况下,新生成的界面sibling_index设置为0,表示在有panel的最下面(每下也只有一个).而当出现对话框时,则出上在上面
        --self:on_init()
    else
        fun.set_active(self.go,true)
    end
    --UIManager:ShowUI(self.viewName);
    self.isLoaded = true;
    self.isShow = true;
end
--




return this