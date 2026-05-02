extends Node
class_name Dolt

@export var displayName: String
@export var position:Vector2
@export var sprite: Texture2D
@export var canWalkThroughBlocks: bool
@export var flying:bool
@export var maxHealth:int
@export var health:int
@export var canTakeItems: bool #in kg
@export var items: Array[Item]
@export var priorityExhausted: bool
@export var strength: int


var isPlayer: bool
var occupiedGridNode: GridNode

	
func MoveTo(x:int, y:int)->bool:
	var gridNode = Global.gridManager.GetNodeAt(x,y)
	if gridNode == null:
		#push_error()
		return false
	if gridNode.dolt != null:
		#push_error()
		return false
	if occupiedGridNode != null:
		occupiedGridNode.dolt = null
	occupiedGridNode = gridNode
	position = Vector2(x,y)
	gridNode.dolt = self
	return true

func GetSprite()->Texture2D:
	return sprite
	pass

func ReceivePriority():
	CheckNode()
	pass
	
func ExhaustPriority():
	priorityExhausted = true
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

func CheckNode():
	if isPlayer:
		return
	
	if occupiedGridNode.isDangerous:
		if !flying:
			Perish()
	if occupiedGridNode.block != null && !occupiedGridNode.block.walkable:
		Perish()
	
	pass

func Perish():
	#print("perished")
	occupiedGridNode.dolt = null
	Global.doltsManager.DespawnDolt(self)
	queue_free()
	if Global.virtualViewport.IsInView(occupiedGridNode):
		Global.terminal.PrintWhite(str(displayName, " perished."))
	pass

func GetPosition()->Vector2:
	return Vector2(occupiedGridNode.xPos, occupiedGridNode.yPos)
	pass

func ApplyPhysicalDamage(amount:int):
	health = health - amount
	if health < 0:
		Perish()
	pass

func OnInitialSpawn(): #happens when dolt is a newly spawned (doesnt happen when game is loaded)
	
	pass
	
