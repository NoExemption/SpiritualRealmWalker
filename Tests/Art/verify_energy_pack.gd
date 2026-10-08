extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	var pack_path = ToolPaths.mod_pack()
	if not ProjectSettings.load_resource_pack(pack_path):
		push_error("Cannot mount deployed PCK")
		quit(1)
		return
	var jobs = [
		["res://SpiritualRealmWalker/images/ui/energy_big.png", Vector2i(74, 74)],
		["res://SpiritualRealmWalker/images/ui/energy_text.png", Vector2i(24, 24)]
	]
	for job in jobs:
		var texture = ResourceLoader.load(job[0]) as Texture2D
		if texture == null or texture.get_size() != Vector2(job[1]):
			push_error("Invalid packed energy texture: " + job[0])
			quit(1)
			return
		print("PACKED_TEXTURE_OK ", job[0], " ", texture.get_size())
	quit(0)
