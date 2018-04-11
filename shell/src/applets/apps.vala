using Gtk;

const bool APPS_GRID = true;

class AppsMenu : Gtk.ToggleToolButton {
	public AppsMenu() {
		// Setup the button
		Gtk.Image apps_icon = new Gtk.Image.from_icon_name(APPS_GRID ? "view-app-grid-symbolic" : "open-menu-symbolic", Gtk.IconSize.INVALID);
		apps_icon.set_pixel_size(24);
		this.set_icon_widget(apps_icon);
		this.set_tooltip_text("Applications");

		AppsPopup popup = new AppsPopup(this); // Attatch a popover
		AppInfoMonitor.@get().changed.connect(() => {
			popup.destroy();
			popup = new AppsPopup(this);
		});
	}	
}

class AppsPopup : Gtk.Popover {
	public AppsPopup(Gtk.ToggleToolButton attach) {
		// Setup the popup
		Gtk.Popover panel = new Gtk.Popover(attach);
		attach.toggled.connect(panel.popup);
		panel.closed.connect(() => attach.set_active(false));
		panel.set_constrain_to(Gtk.PopoverConstraint.NONE);
		panel.set_modal(true);
		panel.set_position(Gtk.PositionType.BOTTOM);
		panel.set_size_request(APPS_GRID ? 700 : 400, 500);
		Gtk.Box panel_layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0); // The content of the popup
		panel.add(panel_layout);
		Gtk.ScrolledWindow apps_scroller = new Gtk.ScrolledWindow(null, null);
		apps_scroller.set_policy(Gtk.PolicyType.EXTERNAL, Gtk.PolicyType.AUTOMATIC);
	
		// The apps Grid
		Gtk.FlowBox apps_grid = new Gtk.FlowBox();
		apps_grid.set_selection_mode(Gtk.SelectionMode.NONE);
		apps_grid.set_orientation(Gtk.Orientation.HORIZONTAL);
		apps_grid.set_homogeneous(true);
		apps_grid.child_activated.connect((child) => stderr.printf("temp\n"));
		apps_scroller.add(apps_grid);
		if (!APPS_GRID) apps_grid.set_max_children_per_line(1);
		for_each_app((desktop) => {
			// Setup the text to show
			string description = desktop.get_description().replace("&", "&amp;");
			if (description != null && description.length > 0) description = "\n" + description;
			string tooltip = @"<b>$(desktop.get_display_name())</b>$description";
	
			// Create the icon and the label for each app
			Gtk.Box icon_and_name = new Gtk.Box(APPS_GRID ? Gtk.Orientation.VERTICAL : Gtk.Orientation.HORIZONTAL, 16);
			Gtk.Image icon = new Gtk.Image.from_gicon(desktop.get_icon(), Gtk.IconSize.INVALID);
			icon.set_pixel_size(APPS_GRID ? 48 : 24);
			Gtk.Label name = new Gtk.Label(APPS_GRID ? desktop.get_name() : desktop.get_display_name());
			name.set_ellipsize(Pango.EllipsizeMode.END);
			name.set_lines(1);
			if (APPS_GRID) name.set_max_width_chars(15);
			icon_and_name.pack_start(icon, false);
			icon_and_name.pack_start(name, false);
	
			Gtk.Button launcher = new Gtk.Button();
			launcher.set_relief(Gtk.ReliefStyle.NONE); // Hide the Button's border
			launcher.set_tooltip_markup(tooltip); // Create a tooltip with the app's full name and descriptiong
			launcher.add(icon_and_name);
			launcher.clicked.connect(() => { // Launch the app on click
				launch(desktop);
				panel.popdown();
			});
	
			// Setup the FlowBoxChild wrapper
			Gtk.FlowBoxChild flow_child = new Gtk.FlowBoxChild();
			flow_child.add(launcher);
			flow_child.set_data<DesktopAppInfo>("app_details", desktop); // Allow fetching app info for search
			apps_grid.add(flow_child); // Add the item to the grid/list
		});
	
		// Search and run
		Gtk.Label run_message = new Gtk.Label("Press Enter to run a command");
		string query = "";
		Gtk.SearchEntry search = new Gtk.SearchEntry();
		search.search_changed.connect(() => {
			query = search.get_text();
			apps_grid.invalidate_filter();
			if (query != "") run_message.show(); else run_message.hide();
		});
		search.activate.connect(() => {
			// TODO: Run the first result
			Process.spawn_async(null, query.split(" "), null, SpawnFlags.SEARCH_PATH, null, null);
			search.set_text("");
			panel.popdown();
		});
		apps_grid.set_filter_func((elem) => {
			DesktopAppInfo app = elem.get_data<DesktopAppInfo>("app_details");
			bool name_match = app.get_name().ascii_up().contains(query.ascii_up());
			bool display_name_match = app.get_display_name().ascii_up().contains(query.ascii_up());
			bool exec_match = app.get_executable().ascii_up().contains(query.ascii_up());
			foreach (string keyword in app.get_keywords()) {
				if (keyword.ascii_up().contains(query.ascii_up())) return true;
			}
			return name_match || display_name_match || exec_match;
		});
	
		// Show the content of the panel
		panel_layout.pack_start(search, false);
		panel_layout.pack_start(apps_scroller, true);
		panel_layout.pack_end(run_message, false);
		panel_layout.show_all(); // Get content to show up in the popup. IDK why this is necessary
		run_message.hide();
	}
}