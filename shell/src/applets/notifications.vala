using Gtk;

class NotificationApplet : Gtk.ToggleToolButton {
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
}