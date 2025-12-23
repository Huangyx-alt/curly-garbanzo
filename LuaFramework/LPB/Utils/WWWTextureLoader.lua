WWWTextureLoader = {}

require "Utils.WWWLoader"

WWWTextureLoader = Clazz(WWWLoader)


function WWWTextureLoader.create()
    local loader = WWWTextureLoader:new()
    loader.has_dipose = false
    return loader
end

function WWWTextureLoader:load_coroutine()
    local path = UIUtil.fix_path(self.url)
    local www = UnityEngine.WWW(path)
    coroutine.www(www)
    if www.isDone and not www.error then
        --www.texture每调一次，就会产生一个texture对象
        local texture = www.texture
        if self.success_hanlder then
            self.success_hanlder(texture)
        end
    else
        log.r("www图片加载失败，错误信息："..www.error)
    end
    www:Dispose()
end
