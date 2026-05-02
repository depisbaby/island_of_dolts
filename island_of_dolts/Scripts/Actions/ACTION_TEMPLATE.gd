extends Action
class_name MyAction #CHANGE THIS

func FollowUp()-> Array[String]:
	var data:Array[String]
	
	#GET THE FOLLOW UP DATA HERE
	
	return data

func CheckConditions(performer:Dolt, direction:Vector2, data: Array[String])-> bool:
	
	#CHECK THE CONDITIONS HERE
	
	return true

func ActionBody(performer:Dolt, direction:Vector2, data: Array[String]):
	
	#DO THE ACTUAL ACTION HERE
	
	pass
	
