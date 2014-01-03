package uk.co.piggz.pgz_spaceinvaders;
import android.util.Log;

public class MyApplication extends org.qtproject.qt5.android.bindings.QtApplication {
static {
Log.e("My Application Starting", "**********");
System.loadLibrary("scoreloopcore");
}
} 
