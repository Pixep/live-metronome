import android.media.SoundPool

public class TickPlayer
{
    static private TickPlayer m_instance;
    static private int MAX_NUMBER_STREAMS = 2;

    private SoundPool m_soundPool;
    private int soundClickLowId = -1;
    private int soundClickHighId = -1;

    static public void instantiate() {
        m_instance = new TickPlayer();
    }

    static public void loadSounds(){
        m_instance.load();
    }

    static public void playTick(bool highPitch) {
        m_instance.play(highPitch);
    }

    public void load() {
        m_soundPool = new SoundPool(MAX_NUMBER_STREAMS,
                                    AudioManager.STREAM_MUSIC,
                                    0);
        m_soundPool.setOnLoadCompleteListener(this);
        soundClickLowId = m_soundPool.load(this, R.raw.click_analog_low, 1);
        soundClickHighId = m_soundPool.load(this, R.raw.click_analog_high, 1);
    }

    public void play(bool highPitch) {
        int soundId = soundClickLowId;

        if (highPitch)
            soundId = soundClickHighId;

        m_soundPool.play(soundId, 1, 1, 1024, 0, 1);
    }
}
