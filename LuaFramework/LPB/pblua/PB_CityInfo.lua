-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ResourceInfo.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_PuzzleState.proto",

 PB_CityInfo  =  {
    cityId  =  1,-- int32 cityId , --城市Id
    resourceInfo  =  2,--	repeated PB_ResourceInfo ,--区分城市资源
    itemInfo  =  3,-- repeated PB_ItemInfo ,--区分城市物品
    cityRecipe  =  4,-- int32 cityRecipe ,--区分城市-菜品进度
    cityLevel  =  5,--	int32 cityLevel ,--区分城市-等级
    cityLevelExp  =  6,--	int32 cityLevelExp ,--区分城市-等级经验
    puzzleState  =  7,--	PB_PuzzleState puzzleState ,--区分城市-等级经验
}
