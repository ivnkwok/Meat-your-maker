extends Node

var playerPos = Vector2(0,0)
var playerMaxHP = 25
var doFlood = false
var playerDirection = Vector2(0,0)
var mobCount = 0
var maxMobs = 50
var meatCount = 0 #meat we have
var meatPile = 0 #meat we sold

var enemyData = {
	"cow":{"MaxHP":5, "ATK":1, "DEF": 0, "SPD":15},
	"chicken":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":15},
	"lizard":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":15},
	"crocodile":{"MaxHP":10, "ATK":3, "DEF": 0, "SPD":30}
}
