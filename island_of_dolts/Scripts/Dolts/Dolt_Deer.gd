extends Dolt
class_name Dolt_Deer
var state:int #0 random roam, 

func ReceivePriority():
	super.ReceivePriority()
	#print("hup")
	match state:
		0:
			#print("roaming")
			Roam()
			pass
			
	pass

func Roam():
	var random = randi_range(1,20)
	
	if random < 17: #do nothing
		return
	if random == 17:
		AttemptMove(0,-1)
	if random == 18:
		AttemptMove(1,0)
	if random == 19:
		AttemptMove(0,1)
	if random == 20:
		AttemptMove(-1,0)
	pass

func OnInitialSpawn():
	#test
	#Global.itemManager.GiveItem(self,"Blue Berries", randi_range(0,10), [])
	pass
