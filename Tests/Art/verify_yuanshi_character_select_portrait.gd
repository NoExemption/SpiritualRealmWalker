extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize() -> void:
	var mod_pack = ToolPaths.mod_pack()
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()) or not ProjectSettings.load_resource_pack(mod_pack):
		quit(1)
		return
	var path = "res://SpiritualRealmWalker/images/character_select/yuanshi_tianzun_icon.png"
	var texture = load(path) as Texture2D
	var draft = Image.load_from_file(ToolPaths.project("Art/Characters/yuanshi_tianzun/portrait/character-select-portrait-icon.png"))
	var production = Image.load_from_file(ToolPaths.project("SpiritualRealmWalker/images/character_select/yuanshi_tianzun_icon.png"))
	var master = Image.load_from_file(ToolPaths.project("Art/Characters/yuanshi_tianzun/portrait/character-select-portrait.png"))
	if texture==null or draft==null or production==null or master==null:
		push_error("Missing finalized portrait asset")
		quit(1)
		return
	var packed = texture.get_image()
	if packed.is_compressed():
		packed.decompress()
	for image in [draft,production,packed]:
		image.convert(Image.FORMAT_RGB8)
		if image.get_size()!=Vector2i(132,195):
			push_error("Incorrect portrait size")
			quit(1)
			return
	if draft.get_data()!=production.get_data() or draft.get_data()!=packed.get_data() or master.get_size()!=Vector2i(1032,1523):
		push_error("Deployed portrait differs from finalized image")
		quit(1)
		return
	print("PORTRAIT_CHECK native=",master.get_size()," deployed=",texture.get_size()," canonical_production_pck_pixels_match=true")
	quit(0)
