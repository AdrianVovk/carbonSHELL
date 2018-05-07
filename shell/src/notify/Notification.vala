public class Notify.Notification : Object {
	public string app_name {set; get;}
	public uint32 id {set; get;}
	public string icon {set; get;}
	public string title {set; get;}
	public string body {set; get;}
	public int32 timeout {set; get;}
	public bool transient {set; get;}
	
	public Action[] actions {set; get;}

	// Actions

	public Action? get_action (string action) {
		foreach (Action act in this.actions) {
			if (act.action == action) return act;
		}
		return null;
	}

	public void invoke_action (string action) {
		this.get_action (action).invoke ();
	}

	// Dismiss and timeout

	public void start_timeout () {
		if (timeout == 0) return;		
		int real_timeout = timeout;
		Timeout.add (timeout != -1 ? timeout : 10000, () => {
			this.dismiss (CloseReason.EXPIRED);
			return false;
		});
	}
	
	public void dismiss (int reason = CloseReason.DISMISSED) {
		Server.obtain ().notification_closed (this.id, reason);
	}

	public string to_string () {
		var node = Json.gobject_serialize(this);
		return Json.to_string (node, false);
	}

	public static Notification from_data (string data) {
		var out = new Notification ();
		out.freeze_notify ();
		out.replace (Json.gobject_from_data (typeof (Notification), data) as Notification);
		return out;
	}

	public void replace (Notification notif) {
		this.app_name = notif.app_name;
		this.id = notif.id;
		this.icon = notif.icon;
		this.title = notif.title;
		this.body = notif.body;
		this.timeout = notif.timeout;
		this.transient = notif.transient;
		this.actions = notif.actions;
		notif.unref ();
	}
}

public class Notify.Action : Object {
	public string display {set; get;}	
	
	public string action {set; get;}
	public uint32 notif_id;

	public void invoke () {
		Server.obtain ().action_invoked (notif_id, action);
	}
}