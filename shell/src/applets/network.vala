class NetworkApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("network-wireless-signal-good-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		button.set_tooltip_text("Networking");
		return button;
	}
	
	protected override void calculate_size (out int width, out int height) {
		width = 350;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		layout.add (create_wifi_tile ("Vovk Household 5G", "good", "network-transmit-receive-symbolic"));
		layout.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
		layout.add (create_wifi_tile ("Vovk Household", "excellent", "network-wireless-encrypted-symbolic"));
		layout.add (create_wifi_tile ("NETGEAR-96", "ok", "network-wireless-encrypted-symbolic"));
		layout.add (create_wifi_tile ("FBI Surveillance Van", "ok", null));
		layout.add (create_wifi_tile ("ATT121", "weak", "network-wireless-encrypted-symbolic"));
		
		return layout;
	}

	private Gtk.Widget create_wifi_tile (string wifi_name, string strength, string status_icon_name) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		Gtk.Image icon = new Gtk.Image.from_icon_name (@"network-wireless-signal-$strength-symbolic", Gtk.IconSize.INVALID);
		icon.pixel_size = 16;
		icon.tooltip_text = "Strength: Good";
		root.pack_start (icon, false); //, true, 8);

		Gtk.Label name = new Gtk.Label (wifi_name);
		root.pack_start (name, false, true, 8);

		if (status_icon_name != null) {
			Gtk.Image status_icon = new Gtk.Image.from_icon_name (status_icon_name, Gtk.IconSize.INVALID);
			status_icon.pixel_size = 12;
			root.pack_end (status_icon, false); //, true, 8);				
		}

		Gtk.Button wrapper = new Gtk.Button ();
		wrapper.get_style_context ().add_class ("flat");
		wrapper.add (root);
		return wrapper;
	}
}