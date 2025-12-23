--[[
    luaide  模板位置位于 Template/FunTemplate/NewFileTemplate.lua 其中 Template 为配置路径 与luaide.luaTemplatesDir
    luaide.luaTemplatesDir 配置 https://www.showdoc.cc/web/#/luaide?page_id=713062580213505
    author:{author}
    time:2021-03-01 15:01:16
]]
FONTS = {}

int2String = function( number )
	if type(number) ~= "number" then
		return number
	end
	local MAX_DIGIT = 10000000000000
	if number > MAX_DIGIT then
		local a = tostring(math.floor(number/MAX_DIGIT))
		local b = tostring(MAX_DIGIT + number%MAX_DIGIT)
		return a..b:sub(2, #b)
	else
		return tostring(number)
	end
end

FONTS.format = function(n, all, decimal, bRound) -- 参数: 数字 是否全部显示 是否保留小数 保留小数的位数 (控制文字显示k,M 和保留小数的位数,带"," ".")
	-- local i, j, int = tostring(n):find('(%d+)')
  	if not all then
		local int,i = int2String(n):reverse():gsub("(%d%d%d)", "%1,")
	  	local ret,j =  int:reverse():gsub("^,", "")  		
  		i = math.min(5, i-j)
  		local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000000,"M"},[3]={1e+9,"B"},[4]={1e+12,"T"},[5]= {1e+15,"Q"}}
  		if decimal then
  			ret = (string.format("%0.2f", n/tt[i][1]))..tt[i][2]
  		else
  			if not bRound or 'number' == type(bRound) then
				local numFraction = 2
				if 'number' == type(bRound) then -- max digits
					local intPart = math.floor(n / tt[i][1])
					local numDigitInt = intPart > 99 and 3 or (intPart >= 9 and 2 or 1)
					numFraction = (bRound - numDigitInt > 0) and bRound - numDigitInt or 0
	  			end
  				ret = int2String(tonumber(string.format("%0." .. numFraction .. "f", n/tt[i][1])))..tt[i][2]
  			else -- true == bRound
  				ret = int2String(math.floor(n / tt[i][1])) .. tt[i][2]
  			end
  		end
  		return ret
  	else
  		local addString = ""
  		if decimal and n~=0 then
  			addString = string.sub(string.format("%d", n%1), 2)  			
  		end
  		n = math.floor(n)
  		local int,i 		= int2String(n):reverse():gsub("(%d%d%d)", "%1,")
	  	local ret,j 		=  int:reverse():gsub("^,", "")  
	  	ret = ret..addString
  		return ret
  	end  	
end
	
FONTS.format_decimal = function(n)
	-- local i, j, int = tostring(n):find('(%d+)')
	local ret = (string.format("%0.2f", n))
  	return ret
end

FONTS.format2 = function(n)
	-- local i, j, int = tostring(n):find('(%d+)')
	local int,i = int2String(n):reverse():gsub("(%d%d%d)", "%1,")
  	local ret,j =  int:reverse():gsub("^,", "")
	i = math.min(3, i-j)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000000,"M"},[3]={1000000000,"B"}}
	return int2String(tonumber(string.format("%0.2f", n/tt[i][1]))), tt[i][2]
end

FONTS.formatByCount = function (n, count) -- 参数1: 数值, 参数2: 多少位之后显示KMB(这个位数显示包括显示出来的"," "K" "M" "B" 都是占一位的)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000,"M"},[3]={1000,"B"},[4]={1000,"T"},[5]={1000,"Q"}} -- 在上一级的基础上 除以 第一个值
	local i=0
	local suffix = tt[i][2]
	while string.len(FONTS.format(n,true)..suffix) >count do 
		i = i+1
		n = n / tt[i][1]
		suffix = tt[i][2]
	end
	return FONTS.format(n, true) .. suffix
end

FONTS.formatByCount2 = function (num, maxLen, decimal)
    local string_len_list = {}

    -- 只加逗号
    local num_len = string.len(tostring(num))

    string_len_list[1] = {type = 1, value = num_len + (num_len % 3 == 0 and (num_len / 3 - 1) or (num_len / 3))}

    -- 逗号+K
    string_len_list[2] = {type = 2, value = (num_len > 3 and (string_len_list[1].value - 3) or 999)}

    -- 逗号+M
    string_len_list[3] = {type = 3, value = (num_len > 6 and (string_len_list[1].value - 7) or 999)}

    -- 逗号+B
    string_len_list[4] = {type = 4, value = (num_len > 9 and (string_len_list[1].value - 11) or 999)}

    -- 逗号+T
    string_len_list[7] = {type = 7, value = (num_len > 12 and (string_len_list[1].value - 15) or 999)}

    -- 逗号+Q
    string_len_list[8] = {type = 8, value = (num_len > 15 and (string_len_list[1].value - 19) or 999)}

    if decimal then
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = (num_len > 3 and ((num_len%3 == 0 and 6 or (num_len % 3 + 3))) or num_len)}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = (num_len > 3 and ((num_len%3 == 0 and 7 or (num_len % 3 + 4))) or num_len)}
    else
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = 999}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = 999}
    end

    table.sort( string_len_list, function (a, b) return a.value>b.value end)

    local format_type = 1
    for i=1, #string_len_list do
    	if string_len_list[i].value <= maxLen then
            format_type = string_len_list[i].type
            break
        end
    end

    local format_string
    if format_type == 1 then
        format_string = FONTS.format(num, true)

    elseif format_type == 2 then
        local temp_num = num / 1000
        format_string = FONTS.format(temp_num, true).."K"

    elseif format_type == 3 then
        local temp_num = num / 1000000
        format_string = FONTS.format(temp_num, true).."M"

    elseif format_type == 4 then
    	local temp_num = num / 1000000000
        format_string = FONTS.format(temp_num, true).."B"
    elseif format_type == 7 then
    	local temp_num = num / 1000000000000
        format_string = FONTS.format(temp_num, true).."T"
    elseif format_type == 8 then
    	local temp_num = num / 1000000000000000
        format_string = FONTS.format(temp_num, true).."Q"

    elseif format_type == 5 then
        format_string = FONTS.format(num, false, false, 2)

    elseif format_type == 6 then
        format_string = FONTS.format(num, false, false)

    end

    return format_string
end

-- 这个格式是不带 "," 及 "." 而且 没有 小数
FONTS.formatByCount3 = function (n, count) -- 参数1: 数值, 参数2: 多少位之后显示KMB(这个位数显示包括显示出来的"K" "M" "B" 都是占一位的)
	local tt = {[0]={1,""},[1]={1000,"K"},[2]={1000,"M"},[3]={1000,"B"},[4]={1000,"T"},[5]={1000,"Q"}} -- 在上一级的基础上 除以 第一个值
	local i=0
	local suffix = tt[i][2]
	while string.len(math.floor(n)..suffix) >count do 
		i = i+1		
		n = n / tt[i][1]
		suffix = tt[i][2]
	end
	n = math.floor(n)
	return n..suffix
end
---@param num 原始数字
---@param maxLen 最大长度
---@param decimal 是否显示小数位
---@param isRound 是否向下取整
FONTS.formatByCount4 = function (num, maxLen, decimal,isRoundDown)
    local string_len_list = {}

    -- 只加逗号
    local num_len = string.len(string.format("%d",tonumber(num)))

    string_len_list[1] = {type = 1, value = num_len + (num_len % 3 == 0 and (math.floor(num_len / 3) - 1) or (math.floor(num_len / 3)))}

    -- 逗号+K
    string_len_list[2] = {type = 2, value = (num_len > 3 and (string_len_list[1].value - 3) or 999)}

    -- 逗号+M
    string_len_list[3] = {type = 3, value = (num_len > 6 and (string_len_list[1].value - 7) or 999)}

    -- 逗号+B
    string_len_list[4] = {type = 4, value = (num_len > 9 and (string_len_list[1].value - 11) or 999)}

    -- 逗号+T
    string_len_list[7] = {type = 7, value = (num_len > 12 and (string_len_list[1].value - 15) or 999)}

    -- 逗号+Q
    string_len_list[8] = {type = 8, value = (num_len > 15 and (string_len_list[1].value - 19) or 999)}

    if decimal then
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = (num_len > 3 and ((num_len%3 == 0 and 6 or (num_len % 3 + 3))) or num_len)}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = (num_len > 3 and ((num_len%3 == 0 and 7 or (num_len % 3 + 4))) or num_len)}
    else
        -- 带一位小数的KMB
        string_len_list[5] = {type = 5, value = 999}

        -- 带两位小数的KMB
        string_len_list[6] = {type = 6, value = 999}
    end

    table.sort( string_len_list, function (a, b) return a.value>b.value end)
    local format_type = 1
    for i=1, #string_len_list do
        if string_len_list[i].value <= maxLen then
            format_type = string_len_list[i].type
            break
        end
    end

    local format_string
    if format_type == 1 then
        format_string = FONTS.format(num, true)

    elseif format_type == 2 then
        local temp_num = num / 1000
        format_string = FONTS.format(temp_num, true).."K"

    elseif format_type == 3 then
        local temp_num = num / 1000000
        format_string = FONTS.format(temp_num, true).."M"

    elseif format_type == 4 then
        local temp_num = num / 1000000000
        format_string = FONTS.format(temp_num, true).."B"
    elseif format_type == 7 then
        local temp_num = num / 1000000000000
        format_string = FONTS.format(temp_num, true).."T"
    elseif format_type == 8 then
        local temp_num = num / 1000000000000000
        format_string = FONTS.format(temp_num, true).."Q"

    elseif format_type == 5 then
        format_string = FONTS.format(num, false, false)
		if string.len(format_string)>maxLen then
			local str1 = 	string.match(format_string, "%d+.%d+")
			local str2 =    string.match(format_string, "[^$0-9%.]")
			if not isRoundDown then
				str1 = string.format("%0.1f",str1)
				if math.floor(str1)-str1 == 0 then -- 如果小数位只有0 则只显示整数位
					str1 = math.floor(str1)
				end
			else
				if math.floor(str1)-str1 == 0 then -- 如果小数位只有0 则只显示整数位
					str1 = math.floor(str1)
				else
					str1 =  (str1 -str1 %0.1) -- 小数向下区取整
					if math.floor(str1)-str1 == 0 then
						 math.floor(str1)
					end
				end
			end
			format_string = str1..str2

		end
    elseif format_type == 6 then
        format_string = FONTS.format(num, false, false)
    end
    return format_string
end