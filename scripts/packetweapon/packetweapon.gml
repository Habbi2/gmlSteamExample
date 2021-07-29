// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function packetweapon(argument0,argument1,argument2,argument3,argument4){
	var p = packet_start(packet_t.weapon);
	if (obj_steam.lobby_is_owner) buffer_write_int64(p, other.user);
	buffer_write(p, buffer_s16, other.weapon);
	buffer_write(p, buffer_bool, other.shoot);
	buffer_write(p, buffer_f32, other.x);
	buffer_write(p, buffer_f32, other.y);
	buffer_write(p, buffer_s16, other.image_yscale);
	buffer_write(p, buffer_s16, other.image_angle);
	buffer_write(p, buffer_s16, argument0);
	buffer_write(p, buffer_s16, argument1);
	buffer_write(p, buffer_s16, argument2);
	buffer_write(p, buffer_s16, argument3);
	buffer_write(p, buffer_s16, argument4);
	packet_send_all(p);
}