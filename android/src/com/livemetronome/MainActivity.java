package com.livemetronome;

import android.media.SoundPool;
import android.media.AudioManager;
import android.app.Activity;
import android.view.WindowManager;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.util.Log;

import org.qtproject.qt5.android.bindings.QtActivity;

public class MainActivity extends QtActivity implements SoundPool.OnLoadCompleteListener
{
    static private MainActivity m_instance;
    static private int MAX_NUMBER_STREAMS = 1;

    private SoundPool m_soundPool;
    private int soundClickLowId = -1;
    private int soundClickHighId = -1;
    private int soundClickLowStreamId = -1;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        m_instance = this;
        loadSounds();
    }

    public void onDestroy() {
        m_instance = null;

        super.onDestroy();
    }

    static public void playTick() {
        if (m_instance != null)
            m_instance.play(true);
    }

    public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
    }

    public void loadSounds() {
        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            AudioAttributes audioAttrib = new AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_GAME)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setFlags(AudioAttributes.FLAG_LOW_LATENCY)
                    .build();
            m_soundPool = new SoundPool.Builder().setAudioAttributes(audioAttrib).setMaxStreams(3).build();
        }
        else {*/
            m_soundPool = new SoundPool(MAX_NUMBER_STREAMS, AudioManager.STREAM_MUSIC, 0);
        //}

        m_soundPool.setOnLoadCompleteListener(this);

        soundClickLowId = m_soundPool.load(this, R.raw.click_analog_low6, 1);
        //soundClickHighId = m_soundPool.load(this, R.raw.click_analog_low5, 1);
    }

    public void play(boolean highPitch) {
        int soundId = soundClickLowId;

        if (highPitch)
            soundId = soundClickHighId;

        if (soundClickLowStreamId >= 0)
            m_soundPool.stop(soundClickLowStreamId);

        soundClickLowStreamId = m_soundPool.play(soundId, 1, 1, 1024, 0, 1);
    }
}
