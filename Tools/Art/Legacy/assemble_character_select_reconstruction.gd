extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var directory = ToolPaths.option("--work-dir", ToolPaths.cache_dir("character-select-reconstruction"))
	var manifest = JSON.parse_string(FileAccess.get_file_as_string(directory + "/manifest.json"))
	var canvas = Image.create(3840, 2400, false, Image.FORMAT_RGB8)
	var cuts_x = [0, 1024, 2048, 2688, 3840]
	var cuts_y = [0, 1280, 2400]
	var rows = [Image.create(3840, 1312, false, Image.FORMAT_RGB8), Image.create(3840, 1152, false, Image.FORMAT_RGB8)]
	var report = []
	for item in manifest:
		var tile = Image.load_from_file(directory + "/" + item.name + "-generated.png")
		if tile == null or tile.is_empty():
			push_error("Missing tile " + item.name)
			quit(1)
			return
		var native_size = tile.get_size()
		var rect = item.rect
		var w = int(rect[2])
		var h = int(rect[3])
		tile.resize(w, h, Image.INTERPOLATE_LANCZOS)
		var row = int(item.row)
		var col = int(item.col)
		for y in range(h):
			var gy = int(rect[1]) + y
			for x in range(w):
				var gx = int(rect[0]) + x
				var wx = 1.0 if col == 0 else smoothstep(cuts_x[col] - 32.0, cuts_x[col] + 32.0, float(gx))
				rows[row].set_pixel(gx, y, rows[row].get_pixel(gx, y).lerp(tile.get_pixel(x, y), wx))
		report.append({"name": item.name, "native_size": [native_size.x, native_size.y], "target_size": [w,h]})
		print("ASSEMBLED ", item.name, " native=", native_size, " target=", w, "x", h)
	canvas.blit_rect(rows[0], Rect2i(0,0,3840,1312), Vector2i.ZERO)
	for y in range(1152):
		var gy = 1248 + y
		var wy = smoothstep(cuts_y[1] - 32.0, cuts_y[1] + 32.0, float(gy))
		if gy >= 1312:
			canvas.blit_rect(rows[1], Rect2i(0,y,3840,1152-y), Vector2i(0,gy))
			break
		for x in range(3840):
			canvas.set_pixel(x, gy, canvas.get_pixel(x, gy).lerp(rows[1].get_pixel(x,y),wy))
	var output = ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-reconstructed-3840x2400.png")
	var error = canvas.save_png(output)
	FileAccess.open(directory + "/assembly-report.json", FileAccess.WRITE).store_string(JSON.stringify(report,"\t"))
	canvas.get_region(Rect2i(2656,340,850,650)).save_png(directory + "/face-detail.png")
	canvas.get_region(Rect2i(1948,1150,1200,260)).save_png(directory + "/robe-seam-detail.png")
	canvas.get_region(Rect2i(3020,1650,450,500)).save_png(directory + "/feet-detail.png")
	print("OUTPUT ", output, " size=", canvas.get_size(), " error=", error)
	quit(0 if error == OK else 1)
