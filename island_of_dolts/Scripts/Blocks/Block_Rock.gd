extends Block
class_name Block_Rock

func Forage(forager:Dolt):
	Global.itemManager.GiveItem(forager,"Stone",1,[])
	pass
