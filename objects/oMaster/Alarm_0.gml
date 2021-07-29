randomize();

var spriteW = sprite_get_width(Block);
var currentPosX = location[index][0]
var currentPosY = location[index][1]

if (count mod 30 == 0){
	for (var i = 0; i < 11; i++){
		instance_create_depth(currentPosX+spriteW/2+i*spriteW, currentPosY, -1, oBlock);
		instance_create_depth(currentPosX+spriteW/2+i*spriteW, currentPosY-spriteW, -1, oBlock);
	}
}

index++;

var prevPosX = location[index-1][0]
var prevPosY = location[index-1][1]

location[index][0] = prevPosX+spriteW;
location[index][1] = prevPosY+choose(-16,16);

if (array_length(location) == 11) {
	var l1 = location[8]
	var l2 = location[9]
	var l3 = location[10]
	location = [l1, l2, l3]
	index = 2;
}

count++;
alarm[0] = 3;