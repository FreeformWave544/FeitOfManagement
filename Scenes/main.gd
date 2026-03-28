extends Control

func nothing():
	pass

var char :int = 0
var character_actions = {
	1:nothing(),
	2:nothing(),
	3:nothing(),
	4:nothing(),
	5:nothing()
}



var coins := {
	"genuine": 10,
	"cQ1": 10,
	"cQ2": 10,
	"cQ3": 10
}
var distributedC: int = 0
var sheets: int = 10
var blanks: int = 10

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


func strike_counterfeit_coins():
	blanks -= 10
	coins["cQ3"] += 10



#emd is the same as spark erosion
func edm_counterfeit_coins():
	blanks -= 20
	coins["cQ2"] += 20




var goods := 0

func alter_coins():
	coins["genuine"] -= 5
	goods += 1


func make_goods():
	sheets -= 10
	goods += 1



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



func buy_sheets():
	trade(5, "sheets", 10, 1)

func buy_blanks():
	trade(7,"blanks", 10, 1)

func donate():
	coins["genuine"] -= 50
	sus -= 1

func sell_goods():
	goods -= 3
	coins["genuine"] += 10 + rep
	distributedC += 5 + rep





func _ready() -> void:
	pass



@onready var char_label: Label = $"debug labels/char label"

@onready var actions_label: Label = $"debug labels/actions label"
@onready var leader_action: Label = $"debug labels/leader action"
@onready var black_smith_action: Label = $"debug labels/black smith action"
@onready var artist_action: Label = $"debug labels/artist action"
@onready var sales_man_action: Label = $"debug labels/sales man action"
@onready var tech_action: Label = $"debug labels/tech action"
@onready var hour: Label = $Stats/Hour
@onready var days: Label = $Stats/Day
@onready var distributed: Label = $CoinCount/Distributed
@onready var c_q_1: Label = $CoinCount/cQ1
@onready var c_q_2: Label = $CoinCount/cQ2
@onready var c_q_3: Label = $CoinCount/cQ3
@onready var real: Label = $CoinCount/Real
@onready var sheetslabel: Label = $Materials/Sheets
@onready var blankslabel: Label = $Materials/Blanks
@onready var sus_level: Label = $"VBoxContainer/sus level"
@onready var reputation_level: Label = $"VBoxContainer/reputation level"




func _process(delta: float) -> void:
	actions_label.text = str(actions)
	char_label.text = str(char)
	leader_action.text = str(character_actions[1])
	black_smith_action.text = str(character_actions[2])
	artist_action.text = str(character_actions[3])
	sales_man_action.text = str(character_actions[4])
	tech_action.text = str(character_actions[5])
	
	hour.text = "hour " + str(tod) + "/8"
	days.text = "day " + str(day)
	
	distributed.text = "distributed " + str(distributedC)
	c_q_1.text = "bad fakes " + str(coins["cQ1"])
	c_q_2.text = "mid fakes " + str(coins["cQ2"])
	c_q_3.text = "good fakes " + str(coins["cQ3"])
	real.text = "genuines " + str(coins["genuine"])
	
	sheetslabel.text = "sheet " + str(sheets)
	blankslabel.text = "blanks " + str(blanks)
	
	
	sus_level.text = "sus level " + str(sus)
	reputation_level.text = "reputation " + str(rep)
	
	if sus == 5:
		lose()





#TIME SYSTEM
var actions:Array[Callable]
#time of day
var tod:int = 0 :
		set (new):
			tod = clamp(new, 0, 8)

var day:int

#conrta = contradict elig = eligable
func assign_task(task,contras:Array,character,eligs):
	unassign_task(actions, contras)
	for con in contras:
		for item in [1,2,3,4,5]:
			if character_actions[item] == con:
				character_actions[item] = nothing()
	
	
	for item in eligs:
		if character == item:
			actions.append(task)
			character_actions[char] = task





func unassign_task(aray, contras):
	for item in contras:
		aray.erase(item)
	#pass



func lose():
	pass

var target: int = day * 5

func day_end():
	fade()
	tod = 1
	if distributedC < target:
		lose()

func time_pass():
	if tod < 8:
		tod += 1
		for act in actions:
			act.call()
	elif tod == 8:
		day_end()
	
	for item in [1,2,3,4,5]:
		character_actions[item] = nothing()
	
	actions = []




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










# 3 is the artist
func _on_button_pressed() -> void:
	char = 3


func _on_blacksmith_button_pressed() -> void:
	char = 2


func _on_leader_button_pressed() -> void:
	char = 1



func _on_salesman_button_pressed() -> void:
	char = 4


func _on_tech_button_pressed() -> void:
	char = 5








var mach_contras = [cutting_sheets,strike_counterfeit_coins]
var cut_eligs = [5]
func _on_cut_sheets_pressed() -> void:
	if sheets >= 10:
		assign_task(cutting_sheets,mach_contras,char,cut_eligs)


var strike_eligs = [2,5]
func _on_strike_counterfeit_pressed() -> void:
	if blanks >= 10:
		assign_task(strike_counterfeit_coins,mach_contras,char,strike_eligs)




var spark_erosion_contras = [edm_counterfeit_coins]
var spark_erosion_eligs = [2,5]
func _on_spark_erode_coins_pressed() -> void:
	if blanks >= 20:
		assign_task(edm_counterfeit_coins, spark_erosion_contras, char, spark_erosion_eligs)




var forge_contras = [alter_coins]
var alter_eligs = [2,3]
func _on_alter_coins_pressed() -> void:
	if coins["genuine"] >= 5:
		assign_task(alter_coins, forge_contras, char, alter_eligs)

var make_goods_aligs = [2,3]
func _on_make_goods_pressed() -> void:
	if sheets >= 10:
		assign_task(make_goods, forge_contras, char, make_goods_aligs)



var donate_contras = [donate,sell_goods]
var donate_eligs = [3,4]
func _on_assign_donate_button_pressed() -> void:
	if coins["genuine"] >= 50:
		assign_task(donate,donate_contras,char,donate_eligs)

var sell_eligs = [3,4]
func _on_sell_goods_pressed() -> void:
	if goods >= 3:
		assign_task(sell_goods,donate_contras, char, sell_eligs)


var trade_contras = [buy_sheets,buy_blanks]
var trade_eligs = [3,4]


func _on_buy_sheets_pressed() -> void:
	assign_task(buy_sheets, trade_contras, char, trade_eligs)

func _on_buy_blanks_pressed() -> void:
	assign_task(buy_blanks, trade_contras, char, trade_eligs)








func _on_pass_time_pressed() -> void:
	time_pass()
