export type TerritoryBlockInfo = {
    Set: {[number]: Vector3}?,
    CFrame: CFrame,
    Size: Vector3,
}

export type TerritoryUtil = {
    addTerritorySection: (Part: BasePart, Pos: Vector2?) -> nil,
    getPlayersInTerritory: (Part: BasePart) -> {[number]: Player},
    getPlayerTerritory: (Player: Player) -> Part?,
    territories: {[BasePart]: TerritoryBlockInfo},
}

export type CoordinateInfo = {
    Part: BasePart,
    BlockInfo : TerritoryBlockInfo
}

export type Matrix<T> = {
    [number]: {[number]: T}
}

export type Util = {
    GetMajorityTeam: (PlayerArray: {[number]: Player}) -> Team,
    SignalCooldown: (Signal: RBXScriptSignal, Callback: (...any) -> nil, Delay: number?) -> RBXScriptConnection,
}

return nil