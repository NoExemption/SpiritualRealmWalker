extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")

func _initialize() -> void:
	if not ProjectSettings.load_resource_pack(ToolPaths.mod_pack()):
		quit(1)
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string("res://SpiritualRealmWalker/localization/zhs/relics.json"))
	var expected = "当日月星归位，沉眠于混沌中的诸神将会醒来，高居于神座的王，带领众神重启战争，世界进入新的轮回。"
	if not data is Dictionary or data.get("SPIRITUAL_REALM_WALKER_RELIC_CHARACTER_CARD.flavor") != expected:
		push_error("Deployed flavor mismatch")
		quit(1)
		return
	print("DEPLOYED_CHARACTER_CARD_FLAVOR_MATCHES_USER_TEXT")
	quit(0)
