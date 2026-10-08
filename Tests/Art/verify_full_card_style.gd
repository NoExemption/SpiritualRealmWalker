extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
var view: SubViewport
var zh_font: Font
var cost_font: Font
var materials: Dictionary
func _initialize() -> void:
	call_deferred("render_cards")
func texture_rect(parent: Node, path: String, at: Vector2, bounds: Vector2, style: Material = null, stretch: int = TextureRect.STRETCH_SCALE) -> TextureRect:
	var rect = TextureRect.new()
	rect.texture = load(path)
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = stretch
	rect.size = bounds
	rect.position = at
	rect.material = style
	parent.add_child(rect)
	return rect
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
func render_cards() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	ProjectSettings.load_resource_pack(ToolPaths.mod_pack())
	for key in ["card_frame", "portrait_border", "banner"]:
		materials[key] = load("res://SpiritualRealmWalker/materials/three_luminaries_" + key + ".tres")
		if materials[key] == null:
			push_error("Missing material " + key)
			quit(1)
			return
	for rarity in ["common", "uncommon", "rare"]:
		materials[rarity] = load("res://materials/cards/banners/card_banner_" + rarity + "_mat.tres")
		if materials[rarity] == null:
			push_error("Missing native material " + rarity)
			quit(1)
			return
	zh_font = load("res://themes/fonts/zhs/noto_sans_mono_cjksc_regular_shared.tres") as Font
	cost_font = load("res://themes/kreon_bold_shared.tres") as Font
	view = SubViewport.new()
	view.size = Vector2i(1360, 510)
	view.transparent_bg = false
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var backdrop = ColorRect.new()
	backdrop.color = Color("080e16")
	backdrop.size = view.size
	view.add_child(backdrop)
	var cards = [
		["天蟾香炉", "skill", "技能", "heavenly_toad_incense_burner", "1", "common", "给予所有敌人3层中毒。\n给予自己2层中毒。"],
		["嗜血之刃", "attack", "攻击", "bloodthirsty_blade", "1", "common", "造成7点无视格挡的伤害。若目标存活，给予其2层中毒；若以此伤害击杀目标，恢复3点生命。失去2点生命。"],
		["猫王音箱", "skill", "技能", "cat_king_speaker", "1", "uncommon", "选择播放鼓声或唢呐。\n消耗。"],
		["大罗星盘", "power", "能力", "", "2", "rare", "每个回合开始时，查看抽牌堆顶部3张牌。选择其中1张加入手牌，将其余牌放入弃牌堆。"]
	]
	for index in cards.size():
		var card = cards[index]
		var holder = Control.new()
		holder.position = Vector2(40 + 330 * index, 38)
		view.add_child(holder)
		if card[3] != "":
			texture_rect(holder, "res://SpiritualRealmWalker/images/cards/" + card[3] + ".png", Vector2(25,43), Vector2(250,190), null, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		else:
			var missing = ColorRect.new()
			missing.color = Color("1c2130")
			missing.position = Vector2(25,43)
			missing.size = Vector2(250,190)
			holder.add_child(missing)
			caption(holder, "现有占位插图", Vector2(25,65), Vector2(250,130), zh_font, 18, Color("788797"))
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_frame_" + card[1] + "_s.tres", Vector2.ZERO, Vector2(300,422), materials["card_frame"])
		var portrait_border = materials["portrait_border"] if index < 2 else materials[card[5]]
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_portrait_border_" + card[1] + "_s.tres", Vector2(12.5,47), Vector2(275,210), portrait_border, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
		var banner = materials[card[5]] as ShaderMaterial
		if index < 2:
			banner = materials["banner"].duplicate() as ShaderMaterial
			banner.set_shader_parameter("rarity_color", Color("879da6"))
			banner.set_shader_parameter("rarity_strength", 0.35)
		texture_rect(holder, "res://images/atlases/ui_atlas.sprites/card/card_banner.tres", Vector2(-13,4), Vector2(327,83), banner, TextureRect.STRETCH_KEEP_ASPECT_COVERED)
		var title_label = caption(holder, card[0], Vector2(45,7), Vector2(210,54), zh_font, 26, Color("fff6e2"))
		title_label.add_theme_color_override("font_outline_color", [Color("4d4b40"),Color("4d4b40"),Color("005c75"),Color("6b4b00")][index])
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
		plaque.material = materials[card[5]]
		holder.add_child(plaque)
		var type_label = caption(plaque, card[2], Vector2(8.5,4.5), Vector2(44,28), zh_font, 16, Color(0,0,0,192.0/255.0))
		type_label.add_theme_constant_override("outline_size", 0)
		type_label.add_theme_color_override("font_shadow_color", Color(0,0,0,0))
		type_label.add_theme_constant_override("shadow_offset_x", 0)
		type_label.add_theme_constant_override("shadow_offset_y", 0)
		type_label.add_theme_constant_override("shadow_outline_size", 0)
		caption(holder, card[6], Vector2(28,248), Vector2(243,136), zh_font, 20 if index != 1 else 18)
		var cost = texture_rect(holder, "res://SpiritualRealmWalker/images/ui/energy_big.png", Vector2(-16,-16), Vector2(64,64))
		caption(cost, card[4], Vector2(9,2), Vector2(46,56), cost_font, 26)
		caption(view, ["普通技能", "普通攻击／长描述", "罕见技能", "稀有能力"][index], Vector2(40 + 330*index, 470), Vector2(300,28), zh_font, 15, Color("97a9b6"))
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var picture = view.get_texture().get_image()
	picture.save_png(ToolPaths.cache_dir().path_join("three_luminaries_runtime_preview.png"))
	print("rendered=", picture.get_size(), "; custom_materials_loaded=3; native_rarity_materials_loaded=3; native_zhs_font_loaded=", zh_font != null)
	quit(0)
