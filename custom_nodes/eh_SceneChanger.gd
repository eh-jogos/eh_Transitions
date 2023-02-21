@tool
extends Node
class_name eh_SceneChanger

# Scene Changer custom node to be used as a helper in conjuction with eh_Transitions
#
# Just instance this node in your scene, and set the path to the next scene in the
# exported variable in the editor. Then either call `transition_to_next_scene()` from
# code, or just instance it as a child of a button and it will connect itself to the 
# `pressed` signal.
# 
# You can also optionally set a transition data to override the default one that is 
# set in eh_Transition.tscn just for this transition.

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

@export var transition_data: eh_TransitionData = null
@export var use_packed_scene := false:
	set(value):
		use_packed_scene = value
		notify_property_list_changed()

#--- private variables - order: export > normal var > onready -------------------------------------

var _next_packed_scene: PackedScene = null
var _next_scene_path: String = ""

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	var parent = get_parent()
	await parent.ready
	if parent is BaseButton:
		(parent as BaseButton).pressed.connect(transition_to_next_scene)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_next_path() -> String:
	return _next_scene_path


func transition_to_next_scene() -> void:
	if use_packed_scene:
		eh_Transitions.transition_to_packed(_next_packed_scene, transition_data)
	else:
		eh_Transitions.transition_to_path(_next_scene_path, transition_data)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------

###################################################################################################
# Custom Inspector ################################################################################
###################################################################################################

const PROP_NEXT_PACKED = &"next_packed_scene"
const PROP_NEXT_PATH = &"next_scene_path"

### Custom Inspector built in functions -----------------------------------------------------------

func _get_property_list() -> Array:
	var properties: = []
	
	if use_packed_scene:
		var dict := eh_InspectorHelper.get_prop_dict(
			PROP_NEXT_PACKED, 
			TYPE_OBJECT,
			PROPERTY_HINT_RESOURCE_TYPE,
			"PackedScene"
		)
		properties.append(dict)
	else:
		var dict := eh_InspectorHelper.get_prop_dict(
			PROP_NEXT_PATH, 
			TYPE_STRING,
			PROPERTY_HINT_FILE,
			"*.tscn"
		)
		properties.append(dict)
	
	return properties


func _get(property: StringName):
	var value
	
	match property:
		PROP_NEXT_PACKED:
			value = _next_packed_scene
		PROP_NEXT_PATH:
			value = _next_scene_path
	
	return value


func _set(property: StringName, value) -> bool:
	var has_handled: = true
	
	match property:
		PROP_NEXT_PACKED:
			_next_packed_scene = value
		PROP_NEXT_PATH:
			_next_scene_path = value
		_:
			has_handled = false
	
	return has_handled

### -----------------------------------------------------------------------------------------------
