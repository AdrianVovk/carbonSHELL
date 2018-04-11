// Interop for the vala
#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkwayland.h>

extern void wayfire_ready();
void setup_protocol (GdkDisplay* disp);
void wayfire_set_panel (GdkWindow* window);

// Impl of the protocol
#include "wayfire-shell-client-protocol.h"
#include <wayland-client.h>

struct wayfire_shell* shell_instance;

void registry_add_object(void* _, struct wl_registry *registry, uint32_t name, const char *interface, uint32_t __) {
	if (strcmp(interface, wayfire_shell_interface.name) == 0) {
		g_print("Connecting to Wayfire.\n");
		shell_instance = (struct wayfire_shell*) wl_registry_bind(registry, name, &wayfire_shell_interface, 1u);
		wayfire_ready();
	}
}

void registry_remove_object(void* _, struct wl_registry* __, uint32_t ___)
{
}

static struct wl_registry_listener registry_listener =
{
    &registry_add_object,
    &registry_remove_object
};

void setup_wayfire_connection (GdkDisplay* disp) {
//	gdk_wayland_window_get_wl_surface();
	g_print("Starting Wayfire Shell Service...\n");
	g_return_if_fail (disp != NULL);

	// Register the service
	struct wl_display* display = gdk_wayland_display_get_wl_display(disp);
	struct wl_registry* registry = wl_display_get_registry(display);
	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_roundtrip(display);
	wl_registry_destroy(registry);
}

void wayfire_set_panel(GdkWindow* window)
{
	struct wl_surface* surface = gdk_wayland_window_get_wl_surface(window);
	wayfire_shell_add_panel(shell_instance, NULL, surface);
	wayfire_shell_reserve(shell_instance, NULL, WAYFIRE_SHELL_PANEL_POSITION_UP, gdk_window_get_width(window), gdk_window_get_height(window));
	wayfire_shell_configure_panel(shell_instance, NULL, surface, 0, 0);
}