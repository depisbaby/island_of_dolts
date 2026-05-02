extends Block
class_name Block_Tree

var forageItems: Array[String] = ["Vine","Stick"]

func Forage(forager:Dolt):
	
	Global.itemManager.GiveItem(forager,forageItems[randi_range(0,forageItems.size()-1)],1,[])
	pass
