extends Node
class_name Action

@export var actionName:String
@export var exhausting:bool
@export var hasFollowUp: bool


#DO NOT OVERRIDE! Performer is the dolt performing the action. Direction
#is usually the direction in which the action is done towards. Vector can 
#represent any vector/position. Data is set by AI if further data is needed.
#
func Perform(performer:Dolt, direction:Vector2, vector: Vector2, _data: Array[String]) -> bool:
	var data = _data
	
	#If further data needs to be queried from the player, do it in FollowUp().
	if hasFollowUp && data.size() == 0:
		data = await FollowUp()
		if data.size() ==0:
			return false
	
	#Check conditions to make sure the action can't fail.
	if !CheckConditions(performer, direction, vector, data):
		return false
	
	#Do the actual action. CANNOT FAIL.
	ActionBody(performer,direction,vector,data)
	
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
func CheckConditions(performer:Dolt, direction:Vector2, position: Vector2, data: Array[String])-> bool:
	print(str(actionName, " CheckConditions not overridden!"))
	push_error()
	return false

#OVERRIDER
func ActionBody(performer:Dolt, direction:Vector2, position: Vector2, data: Array[String]):
	print(str(actionName, " ActionBody not overridden!"))
	push_error()
	pass
	
