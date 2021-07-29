var grounded = place_meeting(x,y+1,oBlock)
var keyRight = keyboard_check(ord("D"));
var keyLeft = keyboard_check(ord("A"));
var keyJump = keyboard_check_pressed(vk_space);
var movement = (keyRight - keyLeft) * spd;

if (grounded) {
	doubleJump = 1;
	hspd = approach(hspd, movement, acceleration);
	if (keyJump){
	}
} else {
	hspd = approach(hspd, movement, airAcceleration);
	vspd += grav;
	if (doubleJump > 0 && keyJump){
		doubleJump--;
	}
}

if (place_meeting(x + hspd, y, oBlock)) {
   while (!place_meeting(x + sign(hspd), y, oBlock)) {
      x += sign(hspd);
   }
   hspd = 0;
}
x += hspd;

if (place_meeting(x, y + vspd, oBlock)) {
	while (!place_meeting(x, y + sign(vspd), oBlock)) {
	    y += sign(vspd);
	}
	vspd = 0;
}
y += vspd;

var p = packet_start(packet_t.cursor);
if (obj_steam.lobby_is_owner) buffer_write_int64(p, user);
buffer_write(p, buffer_f32, x);
buffer_write(p, buffer_f32, y);
packet_send_all(p);