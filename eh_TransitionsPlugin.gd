@tool
extends EditorPlugin

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const AUTOLOAD_NAME = "eh_Transitions"
const AUTOLOAD_SETTINGS = "eh_jogos/eh_transitions/autoload_path"
const AUTOLOAD_DEFAULT_PATH = "res://addons/eh_jogos.transitions/eh_Transitions.tscn"

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree() -> void:
	if not ProjectSettings.has_setting(AUTOLOAD_SETTINGS):
		ProjectSettings.set_setting(AUTOLOAD_SETTINGS, AUTOLOAD_DEFAULT_PATH)
		ProjectSettings.set_initial_value(AUTOLOAD_SETTINGS, AUTOLOAD_DEFAULT_PATH)
	
	ProjectSettings.add_property_info({
		"name": AUTOLOAD_SETTINGS,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "",
	})
	
	if Engine.is_editor_hint():
		ProjectSettings.save()
		project_settings_changed.emit()


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_DEFAULT_PATH)


func _disable_plugin() -> void:
	if ProjectSettings.has_setting("autoload/%s"%[AUTOLOAD_NAME]):
		var current_path := ProjectSettings.get_setting("autoload/%s"%[AUTOLOAD_NAME]) as String
		if "*%s"%[AUTOLOAD_DEFAULT_PATH] == current_path:
			remove_autoload_singleton(AUTOLOAD_NAME)

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_project_settings_changed() -> void:
	_update_autoloads()


func _update_autoloads() -> void:
	var settings_path := ProjectSettings.get_setting(AUTOLOAD_SETTINGS) as String
	if ProjectSettings.has_setting("autoload/%s"%[AUTOLOAD_NAME]):
		var current_path := ProjectSettings.get_setting("autoload/%s"%[AUTOLOAD_NAME]) as String
		if "*%s"%[settings_path] != current_path:
			remove_autoload_singleton(AUTOLOAD_NAME)
			add_autoload_singleton(AUTOLOAD_NAME, settings_path)

### -----------------------------------------------------------------------------------------------
