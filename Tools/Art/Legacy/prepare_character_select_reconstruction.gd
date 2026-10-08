extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var directory = ToolPaths.option("--work-dir", ToolPaths.cache_dir("character-select-reconstruction"))
	DirAccess.make_dir_recursive_absolute(directory)
	var source = Image.load_from_file(ToolPaths.option("--source", ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png")))
	var cuts_x = [0, 1024, 2048, 2688, 3840]
	var cuts_y = [0, 1280, 2400]
	var tiles = []
	for row in range(2):
		for col in range(4):
			var left = maxi(0, cuts_x[col] - 32)
			var top = maxi(0, cuts_y[row] - 32)
			var right = mini(3840, cuts_x[col + 1] + 32)
			var bottom = mini(2400, cuts_y[row + 1] + 32)
			var rect = Rect2i(left, top, right - left, bottom - top)
			var name = "tile-" + str(row) + "-" + str(col)
			var path = directory + "/" + name + "-input.png"
			if source.get_region(rect).save_png(path) != OK:
				quit(1)
				return
			tiles.append({"name": name, "row": row, "col": col, "rect": [left, top, right-left, bottom-top], "path": path})
	var manifest = FileAccess.open(directory + "/manifest.json", FileAccess.WRITE)
	manifest.store_string(JSON.stringify(tiles, "\t"))
	print("RECONSTRUCTION_TILES prepared=", tiles.size(), " canvas=3840x2400 overlap=64")
	quit(0)
