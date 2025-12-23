WWWSpriteLoader = {}

require "Utils.WWWLoader"

WWWSpriteLoader = Clazz(WWWLoader)


function WWWSpriteLoader.create()
    local loader = WWWSpriteLoader:new()
    loader.has_dipose = false
    return loader
end

function WWWSpriteLoader:load_coroutine()
    local path = UIUtil.fix_path(self.url)
    local www = UnityEngine.WWW(path)
    coroutine.www(www)
    if www.isDone and not www.error then
        --www.texture每调一次，就会产生一个texture对象
        local sprite = Util.Texture2Sprite(www.texture)
        if self.success_hanlder then
            self.success_hanlder(sprite)
        end
    else
        log.r("www图片加载失败，错误信息："..www.error)
    end
    www:Dispose()
end
