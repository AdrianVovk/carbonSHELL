public string? extract_icon_name(DesktopAppInfo desktop) {
	Icon icon = desktop.get_icon();
	if (icon is ThemedIcon) {
		return string.joinv(";;", ((ThemedIcon) icon).get_names()).replace("(null);;", "");
	} else if (icon is FileIcon) {
		return ((FileIcon) icon).get_file().get_path();
	} else return null;
}

public delegate void AppForEachLambda(DesktopAppInfo info);
public delegate void ResetLambda();

public void for_each_app(AppForEachLambda fun) {
	List<AppInfo> apps = AppInfo.get_all();
	foreach (unowned AppInfo app in apps) if (app.should_show()) fun(new DesktopAppInfo(app.get_id()));
}

public void launch(DesktopAppInfo app, string? action = null) {
	try {
		AppLaunchContext ctx = Gdk.Display.get_default().get_app_launch_context();
		if (action != null) 
			app.launch_action(action, ctx); 
		else
			app.launch(null, ctx);
	} catch (Error e) {
		stderr.printf("Failed to launch app: %s\n", app.get_id());
		stderr.printf("\tError Message: %s\n", e.message);
	}
}
/*
public void watch_running(AppForEachLambda create, ResetLambda reset) {
	File list = File.new_for_path("/tmp/wayfire-app-list"); //Path.build_filename("tmp", "wayfire-app-list"));
	FileMonitor observer = list.monitor_file(FileMonitorFlags.NONE);
	print(observer.cancelled.to_string());
	observer.changed.connect((src, dest, evt) => {
		print("Changed");
		parse_running_file(src, create, reset);
	});

	parse_running_file(list, create, reset);
}

private void parse_running_file(File input, AppForEachLambda create, ResetLambda reset) {
	try {
		reset();

		string line;
		DataInputStream dis = new DataInputStream(input.read());
		while ((line = dis.read_line()) != null) {
			string app_cli = line.split("app_id: ")[1].split(" title:")[0];
			for_each_app((desktop) => {
				//TODO: UGLY!
				if (desktop.get_executable().contains(app_cli) || app_cli.contains(desktop.get_executable())) create(desktop);
			});
		}
	} catch (Error e) {
		stdout.printf("Error: %s\n", e.message);
	}
}
*/