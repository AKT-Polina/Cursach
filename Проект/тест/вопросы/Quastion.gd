class_name Quastion


export(String) var text 
export(Array, String) var options 
export(int) var answer 














#enum {OPTIONS, INPUT}
#var type: int = 0
#var text: String 
#var image: Image 
#var content = [text, image]
#var options: Array = []
#var answer 


#func _init():
#	match typeof(type):
#		OPTIONS:
#			var answer: int = 0
#		INPUT:
#			var asnwer: String
