--=======================================================================
-- Creator      : owen(1053210246@qq.com)
-- Date         : 2017-4-15
-- Description  : 网络类型
-- Modify       :
--=======================================================================
SocketDef = {
    GAME = "GAME_SOCKET",
    MESSAGE = "MSG_SOCKET",

    GAME_HOST = "192.168.0.200",--"slots.dev.com",
    GAME_PORT = 9090,

    MESSAGE_HOST = "192.168.0.200",--"slots.dev.com",
    MESSAGE_PORT = 9090,
}

HttpDef = {
    HOST = "192.168.0.200",         --内网网址
    PORT = 80,                      --内网端口

    INNER_HOST = "192.168.0.200",   --内网网址
    INNER_PORT = 80,                --内网端口

    OUT_HOST = "52.221.239.4",      --外网网址
    OUT_PORT = 80,                  --外网端口

    -- 生产环境
    LIVE_HOST = "triplewin.triwingames.com",
    LIVE_PORT = 80,
}