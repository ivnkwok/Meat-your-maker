extends Button

class_name upgradeButton

var level = Global.itemUpgrades[tooltip_text]["Level"]
var cost = Global.itemUpgrades[tooltip_text]["Cost"]

func _on_pressed() -> void:
	if (Global.coinCount >= Global.itemUpgrades[tooltip_text]["Cost"]):
		Global.coinCount -= Global.itemUpgrades[tooltip_text]["Cost"]
		Global.itemUpgrades[tooltip_text]["Level"] += 1
		Global.itemUpgrades[tooltip_text]["Cost"] = (1 + Global.itemUpgrades[tooltip_text]["Level"]) ** 2
		if (tooltip_text == "armor"):
			Global.playerMaxHP += 10
		get_parent().changeMakerDialogue("fetch me more meat")
	else: 
		get_parent().changeMakerDialogue("YOU ARE TOO POOR")
	pass

func update_text() -> void:
	text = "Cost: " + str(Global.itemUpgrades[tooltip_text]["Cost"]) + "\n" + "Level: " + str(Global.itemUpgrades[tooltip_text]["Level"])
