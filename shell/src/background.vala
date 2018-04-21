class BackgroundWindow : Gtk.ApplicationWindow {
	public BackgroundWindow(ShellApplication this_app, string image) {
		Object(application: this_app);
	
		// Display Geometry
		int displayWidth = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().width;
		int displayHeight = Gdk.Display.get_default().get_monitor_at_window(this.get_window()).get_geometry().height;

		Gtk.Revealer animator = new Gtk.Revealer ();
		Gtk.Image wallpaper = new Gtk.Image.from_pixbuf(new Gdk.Pixbuf.from_file_at_scale(image, displayWidth, displayHeight, false));
		animator.add (wallpaper);
		animator.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
		animator.transition_duration = 700;
		animator.reveal_child = true;
		this.add (animator);

		GLib.Menu model = new GLib.Menu();

		SimpleAction change_wallpaper_action = new SimpleAction ("chwall", null);
		change_wallpaper_action.activate.connect (param => {
			Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog ("Select a wallpaper", this, Gtk.FileChooserAction.OPEN,
				"_Cancel", Gtk.ResponseType.CANCEL, "_Open", Gtk.ResponseType.ACCEPT);
			Gtk.FileFilter filter = new Gtk.FileFilter ();
			chooser.filter = filter;
			filter.add_mime_type ("image/jpeg");
			filter.add_mime_type ("image/png");

			// Process response:
			if (chooser.run () == Gtk.ResponseType.ACCEPT) {
				File file = chooser.get_file ();
				chooser.close ();
				
				animator.reveal_child = false;
				Timeout.add (animator.transition_duration, () => {
					Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (file.get_path (), displayWidth, displayHeight, false);
					wallpaper.set_from_pixbuf (pixbuf);
					animator.reveal_child = true;
					return false;
				});
			}
		});
		this.add_action (change_wallpaper_action);
		model.append ("Change Wallpaper", "win.chwall");
		
		model.append("Display Settings", null);

		
		Gtk.Menu menu = new Gtk.Menu.from_model(model);
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