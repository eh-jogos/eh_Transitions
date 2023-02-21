# Scene Changer custom node to be used as a helper in conjuction with eh_Transitions
#
# Just instance this node in your scene, and set the path to the next scene in the
# exported variable in the editor. Then either call `transition_to_next_scene()` from
# code, or just instance it as a child of a button and it will connect itself to the 
# `pressed` signal.
# 
# You can also optionally set a transition data to override the default one that is 
# set in eh_Transition.tscn just for this transition.
extends Node
class_name eh_SceneChanger

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

@export var transition_data: eh_TransitionData = null

#--- private variables - order: export > normal var > onready -------------------------------------

@export var _next_scene_path: String = "" # (String, FILE, "*.tscn")

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	var parent = get_parent()
	await parent.ready
	if parent is BaseButton:
		parent.connect("pressed",Callable(self,"_on_owner_pressed"))

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_next_path() -> String:
	return _next_scene_path


func transition_to_next_scene() -> void:
	eh_Transitions.play_transition_in(transition_data)
	await eh_Transitions.transition_mid_point_reached
	
	_load_next_scene_from_path(_next_scene_path)
	
	eh_Transitions.play_transition_out(transition_data)


func transition_to(packed_scene: PackedScene) -> void:
	eh_Transitions.play_transition_in(transition_data)
	await eh_Transitions.transition_mid_point_reached
	
	_change_to_loaded_packed_scene(packed_scene)
	
	eh_Transitions.play_transition_out(transition_data)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _load_next_scene_from_path(path: String) -> void:
	get_tree().change_scene_to_file(path)


func _change_to_loaded_packed_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)


func _on_owner_pressed() -> void:
	transition_to_next_scene()

### ---------------------------------------
