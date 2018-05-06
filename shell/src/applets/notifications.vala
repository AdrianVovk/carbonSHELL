using Gtk;

class NotificationApplet : Applet {
	protected override Gtk.Widget create_panel_widget() {
		Gtk.ToggleToolButton button = new Gtk.ToggleToolButton();
		Gtk.Image icon = new Gtk.Image.from_icon_name("preferences-system-notifications-symbolic", Gtk.IconSize.INVALID);
		icon.set_pixel_size(16);
		button.set_icon_widget(icon);
		
		button.set_tooltip_text("Notifications");
		return button;
	}

	protected override void calculate_size (out int width, out int height) {
		width = 350;
		height = -1;
	}

	private HashTable<uint32, Gtk.Revealer> id_to_item;		
	protected override Gtk.Widget? populate_popup () {		
		Gtk.Box layout = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

		Gtk.Revealer clear_revealer = new Gtk.Revealer ();
		clear_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_UP;
		clear_revealer.transition_duration = 500;
		Gtk.Button clear_all_button = new Gtk.Button.with_label ("Clear All");
		clear_all_button.clicked.connect (() => {
			id_to_item.foreach ((id, view) => {
				var notification = Notify.Server.obtain ().get_notification (id);
				notification.dismiss ();
			});
			clear_revealer.reveal_child = false;
		});
		clear_revealer.add (clear_all_button);
		clear_revealer.reveal_child = false;
		layout.pack_end (clear_revealer);

		Gtk.Box dnd_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		layout.pack_end (dnd_box, true, true, 4);
		dnd_box.pack_start (new Gtk.Label ("Do Not Disturb"), false, true, 8);
		Gtk.Switch dnd_switch = new Gtk.Switch ();
		dnd_box.pack_end (dnd_switch, false, true, 8);

		Notify.Server notifications = Notify.Server.obtain ();
		id_to_item = new HashTable<uint32, Gtk.Revealer> (null, null);
		
		notifications.notif_added.connect (notif => {
			Gtk.Box combination = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
			combination.add (create_notification (notif));
			combination.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));

			Gtk.Revealer anim = new Gtk.Revealer ();
			anim.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
			anim.transition_duration = 500;
			anim.add (combination);
			
			layout.pack_start (anim);
			layout.show_all (); // Render the views

			id_to_item.replace (notif.id, anim);

			
			clear_revealer.reveal_child = true;
			anim.reveal_child = true;

			notif.thaw_notify (); // Render the contents of the notification
			notif.start_timeout (); // Start counting down for when the notification will close
		});
		notifications.invoke_added ();

		notifications.notification_closed.connect ((id, reason) => {			
			var anim = id_to_item.lookup (id);
			anim.reveal_child = false;
			if (id_to_item.size () - 1 == 0) clear_revealer.reveal_child = false;
			Timeout.add (anim.transition_duration, () => {
				anim.destroy ();
				id_to_item.remove (id);
				return false;
			});
		});
		
		return layout;
	}

	private Gtk.Widget create_notification (Notify.Notification notif) {
		Gtk.Box root = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		Gtk.Image icon = new Gtk.Image ();
		icon.icon_size = Gtk.IconSize.INVALID;
		icon.pixel_size = 24;
		icon.set_size_request (24, 24);
		notif.bind_property ("icon", icon, "icon-name");
		root.pack_start (icon, false);

		Gtk.Box details = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
		root.pack_start (details, true, true, 12);

		Gtk.Label title = new Gtk.Label (null);
		notif.notify["title"].connect (() => {
			title.label = @"<big>$(notif.title)</big>";
		});
		title.use_markup = true;
		title.xalign = 0;
		details.pack_start (title);

		Gtk.Label body = new Gtk.Label (null);
		body.use_markup = true;
		body.xalign = 0;
		notif.bind_property ("body", body, "label");
		details.pack_start (body, false, false);
		
		Gtk.Button wrapper = new Gtk.Button ();
		wrapper.get_style_context ().add_class ("flat");
		wrapper.add (root);
		wrapper.clicked.connect (it => notif.invoke_action ("default"));
		return wrapper;
	}

	private void show_notification_details (Notify.Notification notif) {
		/*
		Gtk.Dialog dialog = new Gtk.MessageDialog (null, Gtk.DialogFlags.DESTROY_WITH_PARENT, Gtk.MessageType.OTHER, Gtk.ButtonsType.CLOSE, message);
		dialog.title = title;
		dialog.icon_name = icon_name;
		dialog.window_position = Gtk.WindowPosition.CENTER;
		dialog.show_all();
		*/
	}
}