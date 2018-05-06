[DBus (name = "org.freedesktop.Notifications")]
public class Notify.Server : Object {
	private uint32 curr_id = 1;

	private static Notify.Server? instance = null;
	public static Notify.Server obtain () {
		if (instance == null) {
			instance = new Notify.Server ();
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

	private Notify.Server () {
		notification_closed.connect (handle_notification_closed);
	}

	// NOTIFICATION MANAGEMENT

	Notify.Notification[] notifications = {};

	public Notify.Notification? get_notification (uint32 id) {
		foreach (Notify.Notification notif in notifications) {
			if (notif.id == id) return notif;
		}
		return null;
	}

	public void add_notification (Notify.Notification notif) {
		var old = this.get_notification (notif.id);
		if (old != null) {
			old.replace (notif);
		} else {
			notifications += notif;
			curr_id++;
		}
	}

	public void handle_notification_closed (uint32 id, uint32 reason) {
		this.get_notification (id).destroy ();
	}

	// PROTOCOL

	public string[] get_capabilities () {
		string[] abilities = {};
		abilities += "body";
		abilities += "body-markup";
		abilities += "icon-static";
		abilities += "actions";
		return abilities;
	}

	public uint32 notify (string app_name,
						  uint32 replaces_id,
						  string app_icon,
						  string summary,
						  string body,
						  string[] actions,
						  HashTable<string, Variant> hints,
						  int32 expire_timeout) {
		
		// Create a notification object
		Notify.Notification n = new Notification ();
		n.app_name = app_name;
		n.id = replaces_id == 0 ? curr_id : replaces_id;
		n.icon = app_icon;
		n.title = summary;
		n.body = body;
		n.timeout = expire_timeout;
		
		// Populate the actions
		Notify.Action[] temp = {};
		Notify.Action? action = null;
		for (int i = 0; i < actions.length; i += 2) {
			if (i % 2 == 0) { // We have a new action
				action = new Notify.Action ();
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
		notification_closed (id, Notify.CloseReason.SELF);
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

public enum Notify.CloseReason {
	EXPIRED = 1,
	DISMISSED = 2,
	SELF = 3,
	UNDEFINED = 4
}