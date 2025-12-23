--by Lwang 移到单元测试模块
-- require "3rd/pblua/login_pb" 
-- require "3rd/pbc/protobuf"
require "Common.define"     -- by LwangZg LivePartyBingoEntry 注册了

local lpeg = require "lpeg"

local json = require "cjson"
local util = require "3rd/cjson/util"

-- local sproto = require "3rd/sproto/sproto"
-- local core = require "sproto.core"
-- local print_r = require "3rd/sproto/print_r"

local pb = require "pb"
AppConst = LuaFramework.AppConst;
local pbfile = AppConst.ExternalinkRoot .. "/Lua" .. "/Net/proto/PB_AbParams.pb"

require "Logic/LuaClass"
require "Logic/CtrlManager"
require "Common/functions"
require "Controller/PromptCtrl"

--管理器--
Game = {};
local this = Game;

local game;
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

function Game.InitViewPanels()
    for i = 1, #PanelNames do
        require("View/" .. tostring(PanelNames[i]))
    end
end

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    print("[lua侧] 初始化完成，发送链接服务器信息")
    -- AppConst.SocketPort = 2012;
    -- AppConst.SocketAddress = "127.0.0.1";
    networkMgr:SendConnect("192.168.1.231",9661);
    
    --注册LuaView--
    this.InitViewPanels();

    this.test_class_func();
    -- this.test_pblua_func();
    this.test_cjson_func();
    -- this.test_pbc_func();
    this.test_lpeg_func();
    -- this.test_sproto_func();
    this.test_luaprotobuf_func();
    coroutine.start(this.test_coroutine);

    CtrlManager.Init();
    local ctrl = CtrlManager.GetCtrl(CtrlNames.Prompt);
    if ctrl ~= nil and AppConst.ExampleMode == 1 then
        ctrl:Awake();
    end

    logWarn('LuaFramework InitOK--->>>');
end

--测试协同--
function Game.test_coroutine()
    logWarn("1111");
    coroutine.wait(1);
    logWarn("2222");

    local www = WWW("http://bbs.ulua.org/readme.txt");
    coroutine.www(www);
    logWarn(www.text);
end

--测试lua-protobuf
function Game.test_luaprotobuf_func()
    -- logError("测试lua- protobuf-------->>");
    -- logError("测试PB_AbParams" .. pbfile);
    assert(pb.loadfile(pbfile)) -- pb.loadfile载入刚才编译的pb文件
    -- assert(pb.load('PB_AdCount.pb')) -- 载入刚才编译的pb文件

    -- -- lua table data
    -- local data = {
    --     event =101,
    --     count = 1,
    --     type = 0,
    --     params = "test",
    --     adType = 6,
    --     -- id = 6,
    -- }

    local data = {
        name = "opopoppo",
    }

    -- encode lua table data into binary format in lua string and return
    local bytes = assert(pb.encode("GPBClass.Message.PB_AbParams", data))
    print(pb.tohex(bytes))
    -- and decode the binary data back into lua table
    local data2 = assert(pb.decode("GPBClass.Message.PB_AbParams", bytes))
    print(require "3rd/lua-protobuf/serpent".block(data2))

    -- load schema from text
    -- assert(protoc:load [[
    -- syntax = "proto3";

    -- message Phone {
    --     string name = 1;
    --     int64 phonenumber = 2;
    -- }
    -- message Person {
    --     string name = 1;
    --     int32 age = 2;
    --     string address = 3;
    --     repeated Phone contacts = 4;
    -- } ]])

    -- -- lua table data
    -- local data = {
    --     name = "ilse",
    --     age = 18,
    --     contacts = {
    --         { name = "alice", phonenumber = 12312341234 },
    --         { name = "bob",   phonenumber = 45645674567 }
    --     }
    -- }

    -- -- encode lua table data into binary format in lua string and return
    -- local bytes = assert(pb.encode("Person", data))
    -- print(pb.tohex(bytes))
    -- -- and decode the binary data back into lua table
    -- local data2 = assert(pb.decode("Person", bytes))
    -- print(require "3rd/lua-protobuf/serpent".block(data2))
end

--测试sproto--
function Game.test_sproto_func()
    logWarn("test_sproto_func-------->>");
    local sp = sproto.parse [[
    .Person {
        name 0 : string
        id 1 : integer
        email 2 : string

        .PhoneNumber {
            number 0 : string
            type 1 : integer
        }

        phone 3 : *PhoneNumber
    }

    .AddressBook {
        person 0 : *Person(id)
        others 1 : *Person
    }
    ]]

    local ab = {
        person = {
            [10000] = {
                name = "Alice",
                id = 10000,
                phone = {
                    { number = "123456789", type = 1 },
                    { number = "87654321",  type = 2 },
                }
            },
            [20000] = {
                name = "Bob",
                id = 20000,
                phone = {
                    { number = "01234567890", type = 3 },
                }
            }
        },
        others = {
            {
                name = "Carol",
                id = 30000,
                phone = {
                    { number = "9876543210" },
                }
            },
        }
    }
    local code = sp:encode("AddressBook", ab)
    local addr = sp:decode("AddressBook", code)
    print_r(addr)
end

--测试lpeg--
function Game.test_lpeg_func()
    logWarn("test_lpeg_func-------->>");
    -- matches a word followed by end-of-string
    local p = lpeg.R "az" ^ 1 * -1

    print(p:match("hello"))       --> 6
    print(lpeg.match(p, "hello")) --> 6
    print(p:match("1 hello"))     --> nil
end

--测试lua类--
function Game.test_class_func()
    LuaClass:New(10, 20):test();
end

--测试pblua--
function Game.test_pblua_func()
    local login = login_pb.LoginRequest();
    login.id = 2000;
    login.name = 'game';
    login.email = 'jarjin@163.com';

    local msg = login:SerializeToString();
    LuaHelper.OnCallLuaFunc(msg, this.OnPbluaCall);
end

--pblua callback--
function Game.OnPbluaCall(data)
    local msg = login_pb.LoginRequest();
    msg:ParseFromString(data);
    print(msg);
    print(msg.id .. ' ' .. msg.name);
end

--测试pbc--
function Game.test_pbc_func()
    local path = AppConst.ExternalinkRoot .. "/" .. "lua/3rd/pbc/addressbook.pb";
    logInfo('io.open--->>>' .. path);

    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)

    local addressbook = {
        name = "Alice",
        id = 12345,
        phone = {
            { number = "1301234567" },
            { number = "87654321",  type = "WORK" },
        }
    }
    local code = protobuf.encode("tutorial.Person", addressbook)
    LuaHelper.OnCallLuaFunc(code, this.OnPbcCall)
end

--pbc callback--
function Game.OnPbcCall(data)
    local path = AppConst.ExternalinkRoot .. "/" .. "lua/3rd/pbc/addressbook.pb";

    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
    local decode = protobuf.decode("tutorial.Person", data)

    print(decode.name)
    print(decode.id)
    for _, v in ipairs(decode.phone) do
        print("\t" .. v.number, v.type)
    end
end

--测试cjson--
function Game.test_cjson_func()
    local path = AppConst.ExternalinkRoot .. "/" .. "lua/3rd/cjson/example2.json";
    local text = util.file_load(path);
    LuaHelper.OnJsonCallFunc(text, this.OnJsonCall);
end

--cjson callback--
function Game.OnJsonCall(data)
    local obj = json.decode(data);
    print(obj['menu']['id']);
end

--销毁--
function Game.OnDestroy()
    --logWarn('OnDestroy--->>>');
end
