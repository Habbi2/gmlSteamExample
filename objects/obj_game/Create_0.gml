players = ds_map_create();
var users = obj_steam.net_list;

//instance_create(x, y, oController);
var p = instance_create(room_width/2,room_height/2, oPlayer);
with (p){
    user = obj_steam.user;
	with (obj_game) {
		ds_map_add(players,obj_steam.user ,obj_steam.user);
	}
	with (instance_create_layer(x,y, "Weapons" ,oShotgun)){
		user = obj_steam.user;	
	}
}

var n = ds_list_size(users);
for (var i = 0; i < n; i++) {
	with (instance_create_layer(x, y, "Player", obj_cursor)) {
	    user = users[|i];
	}
	with (instance_create_layer(x, y, "Weapons", obj_shotgun)){
		user = users[|i];	
	}
}


// spawn player cursors:
//var users = obj_steam.net_list;
//var n = ds_list_size(users);
//for (var i = 0; i < n; i++){
//	var p2 = instance_create(x, y, oPlayer);
//	with (p2){
//        user = users[|i];
//		number = i;
//		with (obj_game) ds_map_add(players, users[|i], users[|i]);
//    }
//	with (instance_create(x, y, oWeapon)){
//		user = users[|i];
//	}
//}
// just a hint:
chat_add("Click to move around!");

