# This script determines the behaviour of any projectile
extends RigidBody
class_name Projectile


# variables for position
var pos

# following variables initiate information about the projectile itself.

# determines the type of effect the weapon exerts on impact
enum projectile_types {explosive, energy, flame}
export(bool) var use_physics
export(bool) var splash_damage = false
export(float) var shot_sound_intensity = 1.2
export(float) var hit_sound_intensity = 1.2
export (projectile_types) var type
# determines initial speed of weapon
export(float) var speed = 25

# sets whether the weapon constantly exerts thrust (like a rocket propelled weapon) or not.
export var propelled = false

export(PackedScene) var explosion = preload("../../Basics/Guns/explosion.tscn")

export(PackedScene) var splash = preload("../..//Basics/Guns/explosion.tscn")

export var damage = 10

var wielder


func setup(wieldee):
	wielder = wieldee

func _integrate_forces(state):
	if propelled:
		propel()
		

func propel():
	
	# determine basis for flight
	var dir = get_global_transform().basis*Vector3(0,0,-1).normalized()
	
	# exert impulse on bolt to propel it.
	set_linear_velocity(dir*speed)
	apply_impulse(Vector3(),dir * speed ) 

func _ready():

	# set transform relative to global
	set_as_toplevel(true)
	set_use_custom_integrator(not use_physics)
	
	# get current position/orientation
	# pos = get_transform()
	
	propel()

	

# when the hitbox collides with something:
func _on_Area_body_entered(body):

	# if its a character or object (wall, etc)
	if body is StaticBody or body is RigidBody or body is KinematicBody or body is GridMap:
				# so long as the object is NOT the bolt itself (since the bolt is a rigid body)
		if body == wielder:
			pass
		else:
			var splode = explosion.instance()
			splode.set_as_toplevel(true)
			splode.set_global_transform(get_global_transform())
			
		
			#var splodepos = splode.get_global_transform()
			#squibpos.origin = squibpoint
			#thissquib.set_global_transform(squibpos)
			if body.owner == null:
				pass
			else:
				print(type)
				if type == 0:
					body.owner.add_child(splode)
			# have some effect (right now it just queues free.
			queue_free()



		if body.has_method("hit"):
			body.hit(damage)
			queue_free()




func _on_killtimer_timeout():
	queue_free()

