package com.livemetronome;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import org.qtproject.qt5.android.bindings.QtActivity;

public class MainActivity extends QtActivity
{
    static private MainActivity m_instance;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        m_instance = this;
    }

    public void onDestroy() {
        m_instance = null;

        super.onDestroy();
    }

    static public void setKeepScreenOn(boolean screenOn)
    {
        if (m_instance == null)
            return;

        // Qt is running on a different thread than Android.
        // In order to register the receiver we need to execute it in the Android UI thread
        m_instance.runOnUiThread(new PlatformControlRunnable(m_instance, screenOn));
    }

    static public void enableKeepScreenOn()
    {
        setKeepScreenOn(true);
    }

    static public void disableKeepScreenOn()
    {
        setKeepScreenOn(false);
    }
}
