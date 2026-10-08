extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()) or not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		quit(1)
		return
	var resource_path = "res://SpiritualRealmWalker/images/character_select/yuanshi_tianzun_bg.png"
	var tex = load(resource_path) as Texture2D
	var source = Image.load_from_file(ToolPaths.project("SpiritualRealmWalker/images/character_select/yuanshi_tianzun_bg.png"))
	var draft = Image.load_from_file(ToolPaths.project("Art/Characters/yuanshi_tianzun/character_select_background/character-select-background.png"))
	if tex == null or source == null or draft == null:
		push_error("Background texture is missing")
		quit(1)
		return
	var packed = tex.get_image()
	if packed.is_compressed():
		packed.decompress()
	packed.convert(Image.FORMAT_RGB8)
	source.convert(Image.FORMAT_RGB8)
	draft.convert(Image.FORMAT_RGB8)
	if packed.get_size() != Vector2i(3840, 2400) or packed.get_size() != source.get_size() or source.get_size() != draft.get_size():
		push_error("Background dimensions are incorrect")
		quit(1)
		return
	if packed.get_data() != source.get_data() or source.get_data() != draft.get_data():
		push_error("Deployed background pixels differ from selected illustration")
		quit(1)
		return
	print("BACKGROUND_CHECK resource=", resource_path, " size=", tex.get_size(), " reconstructed_hands_fixed_pixels_match=true")
	quit(0)
