extends Node
class_name Dolt

@export var sprite: Texture2D
@export var canWalkThroughBlocks: bool
@export var flying:bool

var isPlayer: bool
var occupiedGridNode: GridNode
var priorityExhausted: bool

	
func MoveTo(x:int, y:int):
	if occupiedGridNode != null:
		occupiedGridNode.dolt = null
	var gridNode = Global.gridManager.GetNodeAt(x,y)
	if gridNode == null:
		push_error()
	if gridNode.dolt != null:
		push_error()
	occupiedGridNode = gridNode
	gridNode.dolt = self
	pass

func GetSprite()->Texture2D:
	return sprite
	pass

func AiReceivePriority():
	pass

func AttemptMove(x:int,y:int):
	var node = Global.gridManager.GetNodeAt(occupiedGridNode.xPos+x, occupiedGridNode.yPos+y)
	if node == null:#outside of map
		return
	if node.isDangerous:
		if !flying:
			return
	if node.dolt != null:#there is a dolt
		return
	if node.block != null: #there is a block
		if node.block.walkable != null:#not walkable
			if !canWalkThroughBlocks: #cant move through blocks
				return
	MoveTo(node.xPos, node.yPos)
	
