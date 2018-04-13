abstract class Applet {
	private Gtk.Popover popup;

	protected abstract Gtk.Widget create_panel_widget();

	protected abstract Gtk.Popover? create_popup(Gtk.Widget attach_to);

	public virtual Gtk.Widget create() {
		Gtk.Widget widget = create_panel_widget();
		popup = create_popup(widget);
		if (popup != null) {
			popup.constrain_to = Gtk.PopoverConstraint.NONE;
			popup.position = Gtk.PositionType.BOTTOM;
		}
		if (widget is Gtk.ToggleToolButton) {
			Gtk.ToggleToolButton button = widget as Gtk.ToggleToolButton;
			button.toggled.connect(() => {
				if (button.active) popup.popup();
			});
			popup.closed.connect(() => button.set_active(false));
		}
		return widget;
	}

	public virtual void collapse() {
		print(popup.has_grab().to_string() + "\n\n\n");
		//if (popup != null) popup.popdown();
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