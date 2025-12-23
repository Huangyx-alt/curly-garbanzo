--[[
Descripttion: Csharpsheng'c
version: 1.0.0
Author: LwangZg
email: 1123525779@qq.com
Date: 2025-06-17 11:03:44
LastEditors: LwangZg
LastEditTime: 2025-07-07 14:48:13
Copyright: copyright (c) 2025 Triwin. All rights reserved
--]]

---@class table 模仿Xlua的CS全局对象
CS = {
    --tolua框架提供的Manager
    LuaHelper = LuaFramework.LuaHelper,
    NetManager = LuaFramework.LuaHelper.GetNetManager(),
    SoundManager = LuaFramework.LuaHelper.GetSoundManager(),
    ObjectPoolManager = LuaFramework.LuaHelper.GetObjectPoolManager(),
    NetworkManager = LuaFramework.LuaHelper.GetNetManager(),


    --GFX框架提供的Manager
    GFX_Asset = GameApp.Asset,
    GFX_Config = GameApp.Config,
    GFX_Base = GameApp.Base,
    GFX_Entity = GameApp.Entity,
    GFX_GlobalConfig = GameApp.GlobalConfig,
    GFX_ObjectPool = GameApp.ObjectPool,
    GFX_Sound = GameApp.Sound,
    GFX_Web = GameApp.Web,

    --Unity引擎原生提供的类型
    ---@class CS.AssetType
    AssetType = LuaFramework.AssetType,
    ---@class CS.LoadSceneMode
    LoadSceneMode = UnityEngine.SceneManagement.LoadSceneMode,
    ---@class CS.GameObject
    GameObject = UnityEngine.GameObject,
    ---@class CS.SceneManager
    SceneManager = UnityEngine.SceneManagement.SceneManager,
    ---@class CS.Sprite
    Sprite = UnityEngine.Sprite,
    ---@class CS.SpriteAtlas
    SpriteAtlas = UnityEngine.U2D.SpriteAtlas,
    ---@class CS.Texture2D
    Texture2D = UnityEngine.Texture2D,
    ---@class CS.AudioClip
    AudioClip = UnityEngine.AudioClip,
    ---@class CS.Material
    Material = UnityEngine.Material,


    ---Unity自定义类型
    ---@class CS.SceneHandle
    SceneHandle = YooAsset.SceneHandle,
    ---@class CS.AssetsManager
    AssetsManager = AssetsManager.Instance,


}
