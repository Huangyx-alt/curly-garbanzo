---  海盗船玩法寻路节点
local PirateShipPathNode = Clazz(ClazzBase, "PirateShipPathNode")
local this = PirateShipPathNode
local private = {}

function this:Init(cellIndex, parentNode, g, h)
    this.index = cellIndex   --格子坐标
    this.parent = parentNode --路径中的上一个node 
    this.g = g               --出发点到该节点的距离 
    this.h = h               --该节点到终点的距离
    this.f = g + h           --该节点的移动估价      
end

return this