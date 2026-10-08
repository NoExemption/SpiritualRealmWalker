extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	_run.call_deferred()

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
	var material = bg.get_node("Illustration").material as ShaderMaterial
	material.set_shader_parameter("preview_clock", true)
	var out_dir = ToolPaths.cache_dir().path_join("idle-preview-frames")
	DirAccess.make_dir_recursive_absolute(out_dir)
	for frame in range(121):
		material.set_shader_parameter("animation_time", frame / 10.0)
		await process_frame
		await RenderingServer.frame_post_draw
		var picture = root.get_texture().get_image()
		var error = picture.save_png(out_dir.path_join("frame_%03d.png" % frame))
		if error != OK:
			push_error("Preview export failed: " + str(error))
			quit(1)
			return
		if frame % 30 == 0:
			print("IDLE_PREVIEW frame=", frame, " time=", frame / 10.0, " size=", picture.get_size())
	print("IDLE_PREVIEW completed=true frames=121 cycle_seconds=12")
	quit(0)
