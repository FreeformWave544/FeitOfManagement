extends Node2D

var realCoins := 0
var fakeCoins := 0
var metalQuality := 10.0
var blacksmithLoyalty := 10.0
var metalSupplierLoyalty := 10.0

func _on_coins_pressed() -> void:
	$Coins.show()

func _on_real_pressed() -> void:
	realCoins += 1

func _on_fake_pressed() -> void:
	fakeCoins += 1
