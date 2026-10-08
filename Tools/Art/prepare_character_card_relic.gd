extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var dir = ToolPaths.project("SpiritualRealmWalker/images/relics")
	DirAccess.make_dir_recursive_absolute(dir)
	var img = Image.load_from_file(ToolPaths.project("Art/Relics/character_card/character-card-icon.png"))
	img.convert(Image.FORMAT_RGBA8)
	var outline = Image.create(85, 85, false, Image.FORMAT_RGBA8)
	outline.fill(Color.TRANSPARENT)
	for y in range(85):
		for x in range(85):
			var alpha = 0.0
			for dy in range(-2, 3):
				for dx in range(-2, 3):
					if dx * dx + dy * dy > 5:
						continue
					var sx = x + dx
					var sy = y + dy
					if sx >= 0 and sx < 85 and sy >= 0 and sy < 85:
						alpha = maxf(alpha, img.get_pixel(sx, sy).a)
			if alpha > 0.1:
				outline.set_pixel(x, y, Color(1, 1, 1, alpha))
	if outline.save_png(dir.path_join("character_card_outline.png")) != OK:
		quit(1)
		return
	print("WHITE_ALPHA_OUTLINE size=", outline.get_size(), " used=", outline.get_used_rect())
	quit(0)
