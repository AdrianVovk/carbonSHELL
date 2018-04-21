	using Gtk;

const bool APPS_GRID = true;

class AppsListApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton launcher = new Gtk.ToggleToolButton();
		Gtk.Image apps_icon = new Gtk.Image.from_icon_name(APPS_GRID ? "view-app-grid-symbolic" : "open-menu-symbolic", Gtk.IconSize.INVALID);
		apps_icon.set_pixel_size(24);
		launcher.set_icon_widget(apps_icon);
		launcher.set_tooltip_text("Applications");
		return launcher;
	}

	protected override void calculate_size (out int width, out int height) {
		width = APPS_GRID ? 700 : 400;
		height = 500;
	}

	protected override Gtk.Widget? populate_popup () {
		// The root contents of the popup
		Gtk.Box panel_layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		// The scrolling contents of the popup
		Gtk.ScrolledWindow apps_scroller = new Gtk.ScrolledWindow(null, null);
		apps_scroller.set_policy(Gtk.PolicyType.EXTERNAL, Gtk.PolicyType.AUTOMATIC);

		// The grid/list for the apps
		Gtk.FlowBox apps_container = new Gtk.FlowBox();
		apps_container.selection_mode = Gtk.SelectionMode.NONE;
		apps_container.orientation = Gtk.Orientation.HORIZONTAL;
		apps_container.homogeneous = true;
		if (!APPS_GRID) apps_container.max_children_per_line = 1;
		apps_scroller.add(apps_container);

		// Search box
		string query = "";
		Gtk.SearchEntry search_box = new Gtk.SearchEntry();
		search_box.search_changed.connect(() => {
			query = search_box.get_text();
			apps_container.invalidate_filter();
		});
		search_box.activate.connect(() => {
			// TODO: Run the first item
		});
		this.popup.closed.connect(() => search_box.set_text(""));

		// Filter functionality
		apps_container.set_filter_func(elem => {
			DesktopAppInfo app = elem.get_data<DesktopAppInfo>("app_details");
			return filter_app(app, query);
		});

		for_each_app(app => {
			// Create the icon/name layout combo
			Gtk.Box app_info = new Gtk.Box(APPS_GRID ? Gtk.Orientation.VERTICAL : Gtk.Orientation.HORIZONTAL, 16);
			Gtk.Image icon = new Gtk.Image.from_gicon(app.get_icon(), Gtk.IconSize.INVALID);
			icon.set_pixel_size(APPS_GRID ? 48 : 24);
			Gtk.Label name = new Gtk.Label(APPS_GRID ? app.get_name() : app.get_display_name());
			name.set_ellipsize(Pango.EllipsizeMode.END);
			name.set_lines(1);
			if (APPS_GRID) name.set_max_width_chars(15);
			app_info.pack_start(icon, false);
			app_info.pack_start(name, false);

			// Create the launch button
			Gtk.Button launcher = new Gtk.Button();
			launcher.relief = Gtk.ReliefStyle.NONE; // Hide the border
			launcher.add(app_info);
			launcher.clicked.connect(() => {
				launch(app);
				this.popup.popdown();
			});

			// Setup details tooltip
			string description = app.get_description().replace("&", "&amp;");
			if (description != null && description.length > 0) description = "\n" + description;
			string tooltip = @"<b>$(app.get_display_name())</b>$description";
			launcher.tooltip_markup = tooltip;

			Gtk.FlowBoxChild wrapper = new Gtk.FlowBoxChild();
			wrapper.add(launcher);
			wrapper.set_data<DesktopAppInfo>("app_details", app); // For use in filter/sort
			apps_container.add(wrapper); // Add the item to the grid/list
		});

		panel_layout.pack_start(search_box, false);
		panel_layout.pack_start(apps_scroller, true);
		return panel_layout;
	}
}