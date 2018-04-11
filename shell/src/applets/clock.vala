using Gtk;

class ClockApplet : Gtk.ToggleToolButton {

	string time_fmt = "";

	public ClockApplet() {
		set_tooltip_text("Time and Date");
		time_fmt = create_time_fmt();
		
		update_time();
		Timeout.add(1000, update_time);

		Gtk.Popover panel = new Gtk.Popover(this);
		this.toggled.connect(panel.popup);
		panel.closed.connect(() => this.set_active(false));
		panel.set_constrain_to(Gtk.PopoverConstraint.NONE);
		panel.set_position(Gtk.PositionType.BOTTOM);
//		panel.set_size_request(300, 500);

		Gtk.Calendar cal = new Gtk.Calendar();
		panel.add(cal);
		cal.show_all();
	}

	private bool update_time() {
		this.set_label(new DateTime.now_local().format(time_fmt));
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