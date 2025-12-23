local SettleClimbRankedView = require("View.Bingo.SettleModule.UIView.SettleClimbRankedView")
local SettleClimbRankedAutoView = SettleClimbRankedView:New("SettleClimbRankedAutoView","ClimbRankAtlas")
local this = SettleClimbRankedAutoView;
this.auto_bind_ui_items = {
    "ClimbRankItem",
    "Content",
    "Node1",
    "Node2",
    "Node3",
    "Node4",
    "Node5",
    "Node6",
    "Node7",
    "Node8",
    "ScrollView",
    "number",
    "Coins",
    "pick_ef",
    "coinNum",
    "multipleNum1",
    "daub1",
    "Tex1",
    "Tex2",
    "multipleNum2",
    "daub2",
    "Tex3",
    "multipleNum3",
    "daub3",
    "Tex4",
    "multipleNum4",
    "daub4",
    "Tex5",
    "multipleNum5",
    "daub5",
    "Tex6",
    "multipleNum6",
    "daub6",
    "Tex7",
    "multipleNum7",
    "daub7",
    "Tex8",
    "multipleNum8",
    "daub8",
    "Num",
    "cardsAnima",
    "root_effectAnima",
    "Jackpot",
    "JackpotNum",
    "smallcoinNum",
    "SmallcoinNode",
    "Mask1",
    "Mask2",
    "Mask3",
    "Mask4",
    "Mask5",
    "Mask6",
    "Mask7",
    "Mask8",
    "view",
    -- "bigwinNum",
    -- "winNum",
    "winCoins",
    "bigwinCoins",
    "btn_speedUp",
    "Rankedwin", ---最后的rankwin 
    "RankedwinAim",  ---最后爬排名动画
    "RankedwinNum",  -- 最后爬排名的数字
}

function SettleClimbRankedAutoView:CollectCard()
    CardsList = self:GetCardsList(true)
    if fun.get_child_count(self.Node1) > 0 then
        table.insert(CardsList, fun.get_child(self.Node1, 0).gameObject)
        fun.set_active(self["Mask"..1],true)
    end
    if fun.get_child_count(self.Node2) > 0 then
        table.insert(CardsList, fun.get_child(self.Node2, 0).gameObject)
        fun.set_active(self["Mask"..2],true)
    end
    if fun.get_child_count(self.Node3) > 0 then
        table.insert(CardsList, fun.get_child(self.Node3, 0).gameObject)
        fun.set_active(self["Mask" .. 3], true)
    end
    if fun.get_child_count(self.Node4) > 0 then
        table.insert(CardsList, fun.get_child(self.Node4, 0).gameObject)
        fun.set_active(self["Mask" .. 4], true)
    end
    if fun.get_child_count(self.Node5) > 0 then
        table.insert(CardsList, fun.get_child(self.Node5, 0).gameObject)
        fun.set_active(self["Mask"..5],true)
    end
    if fun.get_child_count(self.Node6) > 0 then
        table.insert(CardsList, fun.get_child(self.Node6, 0).gameObject)
        fun.set_active(self["Mask"..6],true)
    end
    if fun.get_child_count(self.Node7) > 0 then
        table.insert(CardsList, fun.get_child(self.Node7, 0).gameObject)
        fun.set_active(self["Mask" .. 7], true)
    end
    if fun.get_child_count(self.Node8) > 0 then
        table.insert(CardsList, fun.get_child(self.Node8, 0).gameObject)
        fun.set_active(self["Mask" .. 8], true)
    end
end

function SettleClimbRankedAutoView:GetNodeList()
    return { self.Node1, self.Node2, self.Node3, self.Node4,self.Node5, self.Node6, self.Node7, self.Node8 }
end

function SettleClimbRankedAutoView:CardBgOffset()
--别删
end

return this