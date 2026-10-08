extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.game_pack()):
		quit(1)
		return
	walk("res://images/atlases/card_atlas.sprites")
	quit(0)

func walk(folder: String) -> void:
	var directory = DirAccess.open(folder)
	if directory == null:
		return
	for filename in directory.get_files():
		if filename.ends_with(".tres") and (filename.contains("defend") or filename.contains("shrug") or filename.contains("impervious") or filename.contains("parry")):
			var path = folder.path_join(filename)
			var texture = load(path) as Texture2D
			if texture != null:
				var output = ToolPaths.cache_dir().path_join("native_") + filename.get_basename() + ".png"
				var picture: Image
				if texture is AtlasTexture:
					var atlas_picture = texture.atlas.get_image()
					if atlas_picture.is_compressed():
						atlas_picture.decompress()
					picture = atlas_picture.get_region(texture.region)
				else:
					picture = texture.get_image()
					if picture.is_compressed():
						picture.decompress()
				if picture.save_png(output) != OK:
					push_error("Cannot save native art reference")
					quit(1)
					return
				print("NATIVE_ART ", path, " => ", output, " ", picture.get_size())
	for child in directory.get_directories():
		walk(folder.path_join(child))
