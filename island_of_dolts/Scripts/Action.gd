extends Object
class_name Action

@export var actionName:String
@export var exhausting:bool
@export var hasFollowUp: bool


#DO NOT OVERRIDE! Performer is the dolt performing the action. Direction
#is usually the direction in which the action is done towards. Vector can 
#represent any vector/position. Data is set by AI if further data is needed.
#
func Perform(performer:Dolt, direction:Vector2, _data: Array[String]) -> bool:
	var data = _data
	
	#If further data needs to be queried from the player, do it in FollowUp().
	if hasFollowUp && data.size() == 0:
		data = await FollowUp()
		if data.size() ==0:
			return false
	
	#Check conditions to make sure the action can't fail.
	if !CheckConditions(performer, direction, data):
		return false
	
	#Do the actual action. 
	ActionBody(performer,direction,data)
	
	#Exhaust priority if exhausting
	if exhausting:
		performer.priorityExhausted = true
		
	return true
	

#OVERRIDE
func FollowUp()-> Array[String]:
	print(str(actionName, " FollowUp not overridden!"))
	push_error()
	return []
	pass

#OVERRIDE
func CheckConditions(performer:Dolt, direction:Vector2, data: Array[String])-> bool:
	print(str(actionName, " CheckConditions not overridden!"))
	push_error()
	return false

#OVERRIDER
func ActionBody(performer:Dolt, direction:Vector2, data: Array[String]):
	
	print(str(actionName, " ActionBody not overridden!"))
	push_error()
	pass
	
func RequireDirection(performer:Dolt,direction:Vector2)-> bool:
	if direction == Vector2(0,0):#NEEDS A DIRECTION
		if performer == Global.gameManager.player:
			Global.terminal.PrintRed(str("Provide a direction. (e.g. 'perform ", actionName," w')"))
		return false
	return true
	
func GetFirstDoltInDirection(dolt:Dolt, start:Vector2, direction:Vector2, maxRange:int, hitsBlocks:bool)->Dolt:
	
	var stepsRemaning :int= maxRange
	var position: Vector2 = start
	while(stepsRemaning>0):
		stepsRemaning = stepsRemaning-1
		position = position + direction
		var gridNode:GridNode = Global.gridManager.GetNodeAt(position.x,position.y)
		if gridNode != null:
			if hitsBlocks && gridNode.block != null && !gridNode.block.walkable: #there is a non walkable block
				return null
			
			if gridNode.dolt != null:
				return gridNode.dolt
			
	
	return null
	pass
	
