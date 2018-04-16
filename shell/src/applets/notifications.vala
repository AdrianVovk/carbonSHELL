using Gtk;

class NotificationApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("preferences-system-notifications-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		
		button.set_tooltip_text("Notifications");
		return button;
	}

	protected override Gtk.Popover? create_popup(Gtk.Widget attach_to) {
		Gtk.Popover panel = new Gtk.Popover(attach_to);
		panel.set_size_request(350, 600);

		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		Gtk.Box header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		layout.pack_start(header, false);
		Gtk.Label header_name = new Gtk.Label("<span size=\"x-large\" weight=\"bold\">Notifications</span>");
		header_name.use_markup = true;
		header.pack_start(header_name, false, true, 4);
		Gtk.Button clear_button = new Gtk.Button.with_label("Clear All");
		header.pack_end(clear_button, false, true, 4);
		
		panel.add(layout);
		layout.show_all();
		return panel;
	}
}

/*class NotificationApplet : Gtk.ToggleToolButton {
	public NotificationApplet() {
		Gtk.Image icon = new Gtk.Image.from_icon_name("preferences-system-notifications-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		this.set_icon_widget(icon);
		set_tooltip_text("Notifications");

		Gtk.Popover panel = new Gtk.Popover(this);
		this.toggled.connect(panel.popup);
		panel.closed.connect(() => this.set_active(false));
		panel.set_constrain_to(Gtk.PopoverConstraint.NONE);
		panel.set_position(Gtk.PositionType.BOTTOM);
		panel.set_size_request(300, 500);
	}
}*/