extends Control



var char
var leader
var blacksmith
var artist
var tech
var salesman



var coins := {
	"genuine": 0,
	"cQ1": 0,
	"cQ2": 0,
	"cQ3": 0
}
var distributedC: int = 0
var sheets: int = 0
var blanks: int = 0

var _rep := 1
var rep:
	get: return _rep
	set(value): _rep = clamp(value, 1, 5)

var _sus := 1
var sus:
	get: return _sus
	set(value): _sus = clamp(value, 1, 5)

func cutting_sheets():
	sheets -= 10
	blanks += 10
	_update_UI()

func strike_counterfeit_coins():
	blanks -= 10
	coins["cQ3"] += 10
	_update_UI()


#emd is the same as spark erosion
func edm_counterfeit_coins():
	blanks -= 20
	coins["cQ2"] += 20
	_update_UI()


func double_counterfeit():
	blanks -= 30
	coins["cQ2"] += 10
	coins["cQ1"] += 20
	_update_UI()


var goods := 0

func alter_coins():
	coins["genuine"] -= 3
	goods += 2
	_update_UI()

func make_goods():
	sheets -= 1
	goods += 1
	_update_UI()


var _usedg := 0
var usedg:
	get: return _usedg
	set(value): _usedg = clamp(value, 0, coins["genuine"])

var _usedc := 0
var usedc:
	get: return _usedc
	set(value): _usedc = clamp(value, 0, coins["cQ1"])

var _usedcc := 0
var usedcc:
	get: return _usedcc
	set(value): _usedcc = clamp(value, 0, coins["cQ2"])

var _usedccc := 0
var usedccc:
	get: return _usedccc
	set(value): _usedccc = clamp(value, 0, coins["cQ3"])


func trade(price, product_name:String, amnt, exp):
	print(price)
	var total = usedg + usedc + usedcc + usedccc
	if total < price: return
	var remaining = price
	var take_g = min(usedg, remaining)
	remaining -= take_g
	var take_c1 = min(usedc, remaining)
	remaining -= take_c1
	var take_c2 = min(usedcc, remaining)
	remaining -= take_c2
	var take_c3 = min(usedccc, remaining)
	remaining -= take_c3
	coins["genuine"] -= take_g
	coins["cQ1"] -= take_c1
	coins["cQ2"] -= take_c2
	coins["cQ3"] -= take_c3
	distributedC += take_c1 + take_c2 + take_c3
	self[product_name] += amnt
	var fake_value = take_c1 * 1.5 + take_c2 * 1.0 + take_c3 * 0.5
	var risk = clamp((fake_value * exp - take_g) / price, 0.0, 1.0)
	if randf() < risk: sus += 1
	#money -= price
	_update_UI()


func buy_sheets():
	trade(5, "sheets", 10, 1)

func buy_blanks():
	trade(7,"blanks", 10, 1)

func donate():
	trade(50, "sus", -1, 1)

func sell_goods():
	goods -= 3
	coins["genuine"] += 10 + rep
	distributedC += 5 + rep
	_update_UI()




func _ready() -> void:
	_update_UI()



#TIME SYSTEM
var actions:Array[Callable] = []
#time of day
var tod:int :
		set (new):
			tod = clamp(new, 0, 8)

var day:int

#conrta = contradict
func assign_task(task,contras,character,eligs):
	for item in eligs:
		if char == item:
			
			actions.append(task)
	for item in contras:
		unassign_task(item)
	




func unassign_task(task):
	for item in task:
		actions.erase(task)



func day_end():
	pass

func _update_UI():
	if tod < 8:
		tod += 1
		for act in actions:
			act.call()
	elif tod == 8:
		day_end()




func fade() -> void:
	while $FadeBox.color.a <= 0.9:
		$FadeBox.color.a = lerp($FadeBox.color.a, 1.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 1.0
	await get_tree().create_timer(1.0).timeout
	#$FadeBox/Label.text = "Day: " + str(day)
	await get_tree().create_timer(1.0).timeout
	$FadeBox/Label.text = ""
	while $FadeBox.color.a >= 0.1:
		$FadeBox.color.a = lerp($FadeBox.color.a, 0.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 0.0


func _on_button_pressed() -> void:
	char = 3
