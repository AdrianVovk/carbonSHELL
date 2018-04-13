public void override_focus(Gtk.Widget widget) {
	widget.style_updated.connect(() => {
		Gtk.StateFlags flags = ((widget.get_state_flags()) & ~Gtk.StateFlags.BACKDROP);	
		widget.get_style_context().set_state(flags);
	});
	if (widget is Gtk.Container) (widget as Gtk.Container).@foreach(it => override_focus(it));
}

delegate bool SearchPartFunc(string a, string b);
public bool filter_app(DesktopAppInfo app, string query) {
	SearchPartFunc test = (source, search) => {
		return source.ascii_up().contains(search.ascii_up());
	};
	foreach (string keyword in app.get_keywords()) {
		if (test(keyword, query)) return true;
	} 
	return test(app.get_name(), query) ||
		test(app.get_display_name(), query) ||
		test(app.get_executable(), query);
}