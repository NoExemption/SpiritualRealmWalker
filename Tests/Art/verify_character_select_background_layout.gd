extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if OS.get_cmdline_user_args().has("--deployed"):
		if not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
			quit(1)
			return
	_run.call_deferred()

func _run() -> void:
	var scene = load("res://SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_bg.tscn") as PackedScene
	if scene == null:
		_fail("Background scene could not be loaded")
		return
	var screen = Control.new()
	screen.name = "CharacterSelectScreen"
	screen.position = Vector2(37, 29)
	root.add_child(screen)
	var animated = Control.new()
	animated.name = "AnimatedBg"
	screen.add_child(animated)
	animated.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	animated.offset_left = -388
	animated.offset_top = -80
	animated.offset_right = 252
	animated.offset_bottom = 40
	animated.pivot_offset = Vector2(1280, 600)
	animated.scale = Vector2.ONE * 1.1
	var background = scene.instantiate() as Control
	# Match RitsuLib's layout initialization before the scene enters the tree.
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	animated.add_child(background)
	var checked = 0
	for item in [
		[Vector2(1920, 1200), 1.0, 1.1],
		[Vector2(1920, 1080), 1.3333333, 1.1],
		[Vector2(1440, 1080), 0.8, 1.2683],
		[Vector2(2560, 1080), 1.0, 1.1],
		[Vector2(1920, 1200), 1.3333333, 1.115]
	]:
		screen.size = item[0]
		screen.scale = Vector2.ONE * item[1]
		animated.scale = Vector2.ONE * item[2]
		await process_frame
		await process_frame
		var expected = screen.get_global_rect()
		var actual = background.get_global_rect()
		var art = background.get_node("Illustration") as TextureRect
		if not actual.position.is_equal_approx(expected.position) or not actual.size.is_equal_approx(expected.size):
			_fail("Background does not fit actual screen: " + str(actual) + " expected " + str(expected))
			return
		if background.is_set_as_top_level() or art.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
			_fail("Background drawing order or full-image fit is incorrect")
			return
		if not art.size.is_equal_approx(screen.size):
			_fail("Illustration bounds do not match the screen")
			return
		var fit = minf(art.size.x / 3840.0, art.size.y / 2400.0)
		var displayed = Vector2(3840, 2400) * fit
		if displayed.x > art.size.x + 0.01 or displayed.y > art.size.y + 0.01:
			_fail("Illustration would be cropped")
			return
		checked += 1
		print("LAYOUT_CHECK size=", screen.size, " ui_scale=", item[1], " native_bg_scale=", item[2], " actual=", actual, " whole_image=true")
	# Switching to another character removes only this private scene; the shared
	# AnimatedBg keeps its original offsets/pivot and current native window scale.
	background.free()
	if animated.offset_left != -388 or animated.offset_top != -80 or animated.offset_right != 252 or animated.offset_bottom != 40 or animated.pivot_offset != Vector2(1280, 600):
		_fail("Shared native background layout was modified")
		return
	print("LAYOUT_CHECK cases=", checked, " shared_native_layout_unchanged=true")
	screen.free()
	quit(0)

func _fail(message: String) -> void:
	push_error(message)
	quit(1)
