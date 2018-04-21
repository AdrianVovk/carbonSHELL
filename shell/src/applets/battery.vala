class BatteryApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("battery-full-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		button.set_tooltip_text("Battery");
		return button;
	}
	protected override void calculate_size (out int width, out int height) {
		width = 300;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {		
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		
		Gtk.Label status = new Gtk.Label("<span font='15' weight=\"bold\">96% Remaining</span>");
		status.use_markup = true;
		layout.pack_start(status, true, true, 4);

		layout.pack_start(new Gtk.Separator(Gtk.Orientation.HORIZONTAL));

		Gtk.Box pwr_save = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		layout.pack_start(pwr_save, true, true, 4);
		pwr_save.pack_start(new Gtk.Label("Power Saver"), false, true, 8);
		Gtk.Switch pwr_save_switch = new Gtk.Switch();
		pwr_save.pack_end(pwr_save_switch, false, true, 8);
	
		return layout;
	}
}