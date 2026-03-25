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


var new_goods_out:bool = false
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
	money -= price
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
	$CoinCount/cQ1.text = "Coins (Quality 1):\n" + str(coins["cQ1"])
	$CoinCount/cQ2.text = "Coins (Quality 2):\n" + str(coins["cQ2"])
	$CoinCount/cQ3.text = "Coins (Quality 3):\n" + str(coins["cQ3"])
	$CoinCount/Real.text = "Real Coins:\n" + str(coins["genuine"])
	$CoinCount/Distributed.text = "Distributed Coins:\n" + str(distributedC)
	$Materials/Sheets.text = "Sheets:\n" + str(sheets)
	$Materials/Blanks.text = "Blanks:\n" + str(blanks)

func _on_coins_pressed() -> void:
	time_left -= 1
	if time_left <= 0:
		hour_end()
		return
	$Coins.show()
	_update_UI()

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
