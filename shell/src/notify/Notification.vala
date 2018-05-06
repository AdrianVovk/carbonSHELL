public class Notify.Notification : Object {
	public string app_name;
	public uint32 id;
	public string icon;
	public string title;
	public string body;
	public int32 timeout;
	
	public Notify.Action[] actions;

	// Actions

	public Notify.Action? get_action (string action) {
		foreach (Notify.Action act in this.actions) {
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
			this.dismiss (Notify.CloseReason.EXPIRED);
			return false;
		});
	}
	
	public void dismiss (int reason = Notify.CloseReason.DISMISSED) {
		Notify.Server.obtain ().notification_closed (this.id, reason);
	}

	public string to_string () {
		string out = "NOTIFICATION: {\n";
		out += @"\tTITLE: $title\n";
		out += @"\tBODY: $body\n";
		out += @"\tICON: $icon\n";
		out += @"\tAPP: $app_name\n";
		foreach (Notify.Action a in this.actions) out += @"\tACTION: $(a.display)\n";
		out += "}\n";
		return out;
	}

	public void replace (Notify.Notification notif) {
		this.app_name = notif.app_name;
		this.id = notif.id;
		this.icon = notif.icon;
		this.title = notif.title;
		this.body = notif.body;
		this.timeout = notif.timeout;
		this.actions = notif.actions;
		notif.destroy ();
	}
}

public class Notify.Action : Object {
	public string display;
	
	public string action;
	public uint32 notif_id;

	public void invoke () {
		Notify.Server.obtain ().action_invoked (notif_id, action);
	}
}