extends Node

var playerPos = Vector2(0,0)
var paused = false
var playerHP = 25
var playerMaxHP = 25
var playerDirection = Vector2(0,0)
var mobCount = 0
var maxMobs = 50
var meatCount = 0 #meat we have
var meatPile = 1 #meat we donated
var maxMeatPile = 0
var hunger = 1
var stage = 1
var coinCount = 0
var doFlood = false

var makerDialogue = ["MEAAAAAAAT!!!", "i hunger...", "where is my meat", "nice to meat you", "i like meat",]

var itemUpgrades = {
	"carving knife":{"Level":1, "Cost":3,},
	"armor":{"Level":1, "Cost":2,},
	"bracers":{"Level":1, "Cost":2,},
	"gloves":{"Level":1, "Cost":2,},
	"boots":{"Level":1, "Cost":2,},
	"sword":{"Level":1, "Cost":3,},
}

var enemyData = {
	"cow":{"MaxHP":5.0, "ATK":1, "DEF": 0, "SPD":15},
	"chicken":{"MaxHP":3.0, "ATK":1, "DEF": 0, "SPD":15},
	"lizard":{"MaxHP":3.0, "ATK":1, "DEF": 0, "SPD":15},
	"crocodile":{"MaxHP":10.0, "ATK":3, "DEF": 0, "SPD":20}
}

var attackData = {
	"scythe":{"ATK":1, "SPD":1, "Range":1}
}

func init() -> void:
	playerPos = Vector2(0,0)
	paused = false
	playerHP = 25
	playerMaxHP = 25
	playerDirection = Vector2(0,0)
	mobCount = 0
	maxMobs = 50
	meatCount = 0.0 #meat we have
	meatPile = 1.0 #meat we donated
	maxMeatPile = 0.0
	hunger = 1.0
	stage = 1
	coinCount = 0
	doFlood = false

	makerDialogue = ["MEAAAAAAAT!!!", "i hunger...", "where is my meat", "nice to meat you", "i like meat",]

	itemUpgrades = {
		"carving knife":{"Level":1, "Cost":1,},
		"armor":{"Level":1, "Cost":1,},
		"bracers":{"Level":1, "Cost":1,},
		"gloves":{"Level":1, "Cost":1,},
		"boots":{"Level":1, "Cost":1,},
		"sword":{"Level":1, "Cost":1,},
	}

	enemyData = {
		"cow":{"MaxHP":5, "ATK":1, "DEF": 0, "SPD":15},
		"chicken":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":15},
		"lizard":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":15},
		"crocodile":{"MaxHP":10, "ATK":3, "DEF": 0, "SPD":20}
	}

	attackData = {
		"scythe":{"ATK":1, "SPD":1, "Range":1}
	}
