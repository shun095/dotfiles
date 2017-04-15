#include <gtk/gtk.h>
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libatk-1.0-0.dll")
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libgdk_pixbuf-2.0-0.dll")
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libgio-2.0-0.dll")
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libglib-2.0-0.dll")
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libgobject-2.0-0.dll")
//#pragma comment(lib, "C:/MinGW/msys/1.0/gtk3/bin/libpango-1.0-0.dll")
int main(int argc, char *argv[])
{
        GtkWidget *dialog;
        gtk_init(&argc, &argv);
        dialog = gtk_message_dialog_new(
                NULL,
                GTK_DIALOG_DESTROY_WITH_PARENT, 
                GTK_MESSAGE_OTHER,
                GTK_BUTTONS_OK,
                "Hello!"
        );
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
        return 0;
}
