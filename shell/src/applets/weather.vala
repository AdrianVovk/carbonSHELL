class WeatherApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("weather-clear-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		button.set_tooltip_text("Weather");
		return button;
	}
	protected override void calculate_size (out int width, out int height) {
		width = 300;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {		
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);	

		// Today's view
		Gtk.Box today = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		today.margin = 4;
		today.tooltip_text = "Now";
		layout.add (today);
		Gtk.Image today_icon = new Gtk.Image.from_icon_name("weather-clear-symbolic", Gtk.IconSize.INVALID);
		today_icon.pixel_size = 38;
		today_icon.margin = 8;
		today.pack_start (today_icon, false);
		Gtk.Label today_info = new Gtk.Label ("<big>Clear, 82°F</big>\n<small>High: 83°, Low: 70°\nCleveland, Ohio</small>");
		today_info.use_markup = true;
		today_info.margin = 4;
		today_info.xalign = 0;
		today.pack_end (today_info);

		layout.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

		// Hourly view
		Gtk.Label hourly_label = new Gtk.Label ("<big>Hourly</big>");
		hourly_label.use_markup = true;
		hourly_label.margin = 4;
		hourly_label.xalign = 0;
		layout.add (hourly_label);
		Gtk.ScrolledWindow hourly_scroller = new Gtk.ScrolledWindow (null, null);
		hourly_scroller.vscrollbar_policy = Gtk.PolicyType.NEVER;
		hourly_scroller.margin = 4;
		layout.add (hourly_scroller);
		Gtk.Box scroll_container_hourly = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		hourly_scroller.add (scroll_container_hourly);
		
		scroll_container_hourly.add (create_upcoming_element ("clear", "16:00", null, 0, 0, 83));
		scroll_container_hourly.add (create_upcoming_element ("clear", "17:00", null, 0, 0, 83));
		scroll_container_hourly.add (create_upcoming_element ("clear", "18:00", null, 0, 0, 82));
		scroll_container_hourly.add (create_upcoming_element ("clear", "19:00", null, 0, 0, 80));
		scroll_container_hourly.add (create_upcoming_element ("clear", "20:00", null, 0, 0, 78));
		scroll_container_hourly.add (create_upcoming_element ("clear-night", "21:00", null, 0, 0, 73));
		scroll_container_hourly.add (create_upcoming_element ("clear-night", "22:00", null, 0, 0, 70));
		scroll_container_hourly.add (create_upcoming_element ("clear-night", "23:00", null, 0, 0, 67));
		scroll_container_hourly.add (create_upcoming_element ("clear-night", "00:00", null, 0, 0, 63));

		layout.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

		// Upcoming view
		Gtk.Label upcoming_label = new Gtk.Label ("<big>This Week</big>");
		upcoming_label.use_markup = true;
		upcoming_label.margin = 4;
		upcoming_label.xalign = 0;
		layout.add (upcoming_label);
		Gtk.ScrolledWindow upcoming_scroller = new Gtk.ScrolledWindow (null, null);
		upcoming_scroller.vscrollbar_policy = Gtk.PolicyType.NEVER;
		upcoming_scroller.margin = 4;
		layout.add (upcoming_scroller);
		Gtk.Box scroll_container_upcoming = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		upcoming_scroller.add (scroll_container_upcoming);
		
		scroll_container_upcoming.add (create_upcoming_element ("clear", "Clear", "Monday (Today)", 70, 83));
		scroll_container_upcoming.add (create_upcoming_element ("showers", "Showers", "Tuesday\n50% Chance", 68, 76));
		scroll_container_upcoming.add (create_upcoming_element ("storm", "Storm", "Wednesday\n77% Chance", 65, 70));
		scroll_container_upcoming.add (create_upcoming_element ("overcast", "Overcast", "Thursday", 67, 74));
		scroll_container_upcoming.add (create_upcoming_element ("windy", "Windy", "Friday", 70, 78));
		scroll_container_upcoming.add (create_upcoming_element ("few-clouds", "Cloudy", "Saturday", 73, 80));
		scroll_container_upcoming.add (create_upcoming_element ("clear", "Clear", "Sunday", 75, 84));

		layout.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

		// Details view
		string details_string = "Precipitation: 0%\nWind: 20 mph NW <big>⬈</big>\nHumidity: 65%";
		Gtk.Label details_label = new Gtk.Label (details_string);
		details_label.use_markup = true;
		details_label.margin = 4;
		details_label.xalign = 0;
		layout.add (details_label);

		layout.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		
		Gtk.Button refresh_button = new Gtk.Button.with_label ("Refresh");
		layout.pack_end (refresh_button);
		
		return layout;
	}

	private Gtk.Button create_upcoming_element (string ico, string desc, string? tooltip, int high, int low, int now = -500) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

		Gtk.Image icon = new Gtk.Image.from_icon_name(@"weather-$ico-symbolic", Gtk.IconSize.INVALID);
		icon.pixel_size = 24;
		icon.margin = 2;
		root.add (icon);

		Gtk.Label status = new Gtk.Label (@"<big>$desc</big>");
		status.use_markup = true;
		root.add (status);

		Gtk.Label high_low = new Gtk.Label (now == -500 ? @"<small>H: $high°, L: $low°</small>" : @"<small>$now°</small>");
		high_low.use_markup = true;
		root.add (high_low);

		Gtk.Button wrapper = new Gtk.Button ();
		wrapper.relief = Gtk.ReliefStyle.NONE; // Hide the border
		if (tooltip != null) wrapper.tooltip_text = tooltip;
		wrapper.add (root);
		return wrapper;
	}
}