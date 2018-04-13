class BackgroundWindow : Gtk.ApplicationWindow {
	public BackgroundWindow(ShellApplication this_app, string image) {
		Object(application: this_app);
	
		// Display Geometry
		int displayWidth = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().width;
		int displayHeight = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().height;

		Gtk.Image wallpaper = new Gtk.Image.from_pixbuf(new Gdk.Pixbuf.from_file_at_scale(image, displayWidth, displayHeight, false));
		this.add(wallpaper);

		this.set_events(Gdk.EventMask.BUTTON_PRESS_MASK);

		GLib.Menu model = new GLib.Menu();
		model.append("Change Wallpaper", null);
		model.append("Display Settings", null);
		Gtk.Menu menu = new Gtk.Menu.from_model(model);
//		Gtk.MenuItem item_change_wallpaper = new Gtk.MenuItem.with_label("Change Wallpaper");
//		menu.append(item_change_wallpaper);
		menu.attach_to_widget(wallpaper, null);
		this.button_press_event.connect(event => {
			if (event.button == Gdk.BUTTON_SECONDARY) {
				menu.popup_at_pointer(event);
				return true;
			} else return false;
		});

		this.set_decorated(false);
		this.set_default_size(displayWidth, displayHeight);
		this.set_resizable(false);
	}
}