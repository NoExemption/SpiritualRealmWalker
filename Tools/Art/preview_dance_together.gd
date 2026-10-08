extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

var PROJECT_DIR = ToolPaths.project_dir()
var view: SubViewport
var zh_font: Font
var cost_font: Font
var materials: Dictionary

func _initialize() -> void:
	call_deferred("render_preview")

func picture(parent: Node, texture: Texture2D, at: Vector2, bounds: Vector2, style: Material = null, stretch: int = TextureRect.STRETCH_SCALE) -> TextureRect:
	var rect = TextureRect.new()
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = stretch
	rect.size = bounds
	rect.position = at
	rect.material = style
	parent.add_child(rect)
	return rect

func texture_rect(parent: Node, path: String, at: Vector2, bounds: Vector2, style: Material = null, stretch: int = TextureRect.STRETCH_SCALE) -> TextureRect:
	return picture(parent, load(path), at, bounds, style, stretch)

func caption(parent: Node, wording: String, at: Vector2, bounds: Vector2, font: Font, font_size: int, ink: Color = Color("f1deb7")) -> Label:
	var label = Label.new()
	label.text = wording
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", ink)
	label.add_theme_color_override("font_outline_color", Color("101521"))
	label.add_theme_constant_override("outline_size", 2)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size = bounds
	label.position = at
	parent.add_child(label)
	return label

func render_preview() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		push_error("Could not mount native PCK")
		quit(1)
		return
	if not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		push_error("Could not mount existing mod PCK")
		quit(1)
		return
	for key in ["card_frame", "portrait_border", "banner"]:
		materials[key] = load("res://SpiritualRealmWalker/materials/three_luminaries_" + key + ".tres")
		if materials[key] == null:
			push_error("Missing material " + key)
			quit(1)
			return
	materials["common"] = load("res://materials/cards/banners/card_banner_common_mat.tres")
	zh_font = load("res://themes/fonts/zhs/noto_sans_mono_cjksc_regular_shared.tres") as Font
	cost_font = load("res://themes/kreon_bold_shared.tres") as Font
	if materials["common"] == null or zh_font == null or cost_font == null:
		push_error("Missing native common material or font")
		quit(1)
		return
	view = SubViewport.new()
	view.size = Vector2i(690, 550)
	view.transparent_bg = false
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var backdrop = ColorRect.new()
	backdrop.color = Color("080e16")
	backdrop.size = view.size
	view.add_child(backdrop)
	caption(view, "共舞 · 样稿检查（非游戏截图）", Vector2(30, 5), Vector2(630, 30), zh_font, 18)
	var forms = [
		["共舞", "dance-together.png", "若回合结束时这张牌仍在手牌中，受到5点伤害。消耗。"]
	]
	for index in forms.size():
		var form = forms[index]
		var source = Image.load_from_file(PROJECT_DIR + "/Art/Cards/dance_together/" + form[1])
		if source == null or source.is_empty():
			push_error("Cannot read form source: " + form[1])
			quit(1)
			return
		print("SOURCE_ART=", form[1], "; size=", source.get_size())
		var source_texture = ImageTexture.create_from_image(source)
		var holder = Control.new()
		holder.position = Vector2(40 + 330 * index, 48)
		view.add_child(holder)
		picture(holder, source_texture, Vector2(25,43), Vector2(250,190), null, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_frame_skill_s.tres", Vector2.ZERO, Vector2(300,422), materials["card_frame"])
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_portrait_border_skill_s.tres", Vector2(12.5,47), Vector2(275,210), materials["portrait_border"], TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		var banner = materials["banner"].duplicate() as ShaderMaterial
		banner.set_shader_parameter("rarity_color", Color("879da6"))
		banner.set_shader_parameter("rarity_strength", 0.35)
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_banner.tres", Vector2(-13,4), Vector2(327,83), banner, TextureRect.STRETCH_KEEP_ASPECT_COVERED)
		var title_label = caption(holder, form[0], Vector2(45,7), Vector2(210,54), zh_font, 26, Color("fff6e2"))
		title_label.add_theme_color_override("font_outline_color", Color("4d4b40"))
		title_label.add_theme_constant_override("outline_size", 12)
		title_label.add_theme_color_override("font_shadow_color", Color(0,0,0,48.0/255.0))
		title_label.add_theme_constant_override("shadow_offset_x", 2)
		title_label.add_theme_constant_override("shadow_offset_y", 2)
		title_label.add_theme_constant_override("shadow_outline_size", 12)
		var plaque = NinePatchRect.new()
		plaque.texture = load("res://images/ui/cards/card_portrait_border_plaque2.png")
		plaque.patch_margin_left = 13
		plaque.patch_margin_right = 12
		plaque.position = Vector2(119.5,212)
		plaque.size = Vector2(61,37)
		plaque.material = materials["common"]
		holder.add_child(plaque)
		var type_label = caption(plaque, "状态", Vector2(8.5,4.5), Vector2(44,28), zh_font, 16, Color(0,0,0,192.0/255.0))
		type_label.add_theme_constant_override("outline_size", 0)
		type_label.add_theme_color_override("font_shadow_color", Color(0,0,0,0))
		type_label.add_theme_constant_override("shadow_offset_x", 0)
		type_label.add_theme_constant_override("shadow_offset_y", 0)
		type_label.add_theme_constant_override("shadow_outline_size", 0)
		caption(holder, form[2], Vector2(28,248), Vector2(243,136), zh_font, 19)
		var cost = texture_rect(holder, "res://SpiritualRealmWalker/images/ui/energy_big.png", Vector2(-16,-16), Vector2(64,64))
		caption(cost, "1", Vector2(9,2), Vector2(46,56), cost_font, 26)
		caption(view, "300×422 框型参考 · 250×190 插图区", Vector2(40 + 330 * index, 480), Vector2(300,32), zh_font, 14, Color("97a9b6"))
		var raw_top = 75 + 250 * index
		caption(view, form[0] + " · 250×190 原图预览", Vector2(390, raw_top - 30), Vector2(250,28), zh_font, 15, Color("97a9b6"))
		picture(view, source_texture, Vector2(390, raw_top), Vector2(250,190), null, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var rendered = view.get_texture().get_image()
	var result = rendered.save_png(ToolPaths.cache_dir().path_join("dance_together_preview.png"))
	print("PREVIEW_SAVED=", result == OK, "; size=", rendered.get_size(), "; direct_image_load=true; card_frames=2; source_previews=2")
	quit(0 if result == OK else 1)
