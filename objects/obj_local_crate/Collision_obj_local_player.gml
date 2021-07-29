if (other.key_attack2) && (open == false){
	with (instance_create(x, y, o_local_pickup)){
		selectpickup(choose(1,2,3));
	}
	open = true;
	with (oCrate) if (pid = other.id){
		open = true;
	}
}