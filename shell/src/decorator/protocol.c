// Interop for the decorator
#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkwayland.h>

// Main
extern GtkWidget* create_deco_window (const gchar* title);
extern void set_title (GtkWidget* window, const gchar* title);
// Utils
extern void map_view_to_decor (guint32 view, GtkWidget* decor);
extern GtkWidget* get_decor_from_view (guint32 view);
extern gchar* gen_initial_title(guint32 id);

void setup_protocol (GdkDisplay* disp);

// Impl of the protocol
#include "wf-decorator-client-protocol.h"
#include <wayland-client.h>

static void create_new_decoration(void *data, struct wf_decorator_manager *manager, uint32_t view) {
	g_print("Decoration requested.\n");
	GtkWidget* window = create_deco_window(gen_initial_title(view));
	map_view_to_decor(view, window);
}

static void title_changed(void *data, struct wf_decorator_manager *manager, uint32_t view, const char *new_title) {
	g_print("Title change requested.\n");
	g_print("Setting title: %s\n", new_title);
	set_title(get_decor_from_view(view), new_title);
}

const struct wf_decorator_manager_listener decorator_listener =
{
    create_new_decoration,
    title_changed
};

void registry_add_object(void* _, struct wl_registry *registry, uint32_t name, const char *interface, uint32_t __) {
	if (strcmp(interface, wf_decorator_manager_interface.name) == 0) {
		g_print("Connecting to Wayfire.\n");
		struct wf_decorator_manager* manager = (struct wf_decorator_manager*) wl_registry_bind(registry, name, &wf_decorator_manager_interface, 1u);
		wf_decorator_manager_add_listener(manager, &decorator_listener, NULL);
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

void setup_protocol (GdkDisplay* disp) {
	g_print("Starting decorator service.\n");
	g_return_if_fail (disp != NULL);
	
	struct wl_display* display = gdk_wayland_display_get_wl_display(disp);
	struct wl_registry* registry = wl_display_get_registry(display);

	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_roundtrip(display);
	wl_registry_destroy(registry);
}