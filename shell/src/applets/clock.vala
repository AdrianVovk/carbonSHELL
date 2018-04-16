using Gtk;

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

	protected override Gtk.Popover? create_popup(Gtk.Widget attach_to) {
		Gtk.Popover panel = new Gtk.Popover(attach_to);

		Gtk.Calendar cal = new Gtk.Calendar();
		panel.add(cal);
		cal.show_all();
		
		return panel;
	}

	private bool update_time() {
		DateTime now = new DateTime.now_local();
		clock.set_label(now.format(time_fmt));
		clock.set_tooltip_text(now.format("%x"));
		override_focus(clock);
		return Source.CONTINUE;
	}

	private string create_time_fmt() {
		// TODO: Settings
		bool militaryTime = true;
		bool seconds = false;
		
		StringBuilder fmt = new StringBuilder();
		fmt.append("%a ");
		if (militaryTime) fmt.append("%H"); else fmt.append("%I");
		fmt.append(":%M");
		if (seconds) fmt.append(":%S");
		if (!militaryTime) fmt.append(" %p");
		return fmt.str;
	}
}