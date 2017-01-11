#include <gtk/gtk.h>

static void destroy(GtkWidget *widget, gpointer data)
{
  gtk_main_quit();
}

int main(int argc, char *argv[])
{
  GtkWidget *window;
  GtkWidget *label;
  
  gtk_init(&argc, &argv);
  
  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  label = gtk_label_new("Hello, World!");
  gtk_container_add (GTK_CONTAINER (window), label);
  gtk_widget_show (label);
  gtk_widget_show(window);
  
  g_signal_connect (G_OBJECT (window), "destroy", G_CALLBACK (destroy), NULL);
  gtk_main();

  return 0;
}
