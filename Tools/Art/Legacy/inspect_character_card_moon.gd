extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var folder = ToolPaths.option("--input-dir", ToolPaths.project("Art/Relics/character_card"))
	for name in ["character-card-source.png", "character-card-black-moon-generated.png"]:
		var img = Image.load_from_file(folder.path_join(name))
		print(name, " ", img.get_size())
		for y in [430, 500, 620, 740, 810]:
			var spans = []
			for x in range(370, 880):
				var c = img.get_pixel(x, y)
				if minf(c.r, minf(c.g, c.b)) > 0.38:
					spans.append(x)
			print("row=", y, " silver=", spans)
	quit()
