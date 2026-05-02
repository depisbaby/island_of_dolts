extends Action
class_name Action_Swing #CHANGE THIS

func FollowUp()-> Array[String]:
	var data:Array[String]
	
	#GET THE FOLLOW UP DATA HERE
	
	return data

func CheckConditions(performer:Dolt, direction:Vector2, data: Array[String])-> bool:
	
	
	if !RequireDirection(performer, direction):
		return false
	
	
	
	#CHECK THE CONDITIONS HERE
	
	return true

func ActionBody(performer:Dolt, direction:Vector2, data: Array[String]):
	
	#DO THE ACTUAL ACTION HERE
	var dolt:Dolt = GetFirstDoltInDirection(performer,performer.GetPosition(),direction,1,false)
	if dolt != null:
		var damage:int = 20
		dolt.ApplyPhysicalDamage(damage)
		Global.terminal.PrintWhite(str(performer.displayName, "'s swing hit ", dolt.displayName, " dealing them ", damage, " damage."))
		
	pass
	
