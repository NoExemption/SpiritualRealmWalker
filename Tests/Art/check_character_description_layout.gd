extends SceneTree

const ToolPaths = preload("res://Tools/Common/tool_paths.gd")
func _initialize():
	call_deferred("check_layout")
func check_layout():
	ProjectSettings.load_resource_pack(ToolPaths.game_pack())
	var data=JSON.parse_string(FileAccess.get_file_as_string(ToolPaths.project("SpiritualRealmWalker/localization/zhs/characters.json")))
	var text=data["SPIRITUAL_REALM_WALKER_CHARACTER_YUANSHI_TIANZUN_CHARACTER.description"]
	var font=load("res://themes/fonts/zhs/noto_sans_mono_cjksc_regular_shared.tres") as Font
	var label=RichTextLabel.new()
	root.add_child(label)
	label.add_theme_font_override("normal_font",font)
	label.add_theme_font_size_override("normal_font_size",32)
	label.text=text
	var width=0.0
	for line in text.split("\n"):
		assert(not line.begins_with("　"))
		width=maxf(width,font.get_string_size(line,HORIZONTAL_ALIGNMENT_LEFT,-1,32).x)
	label.autowrap_mode=TextServer.AUTOWRAP_OFF
	label.custom_minimum_size=Vector2(ceil(width)+16,0)
	label.size=Vector2(ceil(width)+16,300)
	await process_frame
	await process_frame
	assert(label.get_line_count()==4)
	print("DESCRIPTION_LAYOUT_OK; lines=",label.get_line_count(),"; width_at_font32=",label.size.x,"; no_indent=true")
	quit(0)