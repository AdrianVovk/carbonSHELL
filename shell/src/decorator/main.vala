using Gtk;

Gee.HashMap<uint32, Gtk.Window> view_to_decor;

public int main (string[] args) {
	message ("Hello");

	// Set a variable that the protocol will need in a little bit
	view_to_decor = new Gee.HashMap<uint32, Gtk.Window> ();
	
	Gtk.Application app = new Gtk.Application ("carbon.shell.Decorator", ApplicationFlags.FLAGS_NONE);
	app.startup.connect (activated_app => {
		setup_protocol (Gdk.Display.get_default());		
		activated_app.hold (); // Don't quit the program
	});
	app.activate.connect (activated_app => {
		print("Service is running.\n");
	});
	return app.run (args);
}

public Gtk.Widget create_deco_window (uint32 view) {
	print (@"Creating decoration for $view");

	Gtk.Window decor = new Gtk.Window ();
	decor.set_default_size (300, 300);

	// Connect the decoration to the view
	decor.set_title (@"__wf_decorator:$view");
	view_to_decor.@set (view, decor);

	decor.show_all ();
	return decor;
}

public void set_title (uint32 view, string title) {
	print (@"Changing title of $view to \"$title\"");
	
	Gtk.Window win = view_to_decor.@get (view);
	win.title = title;
}

extern void setup_protocol (Gdk.Display disp);