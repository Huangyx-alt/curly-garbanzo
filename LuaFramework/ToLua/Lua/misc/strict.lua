-- strict.lua
-- 检查未声明全局变量的使用
-- 所有全局变量必须通过常规赋值在主代码块中“声明”
-- （即使赋值为 nil 也可以）才能在任何地方使用或赋值给函数内部。
--
-- 已修改以更好地兼容 LuaJIT，请参阅：
-- http://www.freelists.org/post/luajit/strictlua-with-stripped-bytecode

local getinfo, error, rawset, rawget = debug.getinfo, error, rawset, rawget

local mt = getmetatable(_G)
if mt == nil then
  mt = {}
  setmetatable(_G, mt)
end

mt.__declared = {}

mt.__newindex = function (t, n, v)
  if not mt.__declared[n] then
    local info = getinfo(2, "S")
    if info and info.linedefined > 0 then
      error("assign to undeclared variable '"..n.."'", 2)
    end
    mt.__declared[n] = true
  end
  rawset(t, n, v)
end

mt.__index = function (t, n)
  if not mt.__declared[n] then
    local info = getinfo(2, "S")
    if info and info.linedefined > 0 then
      error("variable '"..n.."' is not declared", 2)
    end
  end
  return rawget(t, n)
end
