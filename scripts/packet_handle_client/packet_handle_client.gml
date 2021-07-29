function packet_handle_client(argument0) {
	var b = inbuf, p, s;
	var from = argument0;
	net_map[?from] = current_time;
	switch (buffer_read(b, buffer_u8)) {
	    case packet_t.auth: // ()
	        var u = buffer_read_int64(b);
	        ds_list_add(net_list, u);
	        net_map[?u] = current_time;
	        break;
	    case packet_t.ping: // ()
	        p = packet_start(packet_t.ping);
	        packet_send_to(p, from);
	        break;
	    case packet_t.chat: // (message:string)
	        s = buffer_read(b, buffer_string);
	        chat_add(s);
	        break;
	    case packet_t.error: // (error:strign)
	        s = buffer_read(b, buffer_string);
	        chat_add("Error: " + s);
	        if (lobby) {
	            lobby = false;
	            lobby_is_owner = false;
	            lobby_owner = 0;
	            steam_lobby_leave();
	        }
	        if (ingame) {
	            ingame = false;
	            room_goto(rm_menu);
	        }
	        break;
	    case packet_t.leaving:
	        packet_handle_leaving(buffer_read_int64(b));
	        break;
	    case packet_t.start:
	        ingame = true;
	        room_goto(rm_game);
	        break;
	    case packet_t.cursor:
	        // update the client-side player instance:
			var steam_id = buffer_read_int64(b);
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        with (obj_cursor) if (user == steam_id) {
	            x = _x;
	            y = _y;
	        }
	        break;
		case packet_t.weapon:
			//update the client side shotgun instance:
			var _steam_id = buffer_read_int64(b);
			var _w = buffer_read(b, buffer_s16);
			var _sh = buffer_read(b, buffer_bool);
			var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        var _d = buffer_read(b, buffer_s16);
			var _ys = buffer_read(b, buffer_s16);
	        var _ia = buffer_read(b, buffer_s16);
	        with (oWeapon) if (user == _steam_id){
				weapon = _w;
				if (_sh) shoot = true; else shoot = false;
	            x = _x;
	            y = _y;
				direction = _d;
				image_yscale = _ys;
				image_angle = _ia;
	        }
	        break;
		case packet_t.bullet:
			//buffer_write(p, buffer_s16, id);
			//buffer_write(p, buffer_f32, speed);
			//buffer_write(p, buffer_f32, direction);
			//buffer_write(p, buffer_f32, image_angle);
			//buffer_write(p, buffer_f32, image_yscale);
			var _id = buffer_read(b, buffer_s16);
			var _b = buffer_read(b, buffer_s16);
			var _s = buffer_read(b, buffer_f32);
	        var _d = buffer_read(b, buffer_f32);
	        var _ia = buffer_read(b, buffer_s16);
			with (oBullet) if (pid == _id){
				bullet = _b;
				selectbullet2(_b)
				speed = _s;
				direction = _d;
				image_angle = _ia;
			}
			break;
		case packet_t.controller:
			var _b = buffer_read(b, buffer_s16);
			var _id = buffer_read(b, buffer_s16);
			with (oController){
				repeat (_b) {
					var block = instance_create(0,0,oObstacle)
					with (block) {
						pid = _id;
					}
					with instance_create(x,y,o_local_obstacle){
						x = block.x;
						y = block.y;
					}
				}
			}
			break;
		case packet_t.obstacle:
	        // update the client-side player instance:
			var _id = buffer_read(b, buffer_s16);
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        var _vs = buffer_read(b, buffer_s16);
	        var _hs = buffer_read(b, buffer_s16);
			var _rot = buffer_read(b, buffer_s16);
	        with (oObstacle) if (pid == _id){
				x = _x;
				y = _y;
				vspeed = _vs;
				hspeed = _hs;
				image_angle = _rot;
	        }
	        break;
		case packet_t.explosion:
	        // update the client-side player instance:
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        instance_create(_x,_y,oExplosion);
	        break;
	}		
}
