using Gtk;

class AppLauncher : Gtk.ToolButton {
	public AppLauncher.from_app(DesktopAppInfo app) {
		Gtk.Image icon = new Gtk.Image.from_gicon(app.get_icon(), Gtk.IconSize.INVALID);
		icon.set_pixel_size(24);
		this.set_icon_widget(icon);
		this.set_tooltip_text(app.get_display_name());
		this.clicked.connect(() => launch(app));
	}

	public AppLauncher.from_id(string app_id) {
		this.from_app(new DesktopAppInfo(app_id + ".desktop"));
	}
}