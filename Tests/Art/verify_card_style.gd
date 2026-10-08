extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	call_deferred("check_style")
func check_style() -> void:
	# Hidden via Start-Process; keep viewport rendering enabled.
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	ProjectSettings.load_resource_pack(ToolPaths.mod_pack())
	var frame = load("res://images/atlases/ui_atlas.sprites/card/card_frame_attack_s.tres") as Texture2D
	var material = load("res://SpiritualRealmWalker/materials/three_luminaries_card_frame.tres") as ShaderMaterial
	var border = load("res://SpiritualRealmWalker/materials/three_luminaries_portrait_border.tres") as ShaderMaterial
	if frame == null or material == null or border == null:
		quit(1)
		return
	var viewport = SubViewport.new()
	viewport.size = Vector2i(300, 422)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var rect = TextureRect.new()
	rect.texture = frame
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.size = Vector2(300, 422)
	rect.material = material
	viewport.add_child(rect)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var picture = viewport.get_texture().get_image()
	print("frame_size=", picture.get_size(), "; body_sample=", picture.get_pixel(150, 330))
	picture.save_png(ToolPaths.cache_dir().path_join("card_style_preview.png"))
	print("border_shader=", border.shader.resource_path)
	quit(0)
