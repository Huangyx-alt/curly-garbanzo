RandomBot = Clazz()

function RandomBot.create(range, check_step)
    local robot = RandomBot:new()
    robot.range = range
    robot.memory = {}
    robot.check_step = check_step
    return robot
end

function RandomBot:next()
    local r = math.random(1, self.range)
    while not self:validate(r) do
        r = math.random(1, self.range)
    end
    self:add_to_memory(r)
    return r
end

function RandomBot:validate(result)
    for i = 1, #self.memory do
        if self.memory[i] == result then
            return false
        end
    end
    return true
end

function RandomBot:add_to_memory(result)
    if #self.memory < self.check_step then
        self.memory[#self.memory + 1] = result
    else
        for i = 1, self.check_step - 1 do
            self.memory[i] = self.memory[i + 1]
        end
        self.memory[self.check_step] = result
    end
end

function RandomBot:reset()
    self.memory = {}
end