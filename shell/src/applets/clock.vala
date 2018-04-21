using Gtk;

const string[] CLOCKS = {
	"America/New_York",
	"America/Los_Angeles",
	"Europe/Berline",
	"Europe/Moscow",
	"Pacific/Fiji"
};

class ClockApplet : Applet {
	Gtk.ToggleToolButton clock;
	string time_fmt = "";

	protected override Gtk.Widget create_panel_widget() {
		clock = new Gtk.ToggleToolButton();
		time_fmt = create_time_fmt();

		// Setup the time
		update_time();
		Timeout.add(1000, update_time);
		
		return clock;
	}

	protected override void calculate_size (out int width, out int height) {
		width = 300;
		height = -1;
	}
		
	protected override Gtk.Widget? populate_popup () {
		Gtk.Box layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

		bool first = true;
		foreach (string zone in CLOCKS) {
			if (!first) layout.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
			first = false;

			layout.pack_start (create_world_clock (zone));
		}

		return layout;
	}

	private Gtk.Widget create_world_clock (string timezone) {
		
		DateTime now = new DateTime.now (new TimeZone (timezone));
		string time = now.format (create_time_fmt (true));
		string date = now.format ("%x");
		string location = timezone.substring (timezone.last_index_of ("/") + 1).replace ("_", " ");

		Gtk.Box time_layout = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Gtk.Label time_label = new Gtk.Label (@"<big>$time</big>");
		time_label.use_markup = true;
		time_layout.pack_start (time_label);
		time_layout.pack_end (new Gtk.Label (location));
		time_layout.margin = 8;
		return time_layout;
	}

	private bool update_time() {
		DateTime now = new DateTime.now_local();
		clock.set_label(now.format(time_fmt));
		clock.set_tooltip_text(now.format("%x"));
		override_focus(clock);
		update_popup ();
		return Source.CONTINUE;
	}

	private string create_time_fmt(bool no_day = false) {
		// TODO: Settings
		bool militaryTime = true;
		bool seconds = false;
		
		StringBuilder fmt = new StringBuilder();
		if (!no_day) fmt.append("%a ");
		if (militaryTime) fmt.append("%H"); else fmt.append("%I");
		fmt.append(":%M");
		if (seconds) fmt.append(":%S");
		if (!militaryTime) fmt.append(" %p");
		return fmt.str;
	}
}