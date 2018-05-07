class Notify.Persist : Object {
	private static Persist? instance = null;
	public static Persist obtain () {
		if (instance == null) instance = new Persist ();
		return instance;
	}

	public void update () {
		try {
			File file = File.new_for_path (Path.build_filename (Environment.get_user_cache_dir (), "carbon-notifications.json"));
			DataOutputStream output = new DataOutputStream (file.replace (null, false, FileCreateFlags.NONE));
			foreach (Notification n in Server.obtain ().get_all ()) {
				if (!n.transient) output.put_string (n.to_string () + "\n");
			}
		} catch (Error e) {
			warning ("Failed to save notifications\n");
		}
	}

	public Notification[] load () {
		Notification[] out = {};
		try {
			File file = File.new_for_path (Path.build_filename (Environment.get_user_cache_dir (), "carbon-notifications.json"));
			DataInputStream input = new DataInputStream (file.read ());
			string? line = null;
			while ((line = input.read_line ()) != null) {
				warning (line);
				
				var notification = Notification.from_data (line);
				out += notification;
			}
		} catch (Error e) {
			warning ("Failed to load notifications\n");
		}
		return out;
	}
}