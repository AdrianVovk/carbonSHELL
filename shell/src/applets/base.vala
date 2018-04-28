abstract class Applet {
	protected Gtk.Widget panel_widget;
	protected Gtk.Popover popup = null;
	protected bool popup_open = false;

	protected abstract Gtk.Widget create_panel_widget();

	protected abstract Gtk.Widget? populate_popup ();

	protected abstract void calculate_size (out int width, out int height);

	public virtual Gtk.Widget create() {
	    panel_widget = create_panel_widget();

 		setup_popup (panel_widget);
	    
		if (panel_widget is Gtk.ToggleToolButton && this.popup != null) {
			Gtk.ToggleToolButton button = panel_widget as Gtk.ToggleToolButton;
			button.toggled.connect (() => {
				if (button.active) open_popup ();
			});
			popup.closed.connect (() => {
				button.set_active (false);
				popup_open = false;
			});
		}
		return panel_widget;
	}

	public virtual void open_popup () {
		if (popup != null) popup.popup ();
		popup_open = true;
	}

	public virtual void close_popup () {
		if (popup != null) popup.popdown ();
		popup_open = false;
	}

	public virtual void toggle_popup () {
		if (popup_open) close_popup (); else open_popup ();
	}

	protected virtual void setup_popup (Gtk.Widget attach_to) {
		Gtk.Widget popup_contents = populate_popup ();
		if (popup_contents == null) return;
		
		Gtk.Popover popover = new Gtk.Popover (attach_to);

		int width;
		int height;
		calculate_size (out width, out height);
		popover.set_size_request(width, height);

		popover.constrain_to = Gtk.PopoverConstraint.NONE;
		popover.position = Gtk.PositionType.BOTTOM;

		popup_contents.show_all ();
		popover.add (popup_contents);

		this.popup = popover;
	}

	public virtual void update_popup () {
		if (popup == null) return;
		Gtk.Widget popup_contents = populate_popup ();
	    if (popup_contents != null) {
			Gtk.Widget old_contents = popup.get_child ();
			popup.remove (old_contents);
			old_contents.destroy ();
	    	
			popup_contents.show_all ();
	  		popup.add (popup_contents);
	    }
	}
	
	public virtual void collapse() {
		if (popup != null) popup.popdown();
	}
}

class SeparatorApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		return new Gtk.Separator(Gtk.Orientation.VERTICAL);
	}

	protected override void calculate_size (out int width, out int height) {
		width = 0;
		height = 0;
	}

	protected override Gtk.Widget? populate_popup () {
		return null;
	}
}

/*
class AppletBox : Applet { //TODO
	override Gtk.Widget create_panel_widget() {
		return new Gtk.Button.with_label("TODO");
	}

	override Gtk.Popover? create_popup() {
		return null;
	}

	override Gtk.Widget create() {
		return create_panel_widget();
	}
}*/