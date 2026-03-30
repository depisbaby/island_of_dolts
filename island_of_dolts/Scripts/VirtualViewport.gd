extends Node
class_name VirtualViewport

@export var baseNode : TextureRect
var screen: Array[TextureRect]
var inWorldPosX:int
var inWorldPosY:int

func _enter_tree():
	Global.virtualViewport = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	for x in 9:
		for y in 9:
			var textRect:TextureRect = baseNode.duplicate()
			add_child(textRect)
			textRect.global_position = baseNode.global_position + Vector2(x* 80, y*80)
			screen.push_back(textRect)
			
	baseNode.queue_free()
	pass # Replace with function body.

func MoveTo(_x:int,_y:int):
	inWorldPosX = _x
	inWorldPosY = _y
	var i:int = 0
	for x in 9:
		for y in 9:
			var posX = inWorldPosX-4+x
			var posY = inWorldPosY-4+y
			var node = Global.gridManager.GetNodeAt(posX,posY)
			if node != null:
				screen[i].texture = node.GetSprite()
			else:
				screen[i].texture = null
			i = i+1
			
	pass

func FollowPlayer():
	inWorldPosX = Global.gameManager.player.occupiedGridNode.xPos
	inWorldPosY = Global.gameManager.player.occupiedGridNode.yPos
	var i:int = 0
	for x in 9:
		for y in 9:
			var posX = inWorldPosX-4+x
			var posY = inWorldPosY-4+y
			var node = Global.gridManager.GetNodeAt(posX,posY)
			if node != null:
				screen[i].texture = node.GetSprite()
			i = i+1
			
	pass
