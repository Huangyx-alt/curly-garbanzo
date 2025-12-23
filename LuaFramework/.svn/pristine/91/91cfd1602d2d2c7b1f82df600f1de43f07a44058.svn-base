WWWLoader = {}

require "Utils.Eventer"

WWWLoader = Clazz()

function WWWLoader.create()
    local loader = WWWLoader:new()
    loader.has_dipose = false
    return loader
end

function WWWLoader:run(file_path, on_success)
    if not self.has_dipose then
        self.url = file_path
        self.success_hanlder = on_success
        self.coroutine = fun.run(function() self:load_coroutine() end)
    end
end


function WWWLoader:load_coroutine()
end

function WWWLoader:dispose()
   if self.coroutine then
        fun.stop(self.coroutine)
        self.coroutine = nil
   end
   self.has_dipose = true
end
