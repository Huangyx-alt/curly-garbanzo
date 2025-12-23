DebugMode = {}
DebugMode.local_server_mode = false

--游戏相关const--

IS_TEST_MODE = true --调试模式，true=可以独立场景运行
IS_OPEN_DEBUG = false --是否开启日志


Util = LuaFramework.Util
AppConst = LuaFramework.AppConst
LuaHelper = LuaFramework.LuaHelper
ByteBuffer = LuaFramework.ByteBuffer

resMgr = LuaHelper.GetResManager()
soundMgr = LuaHelper.GetSoundManager()
-- socketMgr = LuaHelper.GetSocketManager()
poolMgr = LuaHelper.GetObjectPoolManager()
-- tipMgr = LuaHelper.GetTipsManager()
WWW = UnityEngine.WWW
GameObject = UnityEngine.GameObject
Protocal = LuaFramework.Protocal
Config = {
	coin_audio_len = 2,
	diamond_audio_len = 2,
}

--需要在loading界面缓存一遍的所有assetbundle物体
GamePrefab = {
	"baoxiang",
	"baoxiang_comeout",
}
