class VolumeApplet : Applet {
	Gtk.Image icon;
	Gtk.ToggleToolButton button;
	double level;
	
	protected override Gtk.Widget create_panel_widget() {
		button = new Gtk.ToggleToolButton();
		icon = new Gtk.Image();
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		update_ui(100);
//		button.set_tooltip_text("Volume");
		return button;
	}
	
	protected override Gtk.Popover? create_popup(Gtk.Widget attach_to) {
		Gtk.Popover panel = new Gtk.Popover(attach_to);
		panel.set_size_request(300, -1);

//		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
//		panel.add(layout);

		Gtk.Scale slider = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 1);
//		layout.pack_start(slider, true);
		slider.change_value.connect(set_volume);
		slider.digits = 0;
		slider.value_pos = Gtk.PositionType.BOTTOM;
		slider.format_value.connect(value => {
			return @"$value% Volume";
		});
		panel.add(slider);

		slider.show_all();
		//layout.show_all();
		return panel;
	}

	private void update_ui(double value) {
		string level;
		if (value <= 0.5)
			level = "muted";
		else if (value <= 33)
			level = "low";
		else if (value <= 66)
			level = "medium";
		else
			level = "high";
		icon.set_from_icon_name(@"audio-volume-$level-symbolic", Gtk.IconSize.INVALID);
		button.set_tooltip_text(@"Volume: $(Math.round(value))%");
	}

	private bool set_volume(Gtk.ScrollType type, double value) {
		update_ui(value);
		return false;
	}

//	private double get_current_volume() {
//		return 0.5;
//	}
}