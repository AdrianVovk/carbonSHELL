[DBus (name = "org.freedesktop.Notifications")]
public class Notify.Server : Object {
	private static Server? instance = null;

	[DBus (visible = false)]
	public static Server obtain () {
		if (instance == null) {
			instance = new Server ();
			Bus.own_name (BusType.SESSION, "org.freedesktop.Notifications", BusNameOwnerFlags.NONE,
						  connection => {
						  	try {
						  		connection.register_object ("/org/freedesktop/Notifications", instance);
						  	} catch (Error e) {
						  		error ("NOTIFY: %s\n", e.message);
						  	}
						  },
						  null, () => error ("NOTIFY: Failed to aquire name\n"));
		}
		return instance;
	}

	private Server () {
		this.notifications = new GenericArray<Notification>();
		notification_closed.connect (handle_notification_closed);

		foreach (Notification n in Persist.obtain ().load ()) {
			this.add_notification (n, true);
		}
	}

	// NOTIFICATION MANAGEMENT

	private GenericArray<Notification> notifications;

	[DBus (visible = false)]
	public Notification? get_notification (uint32 id, out uint index = null) {
		Notification? out = null;
		notifications.foreach (notif => {
			if (notif.id == id) out = notif;
		});
		return out;
	}

	[DBus (visible = false)]
	public void add_notification (Notification notif, bool nopersist = false) {
		var old = this.get_notification (notif.id);
		if (old != null) {
			old.replace (notif);
		} else notifications.add (notif);
		notif_added (notif);
		if (!nopersist) Persist.obtain ().update ();
	}

	[DBus (visible = false)]
	public void handle_notification_closed (uint32 id, uint32 reason) {
		var notification = this.get_notification (id);
		if (notification != null) {
			notifications.remove (notification);
			curr_id = notification.id; // Search for new ID from here
			notification.unref ();
			Persist.obtain ().update ();
		}
	}

	
	private uint32 curr_id = 1;
	private uint32 generate_new_id () {
		if (curr_id == int.MAX) curr_id = 1; // Just in case it rolls over
		for (uint32 id = curr_id; id <= int.MAX; id++) {
			if (get_notification (id) == null) {
				curr_id = id;
				return id;
			}
		}
		error ("Notify.Server: ID Generation error\n");
		return -2;
	}

	[DBus (visible = false)]
	public Notification[] get_all () {
		return notifications.data;
	}

	[DBus (visible = false)]
	public void invoke_added () {
		notifications.foreach (it => notif_added (it));
	}

	[DBus (visible = false)]
	public signal void notif_added (Notification notif);

	// PROTOCOL

	public string[] get_capabilities () {
		string[] abilities = {};
		abilities += "body";
		abilities += "body-markup";
		abilities += "icon-static";
		abilities += "actions";
		abilities += "persistence";
		return abilities;
	}

	// NOTE: Capital name here so it doesn't conflict with GObject's notify.
	public uint32 Notify (string app_name,
						  uint32 replaces_id,
						  string app_icon,
						  string summary,
						  string body,
						  string[] actions,
						  HashTable<string, Variant> hints,
						  int32 expire_timeout) {
		
		// Create a notification object
		Notification n = new Notification ();
		n.freeze_notify ();
		n.app_name = app_name;
		n.id = replaces_id == 0 ? generate_new_id () : replaces_id;
		n.icon = app_icon;
		n.title = summary;
		n.body = body;
		n.timeout = expire_timeout;
		n.transient = hints.lookup ("transient").get_boolean ();
		
		// Populate the actions
		Action[] temp = {};
		Action? action = null;
		for (int i = 0; i < actions.length; i += 2) {
			if (i % 2 == 0) { // We have a new action
				action = new Action ();
				action.action = actions[i];
				action.notif_id = n.id;
			} else { // The action is created; commit it.
				action.display = actions[i];
				temp += action;
				action = null;
			}
		}
		n.actions = temp;

		add_notification (n);
		return n.id;
	}

	public void close_notification (uint32 id) {
		notification_closed (id, CloseReason.SELF);
	}

	public void get_server_information (out string name,
									  out string vendor,
									  out string version,
									  out string spec_version) {
		name = "carbonSHELL-notify";
		vendor = "carbonSHELL";
		version = "0.0.0";
		spec_version = "1.2";
	}

	public signal void notification_closed (uint32 id, uint32 reason);

	public signal void action_invoked (uint32 id, string action_key);
}

public enum CloseReason {
	EXPIRED = 1,
	DISMISSED = 2,
	SELF = 3,
	UNDEFINED = 4
}