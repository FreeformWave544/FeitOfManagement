extends Control

var metalQuality := 10.0
var blacksmithLoyalty := 10.0
var minerLoyalty := 10.0
var money := 100.00
var time_left := 6
var day := 1
var confirmed := false
var user_input := 0.0
var coins := {
	"genuine": 0,
	"cQ1": 0,
	"cQ2": 0,
	"cQ3": 0
}
var distributedC: int
var sheets: int
var blanks: int

var rep:int:
		set (new):
			rep = clamp(new, 1, 5)

var sus:int:
	set (new):
		sus = clamp(new, 1, 5)

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


func double_counterfeit():
	blanks -= 30
	coins["cQ2"] += 10
	coins["cQ1"] += 20


var new_goods_out:bool = false
var goods := 0

func alter_coins():
	coins["genuine"] -= 3
	goods += 2

func make_goods():
	sheets -= 1
	goods += 1


var _usedg := 0
var usedg:
	get: return _usedg
	set(value): _usedg = clamp(value, 0, coins["genuine"])

var _usedc := 0
var usedc:
	get: return _usedc
	set(value): _usedc = clamp(value, 0, coins["genuine"])

var _usedcc := 0
var usedcc:
	get: return _usedcc
	set(value): _usedcc = clamp(value, 0, coins["genuine"])

var _usedccc := 0
var usedccc:
	get: return _usedccc
	set(value): _usedccc = clamp(value, 0, coins["genuine"])


func trade(price, product_name:String, amnt, exp):
	if price == (usedg + usedc + usedcc + usedccc):
		coins["genuine"] -= usedg
		coins["cQ1"] -= usedc
		coins["cQ2"] -= usedcc
		coins["cQ3"] -= usedccc
		distributedC += usedc + usedcc + usedccc
		self[product_name] += amnt
		var risk: int
		risk = ((usedc * 1.5 + usedcc * 1 + usedccc * 0.5) * exp + usedg * -1) / price
		var danger =randi() % price * 2 + 1 
		if danger < risk:
			sus += 1
		
	else:
		pass


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




func _ready() -> void:
	_update_UI()

func _update_UI():
	metalQuality = snapped(clamp(metalQuality, 0.0, 100.0), 0.01)
	blacksmithLoyalty = snapped(clamp(blacksmithLoyalty, 0.0, 100.0), 0.01)
	minerLoyalty = snapped(clamp(minerLoyalty, 0.0, 100.0), 0.01)
	money = snapped(max(money, 0), 0.01)
	$Stats/Hour.text = "Hour:\n" + str(7 - time_left)
	$Stats/Day.text = "Day:\n" + str(day)
	$Stats/BlacksmithLoyalty.text = "Blacksmith Loyalty:\n" + str(blacksmithLoyalty)
	$Stats/Money.text = "Money:\n£" + str(money)
	$Stats/MinerLoyalty.text = "Miner Loyalty:\n" + str(minerLoyalty)
	$Stats/MetalQuality.text = "Metal Quality:\n" + str(metalQuality)

func _on_coins_pressed() -> void:
	time_left -= 1
	if time_left <= 0:
		hour_end()
		return
	$Coins.show()

func _on_real_pressed() -> void:
	coins["genuine"] += 1
	blacksmithLoyalty -= 1.0
	metalQuality += 1.0
	money += 0.75
	$Coins.hide()
	_update_UI()

func _on_fake_pressed() -> void:
	coins["cQ" + str(randi_range(1,3))] += 1
	blacksmithLoyalty += 1.0
	metalQuality -= 1.0
	money += 2
	$Coins.hide()
	_update_UI()

func hour_end() -> void:
	$User.show()
	$User/Text.text = "How much do you pay your blacksmith?"
	user_input = money + 1
	while user_input > money and confirmed == false:
		await $User/Confirm.pressed
		user_input = $User/MoneyInput.value
	confirmed = false
	var fair_pay := money * 0.3
	money -= user_input
	blacksmithLoyalty += snapped((((user_input / fair_pay) - 1.0) * 3.0), 0.01)
	_update_UI()
	$User/Text.text = "And your miner?"
	user_input = money + 1
	while user_input >= money and confirmed == false:
		await $User/Confirm.pressed
		user_input = $User/MoneyInput.value
	confirmed = false
	fair_pay = money * 0.3
	money -= user_input
	minerLoyalty += snapped((((user_input / fair_pay) - 1.0) * 3.0), 0.01)
	$User.hide()
	time_left = 6
	day += 1
	fade()
	_update_UI()

func _on_confirm_pressed() -> void: 
	if money - user_input >= 0: confirmed = true

func fade() -> void:
	while $FadeBox.color.a <= 0.9:
		$FadeBox.color.a = lerp($FadeBox.color.a, 1.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 1.0
	await get_tree().create_timer(1.0).timeout
	$FadeBox/Label.text = "Day: " + str(day)
	await get_tree().create_timer(1.0).timeout
	$FadeBox/Label.text = ""
	while $FadeBox.color.a >= 0.1:
		$FadeBox.color.a = lerp($FadeBox.color.a, 0.0, 0.15)
		await get_tree().process_frame
	$FadeBox.color.a = 0.0
