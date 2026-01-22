extends Sprite
	
	
func merge() -> void:
	var img = generate_image(	get_sprites_based_size($sprites), \
					Color(0,0,0,0), "res://assets/scrap/bg.png")
#	var img = self.texture.get_data()
	for sp in $sprites.get_children():
		var sprite: Sprite = sp
		var sqr = sprite.texture.get_data()
		var new_size = sqr.get_size() * sprite.scale
		sqr.resize(new_size.x, new_size.y, Image.INTERPOLATE_NEAREST)
		img.blend_rect(sqr, Rect2(Vector2(0,0), sqr.get_size()), \
			sp.position - Vector2(sqr.get_width()/2,sqr.get_height()/2))
	$sprites.hide()
	var texture = ImageTexture.new() 
	texture.create_from_image(img)
	ResourceSaver.save("res://map_saves/map1.tres", texture)
	texture = load("res://map_saves/map1.tres")
	set_texture(texture)
	print("merge succesful")
	return

func generate_image(size:Vector2, color:Color, fn:String) -> Image:
	var img = Image.new()
	img.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(color)
	img.save_png(fn)
	return img


func get_sprites_based_size(sprites:Node2D) -> Vector2:
	var size: Vector2 = Vector2.ZERO
	for sp in sprites.get_children(): # по позиции х
		var img_width = sp.texture.get_data().get_width() * sp.scale.x
		if sp.position.x + img_width/2 > size.x:
			size.x = sp.position.x + img_width/2
	for sp in sprites.get_children(): # по позиции y
		var img_height = sp.texture.get_data().get_height() * sp.scale.y
		if sp.position.y + img_height/2 > size.y:
			size.y = sp.position.y + img_height/2
	return size
