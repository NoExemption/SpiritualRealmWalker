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
	if material == null or not material.shader.code.contains("vertex_tint"):
		push_error("Corrected idle shader is absent from deployed scene")
		quit(1)
		return
	art.material = null
	var still = await capture()
	art.material = material
	material.set_shader_parameter("preview_clock", true)
	material.set_shader_parameter("animation_time", 0.0)
	var start = await capture()
	material.set_shader_parameter("animation_time", 3.0)
	var moving = await capture()
	material.set_shader_parameter("animation_time", 12.0)
	var end = await capture()
	var original_colors = still.get_data() == start.get_data()
	var seamless = start.get_data() == end.get_data()
	var animates = start.get_data() != moving.get_data()
	# This check deliberately disables GDScript processing and pauses the tree.
	# There are no per-frame uniform writes: production must move by itself.
	material.set_shader_parameter("preview_clock", false)
	paused = true
	var auto_start = await capture()
	await create_timer(2.5, true, false, true).timeout
	var auto_end = await capture()
	var auto_play = auto_start.get_data() != auto_end.get_data()
	print("DEPLOYED_IDLE automatic_playback_with_processing_disabled_and_tree_paused=", auto_play)
	print("DEPLOYED_IDLE baseline_colors_equal=", original_colors, " seamless_loop=", seamless, " motion_present=", animates)
	if not original_colors or not seamless or not animates or not auto_play:
		quit(1)
	else:
		quit(0)
