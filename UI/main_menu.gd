extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_options_pressed() -> void:
	add_child(load("res://Scenes/menus/options_menu/master_options_menu_with_tabs.tscn").instantiate())

func _ready() -> void:
	$Panel/Sprite2D.texture.noise.cellular_jitter = randf_range(1.000, 50.000)

var change = 0.1
func _physics_process(_delta: float) -> void:
	$Panel/Sprite2D.texture.noise.cellular_jitter += change
	if $Panel/Sprite2D.texture.noise.cellular_jitter >= 50: change = -0.1
	elif $Panel/Sprite2D.texture.noise.cellular_jitter < 0.0: change = 0.1
