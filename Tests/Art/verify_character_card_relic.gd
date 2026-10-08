extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()) or not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		quit(1)
		return
	for item in [["character_card.png", 85], ["character_card_outline.png", 85], ["character_card_big.png", 256]]:
		var name: String = item[0]
		var size: int = item[1]
		var path = "res://SpiritualRealmWalker/images/relics/" + name
		var tex = load(path) as Texture2D
		var src = Image.load_from_file(ToolPaths.project("SpiritualRealmWalker/images/relics") + "/" + name)
		if name != "character_card_outline.png":
			var draft_name = "character-card-icon.png" if size == 85 else "character-card-big.png"
			var draft = Image.load_from_file(ToolPaths.project("Art/Relics/character_card") + "/" + draft_name)
			if src == null or draft == null:
				quit(1)
				return
			src.convert(Image.FORMAT_RGBA8)
			draft.convert(Image.FORMAT_RGBA8)
			if src.get_size() != draft.get_size() or src.get_data() != draft.get_data():
				push_error("Runtime source differs from black moon revision")
				quit(1)
				return
		if tex == null or src == null:
			push_error("Missing relic texture: " + path)
			quit(1)
			return
		var packed = tex.get_image()
		if packed.is_compressed():
			packed.decompress()
		src.convert(Image.FORMAT_RGBA8)
		# Match the default texture import's transparent-edge color repair.
		src.fix_alpha_edges()
		packed.convert(Image.FORMAT_RGBA8)
		var changed_visible = 0
		var changed_transparent = 0
		if packed.get_size() == src.get_size():
			for y in range(size):
				for x in range(size):
					var actual = packed.get_pixel(x, y)
					var expected = src.get_pixel(x, y)
					if actual != expected:
						if actual.a > 0 or expected.a > 0:
							changed_visible += 1
						else:
							changed_transparent += 1
		print("PIXEL_CHECK ", name, " size=", packed.get_size(), " alpha=", packed.detect_alpha(), " changed_visible=", changed_visible, " changed_zero_alpha_rgb=", changed_transparent)
		if packed.get_size() != Vector2i(size, size) or changed_visible != 0 or packed.detect_alpha() == Image.ALPHA_NONE:
			push_error("Mismatch: " + path)
			quit(1)
			return
		print("VERIFIED ", name, " size=", packed.get_size(), " transparent=true visible_rgba_pixels_match=true")
	quit(0)
