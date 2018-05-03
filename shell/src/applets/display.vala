class DisplayApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("preferences-desktop-display-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		button.set_tooltip_text("Display");
		return button;
	}
	protected override void calculate_size (out int width, out int height) {
		width = 300;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {		
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		layout.pack_start (create_slider ("display-brightness-symbolic", "Brightness"));

		layout.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));

		Gtk.Box night_light = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		layout.pack_start(night_light, true, true, 4);
		night_light.pack_start(new Gtk.Label("Night Light"), false, true, 8);
		Gtk.Switch night_light_switch = new Gtk.Switch();
		night_light.pack_end(night_light_switch, false, true, 8);

		layout.pack_start (create_slider ("night-light-symbolic", "Warmth"));
	
		return layout;
	}

	private Gtk.Box create_slider (string icon_name, string description) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		// Create the icon
		Gtk.Image icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.INVALID);
		icon.pixel_size = 16;
		icon.tooltip_text = description;
		root.pack_start (icon, false, true, 8);

		// Create the slider or not connected message
		Gtk.Scale slider = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
		slider.digits = 0;
		slider.draw_value = false;
		slider.margin_right = 8;
		slider.set_value (100);
		root.pack_start (slider);

		return root;
	}
}