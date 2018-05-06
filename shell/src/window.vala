using Gtk;

class PanelWindow : Gtk.ApplicationWindow {
	Applet[] bar_start_items = { // Adds left -> right
		new AppsListApplet(),
		// new ExpoApplet(),
		// new CurrentAppMenuApplet(),
		new SeparatorApplet()
	};

	Applet[] bar_end_items = { // Adds right -> left
		new ClockApplet(),
		new SeparatorApplet(),
//		new UserApplet(), DISABLED
		new NotificationApplet(),
		new BatteryApplet(),
		new NetworkApplet(),
		new VolumeApplet(),
		// new CaffineApplet(),
		new DisplayApplet(),
		new WeatherApplet(),
		// new LanguageApplet(),
		new SeparatorApplet()
	};

	Gtk.HeaderBar tempBar = null;
	public PanelWindow(ShellApplication this_app) {
		Object(application: this_app);
		
		// Display Geometry
		int displayWidth = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().width;
		int displayHeight = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().height;
	
		// Create the bar
		Gtk.HeaderBar bar = new Gtk.HeaderBar();
		this.tempBar = null;
		this.add(bar);

		// Add static content to the panel
		foreach (Applet applet in bar_start_items) bar.pack_start(applet.create());
		foreach (Applet applet in bar_end_items) bar.pack_end(applet.create());

		// Add app launchers
		bar.pack_start(new AppLauncher.from_id("org.gnome.Nautilus"));
		bar.pack_start(new AppLauncher.from_id("org.gnome.Epiphany"));
		bar.pack_start(new AppLauncher.from_id("org.gnome.Terminal"));
		bar.pack_start(new AppLauncher.from_id("com.gexperts.Tilix"));

		// Misc setup
		this.set_default_size(displayWidth, -1);
        this.set_decorated(false);
        this.set_resizable(false);
        this.accept_focus = true;
        override_focus(this);
	}

	public void open_menu () {
		steal_focus ();
		bar_start_items[0].toggle_popup ();
	}

//	public override bool button_press_event (Gdk.EventButton evt) {
//		this.focus_visible = false;
//		this.set_focus_child (null);
//		return true;
//	}

	public override bool focus_out_event(Gdk.EventFocus event) {
		print("[Panel] Lost focus. Collapsing all popovers.\n");
		foreach (Applet applet in bar_start_items) applet.collapse();
		foreach (Applet applet in bar_end_items) applet.collapse();

		// Reset focus
		this.focus_visible = false;
		this.set_focus_child (null);
		
		return false;
	}
}