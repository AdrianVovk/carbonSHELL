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
		//Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);	
		Gtk.Label message = new Gtk.Label ("Coming Soon");
		message.margin = 8;
		return message;
	}
}