private PanelWindow panel_window;
void set_panel(PanelWindow window) {
	panel_window = window;
}

// Called when the connection to Wayfire is successful
void wayfire_ready() {
	wayfire_set_panel(panel_window.get_window());
}

extern void setup_wayfire_connection(Gdk.Display disp);
extern void wayfire_set_panel(Gdk.Window window);