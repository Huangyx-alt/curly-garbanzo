--region TipsView.lua
--二级弹出确认框etc.
--endregion
local wait = coroutine.wait
local start = coroutine.start
local isLoaded = coroutine.isLoaded
local setmetatable = setmetatable

TipsView = BaseView:New('TipsView')
local this = TipsView;
this.__index = this;
local TweenTime = 0.18;

--显示Tips对象
function TipsView:Show(args)
	self.args = args;
	logWarn("Show Tips UI:--->>" .. self.boxName);
	if not self.isLoaded then
		self.loader = BaseLoad:New(self.bundleName or AssetList[self.viewName], BundleType.UI);
		self.loader.isLoaded = false;
		self.loader:Load(self.boxName);
		start(self.Loaded, self);
	else
		self.isShow = true;
 
		fun.set_active(self.gameObject,true)
		if self.isTween then self:TweenShow(); end
	end
end

--创建Tips对象--
function TipsView:New(viewName, boxName,bundleName)
	return setmetatable({viewName = viewName, boxName = boxName,bundleName = bundleName, isTween = true}, this);
end

--加载Tips对象并显示
function TipsView:Loaded()
	isLoaded(self.loader);
	self.isLoaded = true;
	self.isShow = true;
	
	self.gameObject = Instantiate(self.loader.loaded);
	self.gameObject.name = self.boxName;
	self.transform = self.gameObject.transform;
	self.content = self.transform:Find('Content');
	self.transform:SetParent(TipsCanvas);
	self.transform:SetAsLastSibling();
	Identity(self.transform);
	self.gameObject:AddComponent(typeof(LuaBehaviour));
	local rectTransform = self.gameObject:GetComponent(typeof(RectTransform));
	rectTransform.offsetMin = Vector2.zero;
	rectTransform.offsetMax = Vector2.zero;
	if self.isTween then self:TweenShow(); end
end

--Tips 显示Tween动画
function TipsView:TweenShow()
	local transform = self.content;
	transform.localScale = Vector3.New(0.2, 0.2, 0);
	transform:DOScale(Vector3.New(1, 1, 1), TweenTime):SetEase(Ease.OutBack);
end

--Tips 隐藏Tween动画
function TipsView:TweenHide()
	local transform = self.content;
	transform.localScale = Vector3.New(1, 1, 1);
	transform:DOScale(Vector3.New(0.2, 0.2, 0), TweenTime):SetEase(Ease.InBack);
end

--隐藏Tips对象
function TipsView:Hide()
	logWarn("Hide Tips UI:--->>" .. self.boxName);
	SoundManager.Play(SoundName.Close);
	local function doHide()
		if self.isShow then 
 
			fun.set_active(self.gameObject,false)
		end
		self.isShow = false;
	end
	if not self.isTween then doHide() return end
	self:TweenHide();
	local function waitForHide() wait(TweenTime); doHide();end
	start(waitForHide);
end

--销毁Tips对象
function TipsView:Close()
	logWarn("Destroy Tips UI:--->>" .. self.boxName);
	SoundManager.Play(SoundName.Close);
	local function doClose()
		if self.isLoaded then Destroy(self.gameObject); end
		self.isLoaded = false;
	end
	if not self.isTween then doClose() return end
	self:TweenHide();
	local function waitForClose() wait(TweenTime); doClose();end
	start(waitForClose);
end
return this