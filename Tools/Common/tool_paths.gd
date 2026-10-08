extends RefCounted
## Shared development-tool paths. Never depend on a Codex session directory.

static func project_dir() -> String:
	return ProjectSettings.globalize_path("res://").trim_suffix("/")

static func project(relative: String) -> String:
	return project_dir().path_join(relative)

static func option(name: String, fallback: String = "") -> String:
	var args := OS.get_cmdline_user_args()
	for index in range(args.size()):
		if args[index].begins_with(name + "="):
			return args[index].substr(name.length() + 1)
		if args[index] == name and index + 1 < args.size():
			return args[index + 1]
	return fallback

static func setting(key: String, environment: String) -> String:
	var value := OS.get_environment(environment)
	if not value.is_empty():
		return value
	var config_path := project("tool-settings.local.json")
	if FileAccess.file_exists(config_path):
		var config = JSON.parse_string(FileAccess.get_file_as_string(config_path))
		if config is Dictionary:
			return str(config.get(key, ""))
	return ""

static func game_pack() -> String:
	var explicit_path := option("--game-pack")
	if not explicit_path.is_empty():
		return explicit_path
	var directory := option("--game-dir", setting("GameDir", "STS2_GAME_DIR"))
	if directory.is_empty():
		push_error("Provide --game-dir, STS2_GAME_DIR or tool-settings.local.json GameDir")
		return ""
	return directory.path_join("SlayTheSpire2.pck")

static func mod_pack() -> String:
	var explicit_path := option("--mod-pack", setting("ModPack", "SRW_MOD_PACK"))
	if not explicit_path.is_empty():
		return explicit_path
	return game_pack().get_base_dir().path_join("mods/SpiritualRealmWalker/SpiritualRealmWalker.pck")

static func cache_dir(relative: String = "") -> String:
	var directory := option("--cache-dir", project(".godot/tool-output"))
	if not relative.is_empty():
		directory = directory.path_join(relative)
	DirAccess.make_dir_recursive_absolute(directory)
	return directory

static func output_dir(fallback: String) -> String:
	var directory := option("--output-dir", fallback)
	DirAccess.make_dir_recursive_absolute(directory)
	return directory
