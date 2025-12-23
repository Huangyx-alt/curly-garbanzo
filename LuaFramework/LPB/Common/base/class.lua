--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2021-11-19 15:47:52
]]

_setmetatableindex = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        _setmetatableindex(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            _setmetatableindex(mt, index)
        end
    end
end


function class_cocos(classname, ...) --参数一：所要创建的类名，参数二：可选参数，可以使function，也可以是table，userdata等
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do --遍历可选参数
        local superType = type(super)
          if superType == "function" then
            --如果是个function，那么就让cls的create方法指向他
            cls.__create = super
        elseif superType == "table" then --如果是个table
            if super[".isclass"] then--如果是个原生cocos类，比如cc.Sprite，不是自定义的
                 cls.__create = function() return super:create() end
            else
                -- 如果是个纯lua类，自己定义的那种，比如a={}
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super--不断加到__supers的数组中
                if not cls.super then
                    -- 把第一个遍历到的table作为cls的超类
                    cls.super = super
                end
            end

        end
    end

    cls.__index = cls--不知道作用
    if not cls.__supers or #cls.__supers == 1 then --这个就是单继承，设置cls的元表的index为他的第一个超类
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)--羡慕是多继承，index指向一个函数，到时候找元素的时候会遍历函数
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- 增加一个默认构造函数
        cls.ctor = function() end
    end
    cls.new = function(...) --新建方法，这个也是比较重要的方法
        local instance
        if cls.__create then
            --如果有create方法，那么就调用，正常情况下，自定义的cls是没有create方法的。
            --会不断的向上寻找元类的index，直到找到原生cocos类，比如sprite，然后调用sprite:create()
            --返回一个原生对象，通过调试代码，可以得出这些

            instance = cls.__create(...)
        else
            instance = {}--没有，说明根目录不是cocos类，而是普通类
        end
        --这个方法也比较关键，设置instance的元类index，谁调用new了，就把他设置为instance的元类index
        --具体可以看代码
        _setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)--调用构造函数
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end
--------------------------------------------

local setmetatableindex_
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            tolua.setpeer(t, peer)
        end
        setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end

function class_v2(classname, ...)
    local cls = {__cname = classname}
    cls.classname = classname
    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end