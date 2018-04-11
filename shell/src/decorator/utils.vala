Gee.HashMap<uint32, Gtk.Widget> view_to_decor;

void map_view_to_decor(uint32 view, Gtk.Widget decor) {
	view_to_decor.@set(view, decor);
}

Gtk.Widget get_decor_from_view(uint32 view) {
	return view_to_decor.@get(view);
}

string gen_initial_title(uint32 view) {
	return @"__wf_decorator:$view";
}