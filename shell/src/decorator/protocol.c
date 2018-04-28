#include <string.h>
#include <glib.h>
#include <gtk/gtk.h>
#include <gdk/gdkwayland.h>
#include "wf-decorator-client-protocol.h"
#include <wayland-client.h>

// DECORATOR API

extern GtkWidget* create_deco_window (guint32 view);
extern void set_title (guint32 view, const gchar* title);
void setup_protocol (GdkDisplay* disp);

// DECORATOR IMPL

static void create_new_decoration(void *data, struct wf_decorator_manager *manager, uint32_t view)
{
	create_deco_window(view);
}

static void title_changed(void *data, struct wf_decorator_manager *manager, uint32_t view, const char *new_title)
{
	set_title(view, new_title);
}

const struct wf_decorator_manager_listener decorator_listener =
{
    create_new_decoration,
    title_changed
};

// PROTOCOL MANAGEMENT

void registry_add_object(void* _, struct wl_registry *registry, uint32_t name, const char *interface, uint32_t __) 
{
	if (strcmp(interface, wf_decorator_manager_interface.name) == 0) 
	{
		struct wf_decorator_manager* manager = (struct wf_decorator_manager*) wl_registry_bind(registry, name, &wf_decorator_manager_interface, 1u);
		g_print("[Decorator] Connected to Wayfire");
		wf_decorator_manager_add_listener(manager, &decorator_listener, NULL);
	}
}

static struct wl_registry_listener registry_listener =
{
    &registry_add_object,
    NULL
};

void setup_protocol (GdkDisplay* disp) 
{
	g_return_if_fail (disp != NULL);
	
	struct wl_display* display = gdk_wayland_display_get_wl_display(disp);
	struct wl_registry* registry = wl_display_get_registry(display);

	wl_registry_add_listener(registry, &registry_listener, NULL);
	wl_display_roundtrip(display);
	wl_registry_destroy(registry);
}