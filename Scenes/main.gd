extends Node2D

var realCoins := 0
var fakeCoins := 0
var metalQuality := 10.0
var blacksmithLoyalty := 10.0
var minerLoyalty := 10.0
var money := 100.00

func _ready() -> void:
	_update_UI()

func _update_UI():
	metalQuality = clamp(metalQuality, 0.0, 100.0)
	blacksmithLoyalty = clamp(blacksmithLoyalty, 0.0, 100.0)
	minerLoyalty = clamp(minerLoyalty, 0.0, 100.0)
	$Stats/BlacksmithLoyalty.text = "Blacksmith Loyalty:\n" + str(blacksmithLoyalty)
	$Stats/Money.text = "Money:\n" + str(money)
	$Stats/MinerLoyalty.text = "Miner Loyalty:\n" + str(minerLoyalty)
	$Stats/MetalQuality.text = "Metal Quality:\n" + str(metalQuality)

func _on_coins_pressed() -> void:
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
