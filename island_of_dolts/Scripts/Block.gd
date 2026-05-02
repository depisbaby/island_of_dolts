extends Node
class_name Block

@export var blockName: String
@export var sprite: Texture2D
@export var walkable: bool

func GetSprite()->Texture2D:
	return sprite
	
func Forage(forager:Dolt):
	pass
