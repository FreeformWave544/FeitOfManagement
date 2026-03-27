extends Panel

@onready var block := $Block

func _physics_process(delta: float) -> void:
	if visible:
		$ProgressBar.value -= 5.0 * delta

func _ready() -> void:
	while visible:
		block.position = Vector2(randf_range(50, 450), randf_range(50, 450))
		await $Block.pressed
		$ProgressBar.value += randf_range(7.5, 10.0)
		if $ProgressBar.value == 100.0:
			break
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
