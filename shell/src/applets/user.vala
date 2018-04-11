using Gtk;
using Act;

class UserApplet : Gtk.ToggleToolButton {
	public UserApplet() {
		Act.UserManager manager = Act.UserManager.get_default();	

		Gtk.Image icon = new Gtk.Image.from_icon_name("avatar-default-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		this.set_icon_widget(icon);
		set_tooltip_text("Session");

		Gtk.Popover panel = new Gtk.Popover(this);
		this.toggled.connect(panel.popup);
		panel.closed.connect(() => this.set_active(false));
		panel.set_constrain_to(Gtk.PopoverConstraint.NONE);
		panel.set_position(Gtk.PositionType.BOTTOM);
		panel.set_size_request(300, 500);

		manager.notify["is-loaded"].connect(() => {
			foreach (Act.User usr in manager.list_users()) {
				print(usr.user_name);
			}
			
			Act.User user = manager.get_user(Environment.get_user_name());
			string profile_picture = user.get_icon_file();
			if (profile_picture != null) icon.set_from_pixbuf(new Gdk.Pixbuf.from_file_at_size(profile_picture, 24, 24));
			if (user.real_name != null) this.set_tooltip_text(user.real_name);
		});
	}
}