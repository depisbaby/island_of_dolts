extends Node
class_name GridNode

@export var groundSprite: Texture2D

var xPos:int
var yPos:int
var dolt: Dolt
var block : Block
var isDangerous:bool

func GetSprite()->Texture2D:
	if dolt != null:
		return dolt.GetSprite()
	
	if block != null:
		return block.GetSprite()
	
	return groundSprite
	pass

func SetWater():
	groundSprite = Global.gridManager.groundSprites[1]
	isDangerous = true
	pass
