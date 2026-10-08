extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var folder = ToolPaths.option("--input-dir", ToolPaths.project("Art/Relics/character_card"))
	var original = Image.load_from_file(folder.path_join("character-card-source.png"))
	var edited = Image.load_from_file(folder.path_join("character-card-black-moon-generated.png"))
	if original == null or edited == null or original.get_size() != edited.get_size():
		push_error("Edit framing differs from original")
		quit(1)
		return
	original.convert(Image.FORMAT_RGBA8)
	edited.convert(Image.FORMAT_RGBA8)
	var result = original.duplicate()
	var center = Vector2(640, 622)
	var boundaries = PackedFloat32Array()
	# Locate the original silver circle, then keep the edit safely inside it.
	for degree in range(360):
		var dir = Vector2.from_angle(deg_to_rad(degree))
		var brightest = -1.0
		var boundary = 235.0
		for radius in range(220, 266):
			var p = Vector2i((center + dir * radius).round())
			var c = original.get_pixelv(p)
			var brightness = minf(c.r, minf(c.g, c.b))
			if brightness > brightest:
				brightest = brightness
				boundary = radius
		boundaries.append(boundary - 6.0)
	var changed_inside = 0
	var changed_outside = 0
	var before_total = 0.0
	var after_total = 0.0
	var sample_count = 0
	for y in range(original.get_height()):
		for x in range(original.get_width()):
			var offset = Vector2(x, y) - center
			var degree = posmod(int(round(rad_to_deg(offset.angle()))), 360)
			var distance = offset.length()
			var limit = boundaries[degree]
			if distance < limit:
				var weight = clampf((limit - distance) / 3.0, 0.0, 1.0)
				result.set_pixel(x, y, original.get_pixel(x, y).lerp(edited.get_pixel(x, y), weight))
				if result.get_pixel(x, y) != original.get_pixel(x, y):
					changed_inside += 1
			elif result.get_pixel(x, y) != original.get_pixel(x, y):
				changed_outside += 1
			if distance < 210:
				var before = original.get_pixel(x, y)
				var after = result.get_pixel(x, y)
				before_total += (before.r + before.g + before.b) / 3.0
				after_total += (after.r + after.g + after.b) / 3.0
				sample_count += 1
	if changed_inside == 0 or changed_outside != 0:
		push_error("Moon-only invariant failed")
		quit(1)
		return
	var source_path = folder.path_join("character-card-black-moon-source.png")
	if result.save_png(source_path) != OK:
		quit(1)
		return
	print("MOON_ONLY changed_inside=", changed_inside, " changed_outside=", changed_outside, " mean_rgb_before=", before_total / sample_count * 255, " mean_rgb_after=", after_total / sample_count * 255)
	for size in [256, 85]:
		var img = result.duplicate()
		img.resize(size, size, Image.INTERPOLATE_LANCZOS)
		var path = folder.path_join("character-card-black-moon-big.png" if size == 256 else "character-card-black-moon-icon.png")
		if img.save_png(path) != OK:
			quit(1)
			return
		var check = Image.load_from_file(path)
		if check.get_size() != Vector2i(size, size) or check.detect_alpha() == Image.ALPHA_NONE:
			quit(1)
			return
		print("EXPORTED ", path, " size=", check.get_size(), " alpha=", check.detect_alpha())
	quit(0)
