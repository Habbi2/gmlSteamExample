if (open == true) {
	cd--;
}

if (cd < 0){
	open = false;
	with (oCrate) if (pid = other.id) open = false;
	cd = 400;
}
