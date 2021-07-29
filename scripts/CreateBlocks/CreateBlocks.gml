// Los recursos de Script han cambiado para la v2.3.0 Consulta
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para más información
function CreateBlocks(argument0,argument1,argument2,argument3,argument4,argument5,argument6){
	block = 0;
	var _x1 = argument0, _x2 = argument1, _y1 = argument2, _y2 = argument3, _vs = argument4, _hs = argument5, _rot = argument6;
	var size = 1;
	for (var times = 0; times < 4; times++){
		block++;
		var i = instance_create_layer(random_range(_x1,_x2), random_range(_y1,_y2), "Obstacles", o_local_obstacle)
		i.number = instance_number(i);
		i.image_xscale = size;
		i.image_yscale = size;
		i.vspeed = _vs;
		i.hspeed = _hs;
		i.image_angle = _rot;
		pid = i.id;
		_x = i.x;
		_y = i.y;
		var p = packet_start(packet_t.controller);
		buffer_write(p, buffer_s16, block);
		buffer_write(p, buffer_s16, pid);
		packet_send_all(p);
		with (instance_create(i.x,i.y, oObstacle)){
			pid = i.id;
			hspeed = _hs
			vspeed = _vs
			image_angle = _rot;
		}
	}
}
