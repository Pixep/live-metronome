import android.util.Log;

public class MainThing {
    static private final String TAG = "Metronome";

    static public String test() {
        String a = "Robert";
        String b = a;
        Log.d(TAG, "Toto");
        return a;
    }
}
