extends Node


var outfit_graphics : Dictionary = {
	"Junior Hunter": {
		"Idle": preload("uid://c7inonqhoemlt"),
		"Run": preload("uid://doypgng7koxsl"),
		"Jump": preload("uid://d2mhsxosuogyg"),
		"Fall": preload("uid://da01x6ypb46we"),
		"SwordSwing1": preload("uid://cshuuw4evmiqi"),
		"SwordSwing2":preload("uid://cshuuw4evmiqi"),
		"SwordSwing3":preload("uid://cshuuw4evmiqi"),
		"AirAttack":preload("uid://cshuuw4evmiqi"),
		"Climb": preload("uid://cqmq21ket8vvt"),
		"PickaxeSwing": preload("uid://cnf7idq4cexlj"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw"),
		"SwordSoar": preload("uid://byycfcy4i7vap"),
		"SwordSlam": preload("uid://c6outchyu637"),
		"BasicAttackEffect": preload("uid://bvj4nyj0lqt7s"),
		"Punch": preload("uid://0w3eyeg5v6bf"),
		"JumpFail": preload("uid://cvx717tchelpg"),
		"BasicDash": preload("uid://dp8eilpd2k4li")
	},
	"Tyro" : {
		"Idle": preload("uid://bsy5tgiwm7wxj"),
		"Run": preload("uid://d3k856go8d7y1"),
		"Jump": preload("uid://djvf2ohe2te8o"),
		"Fall": preload("uid://dax4hrmfncnu1"),
		"SwordSwing1": preload("uid://yr04pwemffgp"),
		"SwordSwing2":preload("uid://yr04pwemffgp"),
		"SwordSwing3":preload("uid://yr04pwemffgp"),
		"AirAttack":preload("uid://yr04pwemffgp"),
		"Climb": preload("uid://dk2em20jehn6b"),
		"PickaxeSwing": preload("uid://bik1x4xoyau24"),
		"DoubleCleave": preload("uid://4vkwnouwrrvw"),
		"SwordSoar": preload("uid://byycfcy4i7vap"),
		"SwordSlam": preload("uid://c6outchyu637"),
		"BasicAttackEffect": preload("uid://cn3s2uyi5i0pn"),
		"CycloneSlash": preload("uid://cwehmdaknb5ko"),
		"IronBody": preload("uid://s3c87yot2mlq"),
		"CircleOfTruth": preload("uid://crb6j81csruty"),
		"BasicDash": preload("uid://qg85t3wo7ly")
	},
	"Scribe Assistant": {
		"Idle": preload("uid://5uc2u1d1le3p"),
		"Run": preload("uid://dpum7yncmrj2x"),
		"Jump": preload("uid://cdney1dm2y684"),
		"Fall": preload("uid://8fvuln5x3iwa"),
		"SwordSwing1": preload("uid://m0k16key62gx"),
		"SwordSwing2": preload("uid://m0k16key62gx"),
		"AirAttack": preload("uid://m0k16key62gx"),
		"Climb": preload("uid://dlsry6yucic6j"),
		"PickaxeSwing": preload("uid://t3htsoyocbhu"),
		"BasicAttackEffect": preload("uid://dh3xfouvye3y4"),
		"BasicDash": preload("uid://dmnues8rqj1ka"),
		"PiercerBall": preload("uid://b1dyp2h8seeja")
	}
}

var hat_graphics : Dictionary = {
	"Junior Hunter": {
		"Idle": preload("uid://bjp2s7yqooy8t"),
		"Run": preload("uid://vmo8wokwkc8a"),
		"Jump": preload("uid://p550rqpf4d83"),
		"Fall": preload("uid://vmo8wokwkc8a"),
		"SwordSwing1":preload("uid://cil485q0idseb"),
		"SwordSwing2":preload("uid://cil485q0idseb"),
		"SwordSwing3":preload("uid://cil485q0idseb"),
		"AirAttack":preload("uid://cil485q0idseb"),
		"Climb": preload("uid://c7ljgo002h40v"),
		"PickaxeSwing": preload("uid://c1pbd4as0c2xc"),
		"Punch": preload("uid://c4qqjbhlwokxy"),
		"JumpFail": preload("uid://5qcvfukjlly"),
		"BasicDash": preload("uid://ctal8l7td7fsb")
	},
	"Tyro": {
		"Idle": preload("uid://4i8u8xn7vxl4"),
		"Run": preload("uid://csgymmtpck4u3"),
		"Jump": preload("uid://dl55iycis7muh"),
		"Fall": preload("uid://dfpgvbgtn7ndg"),
		"SwordSwing1": preload("uid://jatbge31yk80"),
		"SwordSwing2":preload("uid://jatbge31yk80"),
		"SwordSwing3":preload("uid://jatbge31yk80"),
		"AirAttack":preload("uid://jatbge31yk80"),
		"Climb": preload("uid://dieqdywe5ie2g"),
		"PickaxeSwing": preload("uid://curgsreedone"),
		"DoubleCleave": preload("uid://cdjtkp032dh2e"),
		"CycloneSlash": preload("uid://feb6oixixgfb"),
		"IronBody": preload("uid://bm07q8trkuupd"),
		"CircleOfTruth": preload("uid://dpccjvwg6fteh"),
		"BasicDash": preload("uid://b4utpatx6logy")
	},
	"Scribe Assistant": {
		"Idle": preload("uid://cmvajffgy6ry5"),
		"Run": preload("uid://bf75lajvldmuk"),
		"Jump": preload("uid://2uti4pkgeg7f"),
		"Fall": preload("uid://terep6wnsyl6"),
		"SwordSwing1": preload("uid://hccmca18cxw"),
		"SwordSwing2": preload("uid://hccmca18cxw"),
		"AirAttack": preload("uid://hccmca18cxw"),
		"Climb": preload("uid://cbwcus8dp1yhk"),
		"PickaxeSwing": preload("uid://ce6typhyi1h8j"),
		"BasicDash": preload("uid://dmnues8rqj1ka"),
		"PiercerBall": preload("uid://7jb14k43c70y")
	}
}

func get_outfit_graphic(animation_name : String) -> Texture2D:
	var player_class : String = PlayerStats.player_stats["Class"]
	return outfit_graphics[player_class][animation_name]

func get_hat_graphic(animation_name : String) -> Texture2D:
	var player_class : String = PlayerStats.player_stats["Class"]
	return hat_graphics[player_class][animation_name]
