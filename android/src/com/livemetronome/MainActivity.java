package com.livemetronome;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

// Qt
import org.qtproject.qt5.android.bindings.QtActivity;

// Crashlytics
import io.fabric.sdk.android.Fabric;
import com.crashlytics.android.Crashlytics;
import com.crashlytics.android.ndk.CrashlyticsNdk;

public class MainActivity extends QtActivity
{
    static private MainActivity m_instance;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics(), new CrashlyticsNdk());
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
