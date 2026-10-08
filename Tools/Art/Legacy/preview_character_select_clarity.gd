extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

var OUTPUT = ToolPaths.cache_dir() + "/"

func _initialize() -> void:
	_render.call_deferred()

func _render() -> void:
	var art = load("res://SpiritualRealmWalker/images/character_select/yuanshi_tianzun_bg.png") as Texture2D
	var shader = load("res://SpiritualRealmWalker/shaders/character_select_clarity.gdshader") as Shader
	if art == null or shader == null:
		quit(1)
		return
	var views: Array[SubViewport] = []
	for enhanced in [false, true]:
		var view = SubViewport.new()
		view.size = Vector2i(2560, 1600)
		view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		root.add_child(view)
		var image = TextureRect.new()
		image.texture = art
		image.size = Vector2(2560, 1600)
		image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		if enhanced:
			var material = ShaderMaterial.new()
			material.shader = shader
			image.material = material
		view.add_child(image)
		views.append(view)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var before = views[0].get_texture().get_image()
	var after = views[1].get_texture().get_image()
	if before == null or after == null or before.is_empty() or after.is_empty():
		push_error("GPU preview did not render")
		quit(1)
		return
	before.convert(Image.FORMAT_RGBA8)
	after.convert(Image.FORMAT_RGBA8)
	before.save_png(OUTPUT + "character-select-clarity-before.png")
	after.save_png(OUTPUT + "character-select-clarity-after.png")
	var comparison = Image.create(640, 700, false, Image.FORMAT_RGBA8)
	comparison.fill(Color("091120"))
	# Left: previous rendering. Right: bounded luminance clarity pass.
	for i in range(2):
		var rendered = before if i == 0 else after
		comparison.blit_rect(rendered, Rect2i(1750, 300, 320, 320), Vector2i(i * 320, 0))
		comparison.blit_rect(rendered, Rect2i(1910, 920, 320, 320), Vector2i(i * 320, 370))
	if comparison.save_png(OUTPUT + "character-select-clarity-comparison.png") != OK:
		quit(1)
		return
	var changed_samples = 0
	var largest_change = 0.0
	for y in range(0, 1600, 8):
		for x in range(0, 2560, 8):
			var a = before.get_pixel(x, y)
			var b = after.get_pixel(x, y)
			var change = maxf(absf(a.r - b.r), maxf(absf(a.g - b.g), absf(a.b - b.b)))
			if change > 0.0:
				changed_samples += 1
			largest_change = maxf(largest_change, change)
	if changed_samples == 0 or largest_change > 0.04:
		push_error("Clarity preview change was missing or exceeded the bound")
		quit(1)
		return
	print("CLARITY_GPU_CHECK changed_samples=", changed_samples, " max_channel_delta=", largest_change)
	print("CLARITY_GPU_PREVIEW size=", after.get_size(), " comparison_saved=true")
	quit(0)
