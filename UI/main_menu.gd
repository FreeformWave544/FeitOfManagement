extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_options_pressed() -> void:
	add_child(load("res://Scenes/menus/options_menu/master_options_menu_with_tabs.tscn").instantiate())
