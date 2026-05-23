class_name LevelUpOption
extends Resource

@export var id: int	# must be the same as the level_up_scene ID
@export var option_name: String
@export var modifier_scene: PackedScene
@export var stat_requirements_to_unlock: Array[GlobalVariables.RequirementsLevelUpStats]
@export var requirement_minimum: float
@export var one_time: bool
@export var levelup_requirements_to_unlock: Array[LevelUpVariables.RequirementsLevelUpLevels]

func get_stat_value(stat: GlobalVariables.RequirementsLevelUpStats):
	match stat:
		GlobalVariables.RequirementsLevelUpStats.MAX_LIVES:
			return GlobalVariables.max_lives
		GlobalVariables.RequirementsLevelUpStats.GOLD:
			return GlobalVariables.gold
		GlobalVariables.RequirementsLevelUpStats.STAGE:
			return GlobalVariables.stage
		GlobalVariables.RequirementsLevelUpStats.XP_LEVEL:
			return GlobalVariables.xp_level
		GlobalVariables.RequirementsLevelUpStats.BRICK_GOLD_VALUE:
			return GlobalVariables.brick_gold_value
		GlobalVariables.RequirementsLevelUpStats.BRICK_SCORE_VALUE:
			return GlobalVariables.brick_score_value
		GlobalVariables.RequirementsLevelUpStats.BALL_SPEED:
			return GlobalVariables.ball_speed
		GlobalVariables.RequirementsLevelUpStats.PADDLE_POSITION:
			return GlobalVariables.paddle_position
		GlobalVariables.RequirementsLevelUpStats.PADDLE_SPEED:
			return GlobalVariables.paddle_speed
		GlobalVariables.RequirementsLevelUpStats.PADDLE_X_LENGTH:
			return GlobalVariables.paddle_position
		GlobalVariables.RequirementsLevelUpStats.SCORE_WITHOUT_SPEED:
			return GlobalVariables.score_without_speed
		GlobalVariables.RequirementsLevelUpStats.SPEED_DECREASE_ON_STAGE_START:
			return GlobalVariables.speed_decrease_on_stage_start
		GlobalVariables.RequirementsLevelUpStats.POWERUP_CHANCE:
			return GlobalVariables.powerup_chance
		GlobalVariables.RequirementsLevelUpStats.BRICK_CHANGE_CHANCE:
			return GlobalVariables.brick_change_chance
		GlobalVariables.RequirementsLevelUpStats.BONUS_XP_PERCENT:
			return GlobalVariables.bonus_xp_percent
		GlobalVariables.RequirementsLevelUpStats.LEVEL_UP_OPTIONS:
			return GlobalVariables.level_up_options
		GlobalVariables.RequirementsLevelUpStats.INFLATION:
			return GlobalVariables.inflation
		GlobalVariables.RequirementsLevelUpStats.INFLATION_RATE:
			return GlobalVariables.inflation_rate
		
		_:
			return null

func get_levelup_option(levelup: LevelUpVariables.RequirementsLevelUpLevels):
	match levelup:
		LevelUpVariables.RequirementsLevelUpLevels.START_WITH_EXTRA_SLOW_BALL:
			return LevelUpVariables.level_up_id_list["start_with_extra_slow_ball"]
		LevelUpVariables.RequirementsLevelUpLevels.INCREASE_BRICK0_SPAWN:
			return LevelUpVariables.level_up_id_list["increase_brick0_spawn"]
		LevelUpVariables.RequirementsLevelUpLevels.INCREASE_BRICK1_SPAWN:
			return LevelUpVariables.level_up_id_list["increase_brick1_spawn"]
		LevelUpVariables.RequirementsLevelUpLevels.INCREASE_BRICK2_SPAWN:
			return LevelUpVariables.level_up_id_list["increase_brick2_spawn"]
		LevelUpVariables.RequirementsLevelUpLevels.INCREASE_BRICK3_SPAWN:
			return LevelUpVariables.level_up_id_list["increase_brick3_spawn"]
		_:
			return null
