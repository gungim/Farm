extends Resource
class_name Crop

enum CROP_TYPE { AGRICULTURE, FORESTRY }

@export var name: String
@export var type: CROP_TYPE = CROP_TYPE.AGRICULTURE
@export var sprite_frames: SpriteFrames
@export var completed_time: int = 0
@export var products: CropProducts
