extends Control

var _screen: Control
var _idle_material: ShaderMaterial

func _ready() -> void:
	# AnimatedBg is deliberately larger than the screen for the native animations.
	# Keep this still illustration in the same draw order, but cancel that transform.
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	pivot_offset = Vector2.ZERO
	_screen = get_parent().get_parent() as Control
	# The shader uses the renderer's TIME; this script only maintains the layout.
	_idle_material = ($Illustration.material as ShaderMaterial).duplicate() as ShaderMaterial
	$Illustration.material = _idle_material
	_sync_layout()

func _process(_delta: float) -> void:
	_sync_layout()

func _sync_layout() -> void:
	if not is_instance_valid(_screen) or _screen.size.x <= 0 or _screen.size.y <= 0:
		return
	var background_container = get_parent() as Control
	var container_scale = background_container.get_global_transform().get_scale()
	if is_zero_approx(container_scale.x) or is_zero_approx(container_scale.y):
		return
	var screen_scale = _screen.get_global_transform().get_scale()
	var fitted_scale = screen_scale / container_scale
	if not scale.is_equal_approx(fitted_scale):
		scale = fitted_scale
	if not global_position.is_equal_approx(_screen.global_position):
		global_position = _screen.global_position
	if not size.is_equal_approx(_screen.size):
		size = _screen.size
