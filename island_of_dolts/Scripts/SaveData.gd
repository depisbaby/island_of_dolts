extends Resource
class_name SaveData

@export var saveName:String
@export var playerName:String
@export var seed: String

#Dolts
@export var aiDoltsInGame: Array[PackedScene]
@export var playerDoltInGame: PackedScene

#Items
@export var itemsInGame: Array[PackedScene]

#blockchanges
@export var blockChanges: Array[BlockChange] 
