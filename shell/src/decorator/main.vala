using Gtk;

public int main(string[] args) {
	//print("Starting SubstOS Decorator Service...\n");

	// Set a variable that the protocol will need in a little bit
	view_to_decor = new Gee.HashMap<uint32, Gtk.Widget>();
	
	Gtk.Application app = new Gtk.Application("subsos.shell.Decorator", ApplicationFlags.FLAGS_NONE);
	app.startup.connect((activated_app) => {
		Gdk.Display disp = Gdk.Display.get_default();
		setup_protocol(disp);
		
		activated_app.hold();
	});
	app.activate.connect((activated_app) => {
		print("Service is running.\n");
	});
	return app.run(args);
}

// External API

public Gtk.Widget create_deco_window(string title) {
	Gtk.Window window = new Gtk.Window();
	window.set_default_size(300, 300);
	window.set_title(title);
	window.show_all();
	return window;
}

public void set_title(Gtk.Widget window, string title) {
	(window as Gtk.Window).set_title(title);
}

extern void setup_protocol(Gdk.Display disp);