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

#--- private variables - order: export > normal var > onready -------------------------------------

export(String, FILE, "*.tscn") var _next_scene_path: String = ""
export(Resource) var transition_data = null

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready():
	var parent = get_parent()
	yield(parent, "ready")
	if parent is BaseButton:
		parent.connect("pressed", self, "_on_owner_pressed")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func get_next_path() -> String:
	return _next_scene_path


func transition_to_next_scene() -> void:
	if transition_data != null and transition_data is eh_TransitionData:
		eh_Transitions.change_transition_data_oneshot(transition_data)
	
	eh_Transitions.play_transition_in()
	yield(eh_Transitions, "transition_mid_point_reached")
	
	_load_next_scene_from_path(_next_scene_path)
	
	eh_Transitions.play_transition_out()


func transition_to(packed_scene: PackedScene) -> void:
	if transition_data != null and transition_data is eh_TransitionData:
		eh_Transitions.change_transition_data_oneshot(transition_data)
	
	eh_Transitions.play_transition_in()
	yield(eh_Transitions, "transition_mid_point_reached")
	
	_change_to_loaded_packed_scene(packed_scene)
	
	eh_Transitions.play_transition_out()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _load_next_scene_from_path(path: String) -> void:
	get_tree().change_scene(path)


func _change_to_loaded_packed_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to(packed_scene)


func _on_owner_pressed() -> void:
	transition_to_next_scene()

### ---------------------------------------
