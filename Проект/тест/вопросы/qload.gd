extends Control
var file_data = {
	"quastion":{
		"problem" : "" ,
		"options" : "" ,
		"answer" : ""
	}
}
var quastion_arr = [file_data, file_data]

func _ready():
	pass

func savejson():
	var q = Quastion.new()
	var content = $Panel/RichTextLabel.bbcode_text
	var saveFile = File.new()
	saveFile.open("res://вопросы/quastion.json", File.WRITE)
	
	q.text = content
	file_data["quastion"]["problem"] = content
	file_data["quastion"]["options"] = ["string1","string2","string3","string4"]
	file_data["quastion"]["answer"] = 1 
	
	
	print(JSON.print(file_data, "\t"))
	saveFile.store_string(JSON.print(quastion_arr, "\t"))
	saveFile.close()
