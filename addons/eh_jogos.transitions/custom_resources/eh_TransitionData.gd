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

#--- constants ------------------------------------------------------------------------------------

const BLACK_TO_WHITE = "black_to_white"
const WHITE_TO_BLACK = "white_to_black"

#--- public variables - order: export > normal var > onready --------------------------------------

export var color: Color = Color.black
export var duration: float = 0.0 setget _set_duration, _get_duration
export var mask: Texture = null
export(float, 0.0, 0.5) var smooth_size: float = 0.385
export(String, "black_to_white", "white_to_black" ) \
		var transition_in: = BLACK_TO_WHITE setget , _get_transition_in
export(String, "black_to_white", "white_to_black") \
		var transition_out: = BLACK_TO_WHITE setget , _get_transition_out

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_duration(value: float) -> void:
	duration = max(0, value)


func _get_duration() -> float:
	return duration


func _get_transition_in() -> String:
	var to_return: String = ""
	if transition_in == "black_to_white":
		to_return = "transition_in"
	elif transition_in == "white_to_black":
		to_return = "reversed_in"
	else:
		assert(false, "unindentified type os transition: %s"%[transition_in])
	
	return to_return


func _get_transition_out() -> String:
	var to_return: String = ""
	if transition_out == "black_to_white":
		to_return = "transition_out"
	elif transition_out == "white_to_black":
		to_return = "reversed_out"
	else:
		assert(false, "unindentified type os transition: %s"%[transition_out])
	
	return to_return

### -----------------------------------------------------------------------------------------------
