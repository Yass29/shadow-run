extends Node

var selected_skin := "shade"
var premium_wraith_owned := false
var premium_specter_owned := false

const SKINS := {
	"shade": {
		"name": "SHADE",
		"premium": false,
		"price": "",
		"torso": Color(0.20, 0.22, 0.36, 1.0),
		"cape": Color(0.16, 0.09, 0.30, 1.0),
		"head": Color(0.10, 0.11, 0.20, 1.0),
		"eyes": Color(0.55, 0.88, 1.0, 1.0),
		"scarf": Color(0.56, 0.31, 0.92, 1.0),
		"core": Color(0.48, 0.80, 1.0, 1.0)
	},
	"neon": {
		"name": "NEON",
		"premium": false,
		"price": "",
		"torso": Color(0.08, 0.24, 0.30, 1.0),
		"cape": Color(0.04, 0.12, 0.17, 1.0),
		"head": Color(0.04, 0.09, 0.12, 1.0),
		"eyes": Color(0.35, 1.0, 0.82, 1.0),
		"scarf": Color(0.18, 0.90, 0.76, 1.0),
		"core": Color(0.42, 1.0, 0.86, 1.0)
	},
	"wraith": {
		"name": "WRAITH",
		"premium": true,
		"price": "$2.99",
		"torso": Color(0.27, 0.07, 0.10, 1.0),
		"cape": Color(0.16, 0.025, 0.04, 1.0),
		"head": Color(0.09, 0.025, 0.03, 1.0),
		"eyes": Color(1.0, 0.30, 0.30, 1.0),
		"scarf": Color(0.95, 0.16, 0.22, 1.0),
		"core": Color(1.0, 0.45, 0.35, 1.0)
	},
	"specter": {
		"name": "SPECTER",
		"premium": true,
		"price": "$4.99",
		"torso": Color(0.20, 0.16, 0.33, 1.0),
		"cape": Color(0.10, 0.06, 0.20, 1.0),
		"head": Color(0.07, 0.05, 0.12, 1.0),
		"eyes": Color(0.95, 0.82, 1.0, 1.0),
		"scarf": Color(0.76, 0.48, 1.0, 1.0),
		"core": Color(0.95, 0.78, 1.0, 1.0)
	}
}

func is_owned(skin_id: String) -> bool:
	if skin_id == "wraith":
		return premium_wraith_owned
	if skin_id == "specter":
		return premium_specter_owned
	return true

func select_skin(skin_id: String) -> bool:
	if not SKINS.has(skin_id) or not is_owned(skin_id):
		return false
	selected_skin = skin_id
	return true
