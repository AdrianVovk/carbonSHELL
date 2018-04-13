using Gtk;

class PanelWindow : Gtk.ApplicationWindow {
	Applet[] bar_items = {
		new AppsListApplet()
	};
	
	public PanelWindow(ShellApplication this_app) {
		Object(application: this_app);
		
		// Display Geometry
		int displayWidth = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().width;
		int displayHeight = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().height;
	
		// Create the bar
		Gtk.HeaderBar bar = new Gtk.HeaderBar();
		this.add(bar);

		// Add content to the panel
		populate_bar(bar);

		// Misc setup
		this.set_default_size(displayWidth, -1);
        this.set_decorated(false);
        this.set_resizable(false);
        override_focus(this);
	}

	private void populate_bar(Gtk.HeaderBar bar) {
		// Start of the panel (adds left -> right)

		// DE controls
		bar.pack_start(bar_items[0].create());
		//bar.pack_start(new ExpoLauncher()); TODO
		//bar.pack_start(new CurrentAppMenu()); TODO
		bar.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL));
	
		// Launchers
		bar.pack_start(new AppLauncher.from_id("org.gnome.Nautilus"));
		bar.pack_start(new AppLauncher.from_id("org.gnome.Epiphany"));
		bar.pack_start(new AppLauncher.from_id("org.gnome.Terminal"));

		// Currently running apps
/*		bar.pack_start(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		Gtk.Box running_apps = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
		bar.pack_start(running_apps);
		watch_running((app) => { // Populate
			running_apps.add(new AppLauncher.from_app(app));
		}, () => { // Reset
			running_apps.@foreach((it) => {it.destroy();});
		});*/

		// End of the panel (adds right -> left)

		// Status controls		
		bar.pack_end(new UserApplet());
		bar.pack_end(new Gtk.Separator(Gtk.Orientation.VERTICAL));
		bar.pack_end(new ClockApplet());
		//bar.pack_end(new BatteryApplet()); TODO
		bar.pack_end(new NetworkApplet());
		//bar.pack_end(new VolumeApplet()); TODO
		bar.pack_end(new NotificationApplet());
		//bar.pack_end(new CaffineApplet()); TODO
		//bar.pack_end(new WeatherApplet()); TODO
		bar.pack_end(new Gtk.Separator(Gtk.Orientation.VERTICAL));

		// Extra status icons
		// TODO
	}

	public override bool focus_out_event(Gdk.EventFocus event) {
		print("[Panel] Lost focus. Collapsing all popovers.\n");
		foreach (Applet applet in bar_items) applet.collapse();
		return false;
	}
}