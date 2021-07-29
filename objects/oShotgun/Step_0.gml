x = owner.x;
y = owner.y;

var key_aright = keyboard_check(vk_right);
var key_aleft = keyboard_check(vk_left);
var key_aup = keyboard_check(vk_up);
var key_adown = keyboard_check(vk_down);
var key_attack_check = keyboard_check_pressed(vk_space);
var key_attack = keyboard_check(vk_space);


var hinput = key_aright - key_aleft;
var vinput = key_adown - key_aup;
var dir = point_direction(0,0,hinput,vinput);
if (hinput != 0 || vinput != 0) {
	var dd = angle_difference(direction, dir);
	direction -= min(abs(dd), 10) * sign(dd);
}

if (direction > 90) && (direction < 270) 
{
	image_yscale = -0.5;
	x = owner.x - 3;
}
else 
{
	image_yscale = 0.5;
	x = owner.x + 3;
}

image_angle = direction;
		
var r1;
if (automatic) r1 = key_attack_check; 
else r1 = key_attack;


if (r1)
{
	if (current_cd == 0)
	{
		current_cd = cooldown;
		current_delay = startup;
	}
}


//if (cooldownr <= 0) && (owner.key_reload) && (ammo[weapon] < 7){
//	reload = true;
//	cooldownr = 20;
//	ammo[weapon] += 1
//}
//if (reload){
//	cooldownr--
//	if (cooldownr <= 0){
//		reload = false;
//	}
//}
//if (ammo[weapon] > 7) ammo[weapon] = 7

var _s = 0, _d = 0, _ia = 0, _iy = 0, bullet = noone, number = 0;
if (r1) {
	if(current_delay == 0) && (projectile != -1){
	//shoot
		number = 1;
		//sound
		//audio_play_sound(soShotgun, 0, false);
		for (var b = 0; b < 5; b ++){
			_s = bulletspeed;
			_d = direction + random_range(20,-20);
			_ia = image_angle;
			if (direction > 90) && (direction < 270) _iy = -1;
			else _iy = 1;
			bullet = instance_create(x+lengthdir_x(length,direction),y+lengthdir_y(length,direction),projectile)
			with (bullet){	
				owner = other.owner.id;
				damage = 10;
				speed = _s;
				direction = _d;
				image_angle = _ia;
				image_yscale = _iy;
				var p = packet_start(packet_t.bullet);
				buffer_write(p, buffer_f32, x);
				buffer_write(p, buffer_f32, y);
				buffer_write(p, buffer_f32, speed);
				buffer_write(p, buffer_f32, direction);
				buffer_write(p, buffer_f32, image_angle);
				buffer_write(p, buffer_f32, image_yscale);
				packet_send_all(p);
			}
		with (owner){
			hspd = -lengthdir_x(other.recoil_push,other.image_angle);
			vspd = -lengthdir_y(other.recoil_push,other.image_angle);
		}
	}
	current_delay = cooldown;
	current_recoil = recoil;
	} 
}

//if (shoot){
//	with(oPlayer){
//		max_speed = 1.5;
//	}
//} else {
//	with(oPlayer){
//		if (max_speed == 1.5) max_speed = ds_map_find_value(oControl.pInfo,"max_speed");
//	}	
//}

current_delay = max(-1,current_delay-1);
if (current_delay == -1) current_cd = max(0,current_cd-1);
current_recoil = max(0,floor(current_recoil*0.8));

var p = packet_start(packet_t.weapon);
if (obj_steam.lobby_is_owner) buffer_write_int64(p, user);
buffer_write(p, buffer_f32, x);
buffer_write(p, buffer_f32, y);
buffer_write(p, buffer_f32, image_angle);
buffer_write(p, buffer_f32, image_yscale);
buffer_write(p, buffer_f32, direction);
packet_send_all(p);
