local ClubInfoItemView = require "View/ClubView/ChildView/ClubInfoItem"
local InfiniteList = require "View/CommonView/Comp/InfiniteList"

local ClubListSearchView = BaseView:New('ClubListSearchView',"ClubAtlas")
local this = ClubListSearchView
this.viewType = CanvasSortingOrderManager.LayerType.TopConsole
local private = {}

function ClubListSearchView:New(view)
    local o = {};
    setmetatable(o, { __index = this })
    o.view = view
    return o
end

this.auto_bind_ui_items = {
    "btn_goback",
    "search_input",
    "btn_sort",
    "btn_clear",
    "club_content",
    "club_item",
    "scrollView",
    "content",
    "SearchOrderList",
    "btn_CountDescendingOrder",
    "btn_CountAscendingOrder",
    "btn_NameDescendingOrder",
    "btn_NameAscendingOrder",
    "btn_ClickMask",
    "input_placeholder",
}

function ClubListSearchView:Awake()
    self:on_init()
    private.InitClubsData()
    private.InitInfiniteList(self)
    private.InitSearchText(self)
end

function ClubListSearchView:OnEnable()
    if not private.InfiniteList then
        private.InitInfiniteList(self)
    end
    
    Facade.RegisterView(self)
    
    fun.set_active(self.SearchOrderList, false)
    self.input_placeholder.text = Csv.GetDescription(30084)
    
    if not private.clubsData then
        private.InitClubsData()
    end
    private.UpdateInfiniteList()
end

function ClubListSearchView:OnDisable()
    private.clubsData = nil
end

function ClubListSearchView:OnDestroy()
    self:Destroy()
    if private.InfiniteList then
        private.InfiniteList:OnDestroy()
    end
end

function ClubListSearchView:Promote(params)
    private.InitClubsData()
    private.UpdateInfiniteList()
end

function ClubListSearchView:on_btn_goback_click()
    Facade.SendNotification(NotifyName.CloseUI, self)
end

function ClubListSearchView:on_btn_sort_click()
    fun.set_active(self.SearchOrderList, true)
end

function ClubListSearchView:on_btn_clear_click()
    self.search_input.text = ""
    private.ShowSearchResult(self, self.search_input.text)
end

function ClubListSearchView:on_btn_CountDescendingOrder_click()
    table.sort(private.clubsData, function(a, b)
        if a.isRecommend then return true end
        if b.isRecommend then return false end
        if a.curNum ~= b.curNum then return a.curNum > b.curNum end
        return a.clubId < b.clubId
    end)
    private.UpdateInfiniteList()
    fun.set_active(self.SearchOrderList, false)
end

function ClubListSearchView:on_btn_CountAscendingOrder_click()
    table.sort(private.clubsData, function(a, b)
        if a.isRecommend then return true end
        if b.isRecommend then return false end
        if a.curNum ~= b.curNum then return a.curNum < b.curNum end
        return a.clubId < b.clubId
    end)
    private.UpdateInfiniteList()
    fun.set_active(self.SearchOrderList, false)
end

function ClubListSearchView:on_btn_NameDescendingOrder_click()
    private.SortByName(true)
    private.UpdateInfiniteList()
    fun.set_active(self.SearchOrderList, false)
end

function ClubListSearchView:on_btn_NameAscendingOrder_click()
    private.SortByName()
    private.UpdateInfiniteList()
    fun.set_active(self.SearchOrderList, false)
end

function ClubListSearchView:on_btn_ClickMask_click()
    fun.set_active(self.SearchOrderList, false)
end

function ClubListSearchView:_close()
    self.__index.closeWithAnimation(self)
end

----------------------Private Func-----------------------------

function private.InitClubsData()
    local data = ModelList.ClubModel.GetClubList()
    data = DeepCopy(data)
    
    --去掉自己所在的公会
    local selfClubID = ModelList.ClubModel.GetSelfClubID()
    if selfClubID and selfClubID > 0 then
        for i = 1, #data do
            if data[i].clubId == selfClubID then
                table.remove(data, i)
                break
            end
        end
    end
    
    private.clubsData = private.DefaultSortClubFunc(data)
end

---默认排序
function private.DefaultSortClubFunc(data)
    private.recommendClub = private.GetRecommendClub(data)
    table.remove(data, private.recommendClub.key)

    local ret = {}

    --根据成员人数比例分组
    local controlCfg = Csv.GetData("control", 165, "content")
    controlCfg = controlCfg or {{70},{50},{30},{10}}
    local memberControl, totalCount = {}, 0
    table.each(controlCfg, function(value, index)
        --配置第一个用于推荐公会计算
        if index > 1 then
            local percent = value[1]
            table.insert(memberControl, { 
                percent = percent,
                key = string.format("percent%s", percent) 
            })
        end
    end)
    --Control从小到大排序
    table.sort(memberControl, function(a, b) 
        return a.percent < b.percent
    end)
    local memberGroupData = table.groupBy(data, function(clubData)
        totalCount = totalCount + 1
        clubData.memberPercent = (clubData.curNum / clubData.totalNum) * 100
        for i = 1, #memberControl do
            if clubData.memberPercent <= memberControl[i].percent then
                return memberControl[i].key
            end
        end
        return memberControl[#memberControl].key
    end)

    while totalCount > 0 do
        local icon = {}
        --for i = 1, #memberControl do
        for i = #memberControl, 1, -1 do
            local key = memberControl[i].key
            local temp, tempKey = table.find(memberGroupData[key], function(k, v)
                return not fun.is_include(v.icon, icon)
            end)
            if temp then
                memberGroupData[key][tempKey] = nil
                table.insert(ret, temp)
                table.insert(icon, temp.icon)
                totalCount = totalCount - 1
            end
        end
    end

    table.insert(ret, 1, private.recommendClub)
    private.defaultSortData = DeepCopy(ret)
    return ret
end

---推荐公会
function private.GetRecommendClub(data)
    local temp = {}

    local playerLevel = ModelList.PlayerInfoModel:GetLevel()
    local controlCfg = Csv.GetData("control", 165, "content")
    local recommendPercent = controlCfg and controlCfg[1][1] or 100
    table.each(data, function(v, k)
        v.memberPercent = ((v.curNum or 0) / (v.totalNum or 100)) * 100
        if v.memberPercent > recommendPercent or v.memberPercent == 100 then
            return
        end

        local levelLimit = v.clubLimit.levelLimit
        if playerLevel < levelLimit then
            return
        end

        v.key = k
        table.insert(temp, v)
    end)

    table.sort(temp, function(a, b)
        local memberA, memberB = a.curNum or 0, b.curNum or 0
        return memberA > memberB
    end)

    temp[1].isRecommend = true
    return temp[1]
end

function private.InitInfiniteList(self)
    local options = {
        tempItemCtrl = self.club_item.transform,
        scrollView = self.scrollView,
        luabehaviour = self.luabehaviour,
        itemView = ClubInfoItemView,
        
        spacing = 11.3,
        paddingTop = 15,
        paddingBottom = 40,
    }
    private.InfiniteList = InfiniteList:New(options)
end

function private.UpdateInfiniteList()
    if private.InfiniteList then
        private.InfiniteList:UpdateListByData(private.clubsData)
    end
end

function private.InitSearchText(self)
    self.search_input.characterLimit = 15
    
    self.search_input.onValueChanged:AddListener(function(val)
        private.ShowSearchResult(self, val)
    end)
end

---根据名字进行模糊搜索
function private.SearchClubByName(nameStr)
    local data = DeepCopy(private.defaultSortData)
    local ret = {}

    nameStr = string.lower(nameStr)
    table.each(data, function(clubData)
        local clubName = clubData.name
        clubName = string.lower(clubName)
        local find = string.find(clubName, nameStr)
        if find then
            clubData.sortOrder = 1
            table.insert(ret, clubData)
        --else
        --    --模糊匹配
        --    local charList, pattern = string.toCharTable(nameStr)
        --    table.each(charList, function(char)
        --        if not pattern then
        --            pattern = charList[1]
        --        else
        --            pattern = pattern .. ".*" .. char
        --        end
        --    end)
        --    if pattern then
        --        find = string.match(clubName, pattern)
        --        if find then
        --            clubData.sortOrder = 2
        --            table.insert(ret, clubData)
        --        end
        --    end
        end
    end)

    table.sort(ret, function(a, b)
        if a.isRecommend then return true end
        if b.isRecommend then return false end
        return a.sortOrder < b.sortOrder
    end)
    return ret
end

---根据ID进行模糊搜索
function private.SearchClubByID(idStr)
    local data = DeepCopy(private.defaultSortData)
    data = DeepCopy(data)
    local ret = {}

    table.each(data, function(clubData)
        local clubID = tostring(clubData.clubId)
        local find = string.find(clubID, idStr)
        if find then
            clubData.sortOrder = 1
            table.insert(ret, clubData)
        --else
        --    --模糊匹配
        --    local charList, pattern = string.toCharTable(idStr)
        --    table.each(charList, function(char)
        --        if not pattern then
        --            pattern = charList[1]
        --        else
        --            pattern = pattern .. ".*" .. char
        --        end
        --    end)
        --    if pattern then
        --        find = string.match(clubID, pattern)
        --        if find then
        --            clubData.sortOrder = 2
        --            table.insert(ret, clubData)
        --        end
        --    end
        end
    end)

    table.sort(ret, function(a, b)
        if a.isRecommend then return true end
        if b.isRecommend then return false end
        return a.sortOrder < b.sortOrder
    end)
    return ret
end

function private.ShowSearchResult(self, searchText)
    if string.is_empty(searchText) then
        private.clubsData = private.defaultSortData
        private.UpdateInfiniteList()
        return 
    end
    
    local fistCharByte = string.byte(string.sub(searchText, 1))
    local firstIsNumber = fistCharByte >= 48 and fistCharByte <= 57
    local searchResult
    if firstIsNumber then
        searchResult = private.SearchClubByID(searchText)
    else
        searchResult = private.SearchClubByName(searchText)
    end
    private.clubsData = searchResult
    
    private.UpdateInfiniteList()
end

function private.SortByName(isDescending)
    table.sort(private.clubsData, function(a, b)
        if a.isRecommend then return not isDescending end
        if b.isRecommend then return isDescending end
        
        --逐个字符比较
        local charListA, charListB = string.toCharTable(a.name), string.toCharTable(b.name)
        for i = 1, #charListA do
            if charListB[i] == nil then return false end
            local charA, charB = string.lower(charListA[i]), string.lower(charListB[i])
            local charByteA, charByteB = string.byte(charA), string.byte(charB)
            if charByteA ~= charByteB then
                return charByteA < charByteB
            end
        end

        if #charListA < #charListB then
            return false
        end
        
        return a.clubId < b.clubId
    end)

    if isDescending then
        table.reverse(private.clubsData)
    end
end

return this 

