extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		quit(1)
		return
	_run.call_deferred()

func capture() -> Image:
	await process_frame
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()

func _run() -> void:
	root.size = Vector2i(1280, 800)
	var screen = Control.new()
	screen.size = Vector2(1280, 800)
	root.add_child(screen)
	var container = Control.new()
	screen.add_child(container)
	var scene = load("res://SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_bg.tscn") as PackedScene
	var bg = scene.instantiate() as Control
	container.add_child(bg)
	bg.set_process(false)
	bg._sync_layout()
	var art = bg.get_node("Illustration") as TextureRect
	var material = art.material as ShaderMaterial
	if material == null or not material.shader.code.contains("clean_background"):
		push_error("Ascension shader absent from deployed scene")
		quit(1)
		return
	for key in ["cloud_fill", "subject_mask"]:
		var tex = material.get_shader_parameter(key) as Texture2D
		if tex == null or tex.get_size() != Vector2(3840, 2400):
			push_error("Animation layer absent or incorrectly sized: " + key)
			quit(1)
			return
	art.material = null
	var still = await capture()
	art.material = material
	material.set_shader_parameter("motion_strength", 0.0)
	var disabled = await capture()
	var original_intact = still.get_data() == disabled.get_data()
	material.set_shader_parameter("motion_strength", 1.0)
	material.set_shader_parameter("preview_clock", true)
	material.set_shader_parameter("animation_time", 0.0)
	var start = await capture()
	material.set_shader_parameter("animation_time", 12.0)
	var end = await capture()
	var seamless = start.get_data() == end.get_data()
	material.set_shader_parameter("preview_clock", false)
	paused = true
	var auto_start = await capture()
	await create_timer(2.5, true, false, true).timeout
	var auto_end = await capture()
	var auto_play = auto_start.get_data() != auto_end.get_data()
	print("ASCENSION_CHECK original_rgb_intact=", original_intact, " seamless_loop=", seamless, " automatic_playback_with_processing_disabled_and_tree_paused=", auto_play)
	quit(0 if original_intact and seamless and auto_play else 1)
