extends Node

var playerPos = Vector2(0,0)
var playerMaxHP = 100.0
var mobCount = 0
var maxMobs = 10
var enemyData = {
	"cow":{"MaxHP":5, "ATK":1, "DEF": 0, "SPD":10},
	"chicken":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":10},
	"lizard":{"MaxHP":3, "ATK":1, "DEF": 0, "SPD":10},
	"crocodile":{"MaxHP":10, "ATK":3, "DEF": 0, "SPD":15}
}
