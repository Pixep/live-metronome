package org.qtproject.example;
import android.media.SoundPool;
import android.media.AudioManager;
import android.app.Activity;
import java.lang.reflect.Field;
import java.util.Map;
import java.lang.Exception;
import android.util.Log;

public class TickPlayer implements SoundPool.OnLoadCompleteListener
{
    static private TickPlayer m_instance;
    static private int MAX_NUMBER_STREAMS = 2;

    private SoundPool m_soundPool;
    private int soundClickLowId = -1;
    private int soundClickHighId = -1;

    static public void instantiate() {
        Log.d("LOL", "Toto5A");
        m_instance = new TickPlayer();
        m_instance.loadSounds();
        Log.d("LOL", "TotoB");
    }

    public static Activity getActivity() {
        try {
            Class activityThreadClass = Class.forName("android.app.ActivityThread");
            Object activityThread = activityThreadClass.getMethod("currentActivityThread").invoke(null);
            Field activitiesField = activityThreadClass.getDeclaredField("mActivities");
            activitiesField.setAccessible(true);

            Map<Object, Object> activities = (Map<Object, Object>) activitiesField.get(activityThread);
            if(activities == null)
                return null;

            for (Object activityRecord : activities.values()) {
                Class activityRecordClass = activityRecord.getClass();
                Field pausedField = activityRecordClass.getDeclaredField("paused");
                pausedField.setAccessible(true);
                if (!pausedField.getBoolean(activityRecord)) {
                    Field activityField = activityRecordClass.getDeclaredField("activity");
                    activityField.setAccessible(true);
                    Activity activity = (Activity) activityField.get(activityRecord);
                    return activity;
                }
            }
        }
        catch(Exception e) {
        }
        return null;
    }

    static public void playTick() {
        m_instance.play(true);
    }

    public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
    }

    public void loadSounds() {
        Activity currentActivity = getActivity();
        if (currentActivity == null)
            return;

        m_soundPool = new SoundPool(MAX_NUMBER_STREAMS, AudioManager.STREAM_MUSIC, 0);
        m_soundPool.setOnLoadCompleteListener(this);
        soundClickLowId = m_soundPool.load(currentActivity, R.raw.click_analog_low, 1);
        soundClickHighId = m_soundPool.load(currentActivity, R.raw.click_analog_low5, 1);
    }

    public void play(boolean highPitch) {
        int soundId = soundClickLowId;

        if (highPitch)
            soundId = soundClickHighId;

        m_soundPool.play(soundId, 1, 1, 1024, 0, 1);
    }
}
