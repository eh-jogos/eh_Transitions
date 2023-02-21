extends CanvasLayer

## This is a Class to Handle Transitions of any kind. 
##
## It uses a custom resource called eh_TransitionData and a tansition shader, to make it 
## easy to add new kinds of Transitions. The plugins sets this scene as an autoload so you can use 
## it anywhere, but if you prefer you can remove the autoload and add this scene to each scene 
## that has a transition.
##
## To use it, create a eh_TransitionData with your settings and save it to disk, then drag it to the
## transition_data variable in the editor, or set it by code from somewhere else. 
##
## To preview it, run the scene with F6 and press up to see the transition, and down to see
## the standard fade transition. 
##
## Then whenever you need to call the transition, just call any of the public methods, 
## play_transition_in will only play the first half, play_transition_out will only play the second
## half, and play_transition_full will play it all in sequence. 
##
## If you just want a simple fade in and fade out transition, than you don't need to set any
## custom transition data, and can just use the play_fade_in, play_fade_out and play_fade_transition
## methods.
## 
## Being able to play each half  separately might help to wait a bit if things havent finished
## loading, or it you need to set things up in the scene.
## The signals are also there to help if you need to know of any of these moments.

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

signal transition_started
signal transition_mid_point_reached
signal transition_finished

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

@export var transition_data : eh_TransitionData = null: set=_set_transition_data
@export var should_block_all_input: = true

var is_on_mid_point: = false 

#--- private variables - order: export > normal var > onready -------------------------------------

@onready var _color_panel: ColorRect = $Transitions
@onready var _animator: AnimationPlayer = $Transitions/AnimationPlayer
@onready var _shader: ShaderMaterial = _color_panel.material
@onready var _mask: TextureRect = $ResolutionFixedMask/MaskViewport/MaskTexture

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	set_process_input(false)
	set_process_unhandled_input(false)
	
	if get_tree().current_scene == self:
		print(get_tree().current_scene.name)
		set_process_unhandled_input(true)


func _input(event: InputEvent) -> void:
	if should_block_all_input:
		get_viewport().set_input_as_handled()


func _unhandled_input(event):
	if event.is_action_released("ui_up"):
		play_transition_full()
	elif event.is_action_released("ui_down"):
		play_fade_transition()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func play_transition_in(p_transition_data: eh_TransitionData = null) -> void:
	if p_transition_data != null:
		_change_transition_data_oneshot(p_transition_data)
	
	var animation := transition_data.get_transition_in_animation_name()
	_play_in_animation(animation, transition_data.color, transition_data.duration)


func play_transition_out(p_transition_data: eh_TransitionData = null) -> void:
	if p_transition_data != null:
		_change_transition_data_oneshot(p_transition_data)
	
	var animation := transition_data.get_transition_out_animation_name()
	_play_out_animation(animation, transition_data.color, transition_data.duration)


func play_transition_full(p_transition_data: eh_TransitionData = null) -> void:
	if p_transition_data != null:
		_change_transition_data_oneshot(p_transition_data)
	
	play_transition_in()
	
	await transition_mid_point_reached
	
	play_transition_out()


func play_fade_in(color: Color = Color.BLACK, duration: float = 0.5) -> void:
	_play_in_animation("fade_in", color, duration)


func play_fade_out(color: Color = Color.BLACK, duration: float = 0.5) -> void:
	_play_out_animation("fade_out", color, duration)


func play_fade_transition(color: Color = Color.BLACK, duration: float = 0.5) -> void:
	play_fade_in(color, duration)
	
	await transition_mid_point_reached
	
	play_fade_out(color, duration)


func cut_to_color(color := Color.BLACK) -> void:
	_color_panel.color = color
	_animator.play("cut_to_color")
	await _animator.animation_finished


func cut_from_color() -> void:
	_animator.play("cut_from_color")
	await _animator.animation_finished


func is_transitioning_in() -> bool:
	var is_fade_in = (
			_animator.assigned_animation == "fade_in"
			or _animator.assigned_animation == "reversed_in"
			or _animator.assigned_animation == "transition_in"
	)
	return _animator.is_playing() and is_fade_in


func is_transitioning_out() -> bool:
	var is_fade_out = (
			_animator.assigned_animation == "fade_out"
			or _animator.assigned_animation == "reversed_out"
			or _animator.assigned_animation == "transition_out"
	)
	return _animator.is_playing() and is_fade_out


func is_on_any_point_of_transition() -> bool:
	return (
		is_on_mid_point
		or is_transitioning_in()
		or is_transitioning_out()
	)


func transition_to_path(p_path: String, p_transition_data: eh_TransitionData = null) -> void:
	if p_transition_data != null:
		_change_transition_data_oneshot(p_transition_data)
	
	eh_Transitions.play_transition_in()
	await eh_Transitions.transition_mid_point_reached
	
	_load_scene_from_path(p_path)
	
	eh_Transitions.play_transition_out()


func transition_to_packed(
		packed_scene: PackedScene, p_transition_data: eh_TransitionData = null
) -> void:
	if p_transition_data != null:
		_change_transition_data_oneshot(p_transition_data)
	
	eh_Transitions.play_transition_in()
	await eh_Transitions.transition_mid_point_reached
	
	get_tree().change_scene_to_packed(packed_scene)
	
	eh_Transitions.play_transition_out()


### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _change_transition_data_oneshot(data: eh_TransitionData) -> void:
	if data == transition_data:
		return
	
	var backup_transition: eh_TransitionData = transition_data
	transition_data = data
	await transition_finished
	transition_data = backup_transition


func _play_in_animation(animation: String, color: Color, duration: float) -> void:
	if _animator.is_playing() and not _animator.assigned_animation == "RESET":
		_raise_multiple_transition_error()
		return
	
	set_process_input(true)
	is_on_mid_point = false
	transition_started.emit()
	
	_color_panel.color = color
	var custom_speed := 1.0 / duration
	_animator.play(animation, -1, custom_speed)
	
	await _animator.animation_finished
	is_on_mid_point = true
	transition_mid_point_reached.emit()


func _play_out_animation(animation: String, color: Color, duration: float) -> void:
	if _animator.is_playing():
		_raise_multiple_transition_error()
		return
	
	is_on_mid_point = false
	
	_color_panel.color = color
	var custom_speed := 1.0 / duration
	_animator.play(animation, -1, custom_speed)
	
	await _animator.animation_finished
	set_process_input(false)
	transition_finished.emit()


func _load_scene_from_path(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _set_transition_data(data : eh_TransitionData) -> void:
	transition_data = data
	
	if not is_inside_tree():
		await ready
	
	if _shader != null and transition_data != null:
		_shader.set_shader_parameter("smooth_size", transition_data.smooth_size)
		_mask.texture = data.mask


func _raise_multiple_transition_error() -> void:
	# If you're in Debug or this is intended, press F12 or the continue 
	# button in the debugger to continue
	assert(false, "A new transition is being called while another one is playing")

### -----------------------------------------------------------------------------------------------
