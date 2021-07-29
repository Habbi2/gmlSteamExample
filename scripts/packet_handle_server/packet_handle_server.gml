function packet_handle_server(argument0) {
	var b = inbuf, p, s;
	var from = argument0;
	net_map[?from] = current_time;
	switch (buffer_read(b, buffer_u8)) {
	    case packet_t.ping: // ()
	        p = packet_start(packet_t.ping);
	        packet_send_to(p, from);
	        break;
	    case packet_t.chat: // (message:string)
	        s = steam_get_user_persona_name_w(from) + ": " + buffer_read(b, buffer_string);
	        chat_add(s);
	        //
	        p = packet_start(packet_t.chat);
	        buffer_write(p, buffer_string, s);
	        packet_send_all(p);
	        //
	        break;
	    case packet_t.leaving:
	        packet_handle_leaving(from);
	        // inform the other players:
	        var b = packet_start(packet_t.leaving);
	        buffer_write_int64(b, uid);
	        packet_send_all(b);
	        // show a notice in chat:
	        var s = steam_get_user_persona_name_w(uid) + " left the game.";
	        chat_add(s);
	        var b = packet_start(packet_t.chat);
	        buffer_write(b, buffer_string, s);
	        packet_send_all(b);
	        break;
	    case packet_t.cursor:
	        // update the server-side player instance:
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        with (obj_cursor) if (user == from) {
	            x = _x;
	            y = _y;
	        }
	        // inform other clients:
	        p = packet_start(packet_t.cursor);
	        buffer_write_int64(p, from);
	        buffer_write(p, buffer_f32, _x);
	        buffer_write(p, buffer_f32, _y);
	        packet_send_except(p, from);
	        break;
		case packet_t.weapon:
			// update the server-side player instance:
			var _w = buffer_read(b, buffer_s16);
			var _sh = buffer_read(b, buffer_bool);
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        var _d = buffer_read(b, buffer_s16);
			var _ys = buffer_read(b, buffer_s16);
			var _ia = buffer_read(b, buffer_s16);
	        with (oWeapon) if (user == from) {
				weapon = _w;
				if (_sh) shoot = true; else shoot = false;
	            x = _x;
	            y = _y;
				direction = _d;
				image_yscale = _ys;
				image_angle = _ia;
			}
	        // inform other clients:
	        var p = packet_start(packet_t.weapon);
			buffer_write_int64(p, from);
			buffer_write(p, buffer_s16, _w);
			buffer_write(p, buffer_bool, _sh);
			buffer_write(p, buffer_f32, _x);
			buffer_write(p, buffer_f32, _y);
			buffer_write(p, buffer_s16, _d);
			buffer_write(p, buffer_s16, _ys);
			buffer_write(p, buffer_s16, _ia);
			packet_send_except(p, from); 
	        break;
		case packet_t.bullet:
			var _id = buffer_read(b, buffer_s16);
			var _b = buffer_read(b, buffer_s16);
			var _s = buffer_read(b, buffer_f32);
	        var _d = buffer_read(b, buffer_f32);
	        var _ia = buffer_read(b, buffer_s16);
			with (oBullet) if (pid == _id){
				bullet = _b 
				selectbullet2(_b)
				speed = _s;
				direction = _d;
				image_angle = _ia
			}
			 //inform other clients:
	        var p = packet_start(packet_t.bullet);
			buffer_write(p, buffer_s16, _id);
			buffer_write(p, buffer_s16, _b);
			buffer_write(p, buffer_f32, _s);
			buffer_write(p, buffer_f32, _d);
			buffer_write(p, buffer_s16, _ia);
			packet_send_except(p, from);
	        break;
		case packet_t.controller:
			var _b = buffer_read(b, buffer_s16);
			var _id = buffer_read(b, buffer_s16);
			with (oController){
				repeat (_b) {
					with (instance_create(0,0,oObstacle)){
						pid = _id;	
					}
				}
			}
			// inform other clients:
	        var p = packet_start(packet_t.controller);
			buffer_write(p, buffer_s16, _b);
			buffer_write(p, buffer_s16, _id);
			packet_send_except(p, from);
	        break;
		case packet_t.obstacle:
	        // update the server-side player instance:
	        var _id = buffer_read(b, buffer_s16);
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        var _vs = buffer_read(b, buffer_s16);
	        var _hs = buffer_read(b, buffer_s16);
			var _rot = buffer_read(b, buffer_s16);
	        with (oObstacle) if (pid == _id) {
	            x = _x;
	            y = _y;
				hspeed = _hs;
				vspeed = _vs;
				image_angle = _rot;
	        }
	        // inform other clients:
	        p = packet_start(packet_t.obstacle);
			buffer_write(p, buffer_s16, _id);
	        buffer_write(p, buffer_f32, _x);
	        buffer_write(p, buffer_f32, _y);
	        buffer_write(p, buffer_s16, _vs);
	        buffer_write(p, buffer_s16, _hs);
			buffer_write(p, buffer_s16, _rot);
	        packet_send_except(p, from);
	        break;
		case packet_t.explosion:
	        // update the server-side player instance:
	        var _x = buffer_read(b, buffer_f32);
	        var _y = buffer_read(b, buffer_f32);
	        instance_create(_x,_y,oExplosion);
			p = packet_start(packet_t.explosion);
	        buffer_write(p, buffer_f32, _x);
	        buffer_write(p, buffer_f32, _y);
			packet_send_except(p, from);
	        break;
	}
}
