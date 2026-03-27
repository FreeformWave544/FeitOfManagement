extends Control

@export var faultyCoins: Dictionary[String, Dictionary] = {
	# path: fault location
	"res://assets/coins/desert_eagle_face.png": {
		"res://assets/coins/faulty_desert_eagle_face1.png": Vector2(0, -19),
		"res://assets/coins/faulty_desert_eagle_face2.png": Vector2(0, -7),
		"res://assets/coins/faulty_desert_eagle_face3.png": Vector2(-22, 11)
	},
	"res://assets/coins/desert_eagle_back.png": {
		"res://assets/coins/faulty_desert_eagle_back1.png": Vector2(21, -13),
		"res://assets/coins/faulty_desert_eagle_back2.png": Vector2(5, 5),
		"res://assets/coins/faulty_desert_eagle_back3.png": Vector2(48, -5)
	},
	"res://assets/coins/washing_ton_back.png": {
		"res://assets/coins/faulty_washing_ton_back1.png": Vector2(31, -4)
	},
	"res://assets/coins/washing_ton_face.png": {
		"res://assets/coins/faulty_washing_ton_face1.png": Vector2(-9, 11),
		"res://assets/coins/faulty_washing_ton_face2.png": Vector2(-1, -4)
	}
}

@export var targetScore := 10
var score := 0

func newCoin() -> bool:
	var baseCoin = faultyCoins.keys().pick_random()
	var coin = faultyCoins[baseCoin].keys().pick_random()
	$Real/Sprite2D.texture = load(baseCoin)
	$Fake/Sprite2D.texture = load(coin)
	$Fault.global_position = ($Fake/Sprite2D.global_position + faultyCoins[baseCoin][coin]) - Vector2(10,5)
	return false

func _ready() -> void:
	newCoin()

func _on_fault_pressed() -> void:
	score += 1
	fade()
	print(score)

var won = false
func fade() -> void:
	$Fault.disabled = true
	while $FadeBox.color.a <= 0.9:
		$FadeBox.color.a = lerp($FadeBox.color.a, 1.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 1.0
	await get_tree().create_timer(0.5).timeout
	won = newCoin() if score < targetScore else true
	if won: get_tree().change_scene_to_file("res://Scenes/Main.tscn") ; return
	while $FadeBox.color.a >= 0.1:
		$FadeBox.color.a = lerp($FadeBox.color.a, 0.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 0.0
	$Fault.disabled = false
