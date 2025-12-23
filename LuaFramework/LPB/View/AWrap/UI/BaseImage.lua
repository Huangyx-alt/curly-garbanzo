--region BaseImage.lua
--Image 包装器(使用Atlas)
--endregion
local setmetatable = setmetatable

BaseImage = BaseLoad:New('BaseImage', BundleType.Atlas);
local this = BaseImage;
this.__index = this;

--创建LoadImage对象
--参数说明：image C#脚本对象，bundleName代表资源包名称
function BaseImage:New(image, bundleName)
	local oc = setmetatable({bundleName = bundleName, image = image}, this);
	oc:Load();
	return oc;
end

--设置sprite名称
function BaseImage:SetSprite(spriteName)
	if not self.isLoaded then return end
	self.image.sprite = self.loaded:LoadHeadSprite(spriteName);
	self.image:SetNativeSize();
end
return this;