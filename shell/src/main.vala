using Gtk;

class ShellApplication : Gtk.Application {
	private static bool version = false; // If we should just check the version and return
	private const OptionEntry[] options = {
		// {"long_name", 'short_char', 0, OptionArg, ref state_variable, "What we do here", "EXAMPLE"},
		{ "version", 'v', 0, OptionArg.NONE, ref version, "Display version number", null },
		{ "volup", 'u', 0, OptionArg.NONE, null, "Bump up the volume and show a popup", null },
		{ "voldown", 'd', 0, OptionArg.NONE, null, "Bump down the volume and show a popup", null },
		{ "volmute", 'm', 0, OptionArg.NONE, null, "Mute the volume and show a popup", null },
		{ "wallpaper", 'w', 0, OptionArg.STRING, null, "Create a wallpaper window", null},
		{ "no-protos", 0, 0, OptionArg.NONE, null, "Disable the dependency on Wayfire's protocols", null },
		{ null }
	};

	private bool panel_open = false;
	private bool wall_open = false;
	
	public ShellApplication() {
		Object(
			application_id: "substos.Shell",
			flags: ApplicationFlags.HANDLES_COMMAND_LINE
		);
		this.add_main_option_entries(options);
	}

	// Process arguments and start the panel
	protected override int command_line(ApplicationCommandLine command_line) {
		VariantDict options = command_line.get_options_dict();
		bool volup = options.lookup_value("volup", VariantType.BOOLEAN).get_boolean();
		bool voldown = options.lookup_value("voldown", VariantType.BOOLEAN).get_boolean();
		bool volmute = options.lookup_value("volmute", VariantType.BOOLEAN).get_boolean();
		bool no_protos = options.lookup_value("no-protos", VariantType.BOOLEAN).get_boolean();
		string wallpaper = options.lookup_value("wallpaper", VariantType.STRING).get_string();

		if (!no_protos) {
			Gdk.Display disp = Gdk.Display.get_default();
			setup_wayfire_connection(disp);
		} else print("Skipping Wayfire connection\n");
		
		if (volup) { // Volume up requested
			if (!panel_open) {
				command_line.printerr("ERROR: There are no panels running");
				return 1;
			}
			command_line.print("Volume Up");
			return 0;
		} else if (voldown) { // Volume down requested
			if (!panel_open) {
				command_line.printerr("ERROR: There are no panels running");
				return 1;
			}
			command_line.print("Volume Down");
			return 0;
		} else if (volmute) { // Volume down requested
			if (!panel_open) {
				command_line.printerr("ERROR: There are no panels running");
				return 1;
			}
			command_line.print("Volume Mute");
			return 0;
		} else if (wallpaper != null) {
			if (wall_open) {
				command_line.printerr("ERROR: A wallpaper is already running.");
				return 1;
			}
			command_line.print("Opening wallpaper: " + wallpaper);
			this.hold();
			BackgroundWindow window = new BackgroundWindow(this, wallpaper);
			window.show_all();
			if (!no_protos) set_wallpaper(window);
			return 0;
		} else { // Open the panel by default
			if (panel_open) {
				command_line.printerr("ERROR: A panel is already running.");
				return 1;
			}
			command_line.print("Starting panel...");
			this.hold();
			PanelWindow window = new PanelWindow(this);
			window.show_all();
			if (!no_protos) set_panel(window);
			return 0;
		}
	}

	protected override void window_added(Gtk.Window win) {
		if (win is PanelWindow) panel_open = true;
		else if (win is BackgroundWindow) wall_open = true;
	}

	protected override void window_removed(Gtk.Window win) {
		if (win is PanelWindow) panel_open = false;
		else if (win is BackgroundWindow) wall_open = false;
		if (!panel_open && !wall_open) this.release();
	}
	
	// Process arguments locally
	protected override int handle_local_options(VariantDict options) {
		if (version) {
			string gtk_ver = @"$(Gtk.get_major_version()).$(Gtk.get_minor_version()).$(Gtk.get_micro_version())";
			print("Panel Version: %s\nGTK Version: %s\n", "0.0.0", gtk_ver);
			return 0;
		}
		return -1;
	}

	public static int main(string[] args) {
		return new ShellApplication().run(args);
	}
}