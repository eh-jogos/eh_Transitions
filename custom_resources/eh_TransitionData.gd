# Custom Resource (similar to ScriptableObjects in Unity) created to handle transitions
#
# color: the color that will fill the screen during the transition, alpha will be ignored
# duration: how long each half of the transition will take. Ex: a duration of 0.5 will take 0.5 
#           seconds to fill the screen with a color (transition_in) and another 0.5 seconds to 
#           fade out that color.
# mask: Expects a grayscale image, that wil be used by the shader to animate the transition. 
# transition_in: The kind of in transition you want to use
# transition_out: The kind of in transition you want to use
#
# There are some basic masks in the textures folder, but you can use any mask you want as long as 
# it's a grayscale gradient in some form or another.
#
# Also there are already some basic transitions created in the transitions_data folder.
#
# For simple fade in and fade out you don't need to create a eh_TransitionData resource, you can
# just use the public methods in the eh_Transitions scene.
extends Resource
class_name eh_TransitionData

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

enum TransitionDirection {
	BLACK_TO_WHITE,
	WHITE_TO_BLACK,
}

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

@export var color: Color = Color.BLACK
@export var duration: float = 0.0: set=_set_duration
@export var mask: Texture = null
@export_range(0.0, 0.5, 0.001) var smooth_size: float = 0.385

@export var transition_in := TransitionDirection.BLACK_TO_WHITE
@export var transition_out := TransitionDirection.BLACK_TO_WHITE

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_transition_in_animation_name() -> String:
	var value := ""
	
	match transition_in:
		TransitionDirection.BLACK_TO_WHITE:
			value = "black_to_white_in"
		TransitionDirection.WHITE_TO_BLACK:
			value = "white_to_black_in"
		_:
			push_error("Unimplemented TransitionDirection: %s"%[
					TransitionDirection.keys()[transition_in]
			])
	
	return value


func get_transition_out_animation_name() -> String:
	var value := ""
	
	match transition_out:
		TransitionDirection.BLACK_TO_WHITE:
			value = "black_to_white_out"
		TransitionDirection.WHITE_TO_BLACK:
			value = "white_to_black_out"
		_:
			push_error("Unimplemented TransitionDirection: %s"%[
					TransitionDirection.keys()[transition_out]
			])
	
	return value

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_duration(value: float) -> void:
	duration = max(0, value)

### -----------------------------------------------------------------------------------------------
