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

	protected override void calculate_size (out int width, out int height) {
		width = 350;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {		

		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		layout.pack_start (create_notification ("firefox", "Firefox", "A test notification"));
		layout.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		layout.pack_start (create_notification ("discord", "Discord: #linux", "Dan: Hello world"));
		layout.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		layout.pack_start (create_notification ("skypeforlinux", "Skype", "Missed call from Grandpa"));
		
		Gtk.Button clear_all_button = new Gtk.Button.with_label ("Clear All");
		layout.pack_end (clear_all_button);
		layout.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		
		return layout;
	}

	private Gtk.Widget create_notification (string icon_name, string app_name, string desc, string[]? actions = null) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		Gtk.Image icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.INVALID);
		icon.pixel_size = 24;
		root.pack_start (icon, false);

		Gtk.Box details = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
		root.pack_start (details, true, true, 12);

		Gtk.Label name = new Gtk.Label (@"<big>$app_name</big>");
		name.use_markup = true;
		name.xalign = 0;
		details.pack_start (name);

		Gtk.Label app_message = new Gtk.Label (desc);
		app_message.xalign = 0;
		details.pack_start (app_message, false, false);
		
		Gtk.Button wrapper = new Gtk.Button ();
		wrapper.get_style_context ().add_class ("flat");
		wrapper.add (root);
		wrapper.clicked.connect (it => show_notification_details (app_name, desc, icon_name, actions));
		return wrapper;
	}

	private void show_notification_details (string title, string message, string icon_name, string[] actions = null) {
		Gtk.Dialog dialog = new Gtk.MessageDialog (null, Gtk.DialogFlags.DESTROY_WITH_PARENT, Gtk.MessageType.OTHER, Gtk.ButtonsType.CLOSE, message);
		dialog.title = title;
		dialog.icon_name = icon_name;
		dialog.window_position = Gtk.WindowPosition.CENTER;
		dialog.show_all();
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