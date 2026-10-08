extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _init() -> void:
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var packed := load("res://scenes/screens/character_select_screen.tscn") as PackedScene
	var screen := packed.instantiate()
	root.add_child(screen)
	for path in [
		"InfoPanel",
		"InfoPanel/VBoxContainer",
		"InfoPanel/VBoxContainer/DescriptionLabel",
		"InfoPanel/VBoxContainer/Relic",
		"InfoPanel/VBoxContainer/Relic/Name",
		"InfoPanel/VBoxContainer/Relic/Description"
	]:
		var node := screen.get_node(path) as Control
		print(path, " class=", node.get_class(), " pos=", node.position, " size=", node.size,
			" min=", node.custom_minimum_size, " anchors=", Vector4(node.anchor_left, node.anchor_top, node.anchor_right, node.anchor_bottom),
			" offsets=", Vector4(node.offset_left, node.offset_top, node.offset_right, node.offset_bottom),
			" flags=", Vector2i(node.size_flags_horizontal, node.size_flags_vertical))
	quit()
