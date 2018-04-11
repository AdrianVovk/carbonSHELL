using Gtk;

public static int main(string[] args) {
    Gtk.init(ref args);
    new SimpleWindow();
    Gtk.main();
	return 0;
}

class SimpleWindow : Gtk.Window {
	public SimpleWindow() {
		destroy.connect(Gtk.main_quit);
		show_all();
	}
}