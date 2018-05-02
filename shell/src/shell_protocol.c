// Interop for the vala
#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkwayland.h>

// PID
#include <sys/types.h>
       #include <unistd.h>

extern void on_wayfire_ready();
void setup_protocol (GdkDisplay* disp);
void wayfire_set_panel (GdkWindow* window);
void wayfire_set_background (GdkWindow* window);
gboolean is_wayfire_ready ();

// Impl of the protocol
#include "wayfire-shell-client-protocol.h"
#include <wayland-client.h>

struct wayfire_shell* shell_instance;
struct wl_surface* panel_surface;
uint32_t panel_height;

static void output_created(void *data, struct wayfire_shell *shell, uint32_t output, uint32_t width, uint32_t height)
{
	g_print("Output Created\n");
}

static void output_resized(void *data, struct wayfire_shell *shell, uint32_t output, uint32_t width, uint32_t height)
{
	g_print("Output Resized\n");
}

static void output_destroyed(void *data, struct wayfire_shell *shell, uint32_t output)
{
	g_print("Output Destroyed\n");
}

static void output_autohide_panels(void *data, struct wayfire_shell *shell, uint32_t output, uint32_t autohide)
{
	if (autohide)
		wayfire_shell_configure_panel(shell_instance, NULL, panel_surface, 0, 0 - panel_height);
	else
		wayfire_shell_configure_panel(shell_instance, NULL, panel_surface, 0, 0);
}

static void gamma_size(void *data, struct wayfire_shell *shell, uint32_t output, uint32_t size)
{
	g_print("Gamma Size\n");
}

const struct wayfire_shell_listener shell_listener =
{
	output_created,
	output_resized,
	output_destroyed,
	output_autohide_panels,
	gamma_size
};

void registry_add_object(void* _, struct wl_registry *registry, uint32_t name, const char *interface, uint32_t __) {
	if (strcmp(interface, wayfire_shell_interface.name) == 0) {
		shell_instance = (struct wayfire_shell*) wl_registry_bind(registry, name, &wayfire_shell_interface, 1u);
		wayfire_shell_add_listener(shell_instance, &shell_listener, NULL);
		on_wayfire_ready();
		g_print("[Shell] Connected to Wayfire\n");
	}
}

static struct wl_registry_listener registry_listener =
{
    &registry_add_object,
    NULL
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

gboolean is_wayfire_ready()
{
	return shell_instance != NULL;
}


void wayfire_set_panel(GdkWindow* window)
{
	struct wl_surface* surface = gdk_wayland_window_get_wl_surface(window);
	panel_surface = surface;
	wayfire_shell_add_panel(shell_instance, 0, surface);
	panel_height = gdk_window_get_height(window);
	wayfire_shell_reserve(shell_instance, NULL, WAYFIRE_SHELL_PANEL_POSITION_UP, gdk_window_get_width(window), panel_height);
	wayfire_shell_configure_panel(shell_instance, NULL, surface, 0, 0);
}

void wayfire_set_background(GdkWindow* window)
{
	struct wl_surface* surface = gdk_wayland_window_get_wl_surface(window);
	wayfire_shell_add_background(shell_instance, 0, surface, 0, 0);
}

void wayfire_focus_panel()
{
	wayfire_shell_focus_panel(shell_instance, 0, panel_surface);
}

void wayfire_unfocus_panel()
{
	wayfire_shell_return_focus(shell_instance, 0);
}