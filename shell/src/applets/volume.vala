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
	
	protected override void calculate_size (out int width, out int height) {
		width = 300;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		layout.pack_start (create_slider ("audio-speakers-symbolic", "Speakers", true, true));
		layout.pack_start (create_slider ("audio-headphones-symbolic", "Headphones", false), true, true, 8);
		layout.pack_start (create_slider ("bluetooth-active-symbolic", "Bluetooth", false), true, true, 8);
		
		layout.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

		layout.pack_start (create_playback_details (true, "Awesome Song", "Awesome artist!!!"));

		layout.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

		layout.pack_start (create_slider ("firefox", "Firefox"));
		layout.pack_start (create_slider ("discord", "Discord"));
		layout.pack_start (create_slider ("skypeforlinux", "Skype"));

		return layout;
	}

	private Gtk.Box create_slider (string icon_name, string description , bool isConnected = true,bool isMaster = false /* TODO , Shell.VolumeManager vol*/) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		// Create the icon
		Gtk.Image icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.INVALID);
		icon.pixel_size = 16;
		icon.tooltip_text = description;
		root.pack_start (icon, false, true, 8);

		// Create the slider or not connected message
		if (isConnected) {
			Gtk.Scale slider = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);
			slider.digits = 0;
			slider.draw_value = false;
			slider.margin_right = 8;
			slider.set_value (100);
			if (isMaster) slider.change_value.connect (set_volume);
			root.pack_start (slider);
		} else {
			Gtk.Label not_connected_message = new Gtk.Label ("Not connected");
			not_connected_message.justify = Gtk.Justification.LEFT;
			root.pack_start (not_connected_message, false, true, 8);

			root.sensitive = false;
		}
		
		return root;
	}

	private Gtk.Widget create_playback_details (bool is_active = false, string song_name, string artist_name) {
		if (!is_active) {
			Gtk.Label message = new Gtk.Label ("No music playing");
			message.margin = 4;
			return message;
		}

		Gtk.Box root = new Gtk.Box (Gtk.Orientation.VERTICAL, 8);
		root.margin = 2;

		string art_filename = "/home/adrian/Development/desktop/wallpapers/AlbumArtDemoTemporary.jpg";
		Gdk.Pixbuf art_pixbuf = new Gdk.Pixbuf.from_file_at_size (art_filename, 130, 130);
		Gtk.Image art = new Gtk.Image.from_pixbuf (art_pixbuf);
		root.pack_start (art);
		
		Gtk.Label song = new Gtk.Label (@"<big>$song_name</big>");
		song.use_markup = true;
		root.pack_start (song);
		Gtk.Label artist = new Gtk.Label (artist_name);
		root.pack_start (artist);

		Gtk.ButtonBox actions = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
		Gtk.Button play_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic");
		Gtk.Button next_button = new Gtk.Button.from_icon_name ("media-skip-forward-symbolic");
		Gtk.Button prev_button = new Gtk.Button.from_icon_name ("media-skip-backward-symbolic");
		actions.add (prev_button);
		actions.add (play_button);
		actions.add (next_button);
		root.pack_end (actions);

		return root;
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