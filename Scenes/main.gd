extends Control

var realCoins := 0
var fakeCoins := 0
var metalQuality := 10.0
var blacksmithLoyalty := 10.0
var minerLoyalty := 10.0
var money := 100.00
var time_left := 10
var confirmed := false
var user_input := 0.0

func _ready() -> void:
	_update_UI()

func _update_UI():
	metalQuality = snapped(clamp(metalQuality, 0.0, 100.0), 0.01)
	blacksmithLoyalty = snapped(clamp(blacksmithLoyalty, 0.0, 100.0), 0.01)
	minerLoyalty = snapped(clamp(minerLoyalty, 0.0, 100.0), 0.01)
	money = snapped(money, 0.01)
	$Stats/BlacksmithLoyalty.text = "Blacksmith Loyalty:\n" + str(blacksmithLoyalty)
	$Stats/Money.text = "Money:\n" + str(money)
	$Stats/MinerLoyalty.text = "Miner Loyalty:\n" + str(minerLoyalty)
	$Stats/MetalQuality.text = "Metal Quality:\n" + str(metalQuality)

func _on_coins_pressed() -> void:
	time_left -= 1
	if time_left <= 0:
		day_end()
		return
	$Coins.show()

func _on_real_pressed() -> void:
	realCoins += 1
	blacksmithLoyalty -= 1.0
	metalQuality += 1.0
	money += 0.75
	$Coins.hide()
	_update_UI()

func _on_fake_pressed() -> void:
	fakeCoins += 1
	blacksmithLoyalty += 1.0
	metalQuality -= 1.0
	money += 2
	$Coins.hide()
	_update_UI()

func day_end() -> void:
	$User.show()
	$User/Text.text = "How much do you pay your blacksmith?"
	user_input = money + 1
	while user_input >= money and confirmed == false:
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
	_update_UI()
	$User.hide()
	time_left = 10

func _on_confirm_pressed() -> void: 
	if money - user_input >= 0: confirmed = true
