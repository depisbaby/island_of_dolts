extends Node
class_name Item

@export var itemName: String
@export var amount: int
@export var weightPerItem: float #in kg
@export var data: Array[String]
@export var itemSprite: Texture2D
@export var rarity: int #0=common, 1=uncommon, 3=rare, 4=exceptional, 5=unique
