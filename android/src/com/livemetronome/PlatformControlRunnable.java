package com.livemetronome;

import android.app.Activity;
import android.view.WindowManager;
import android.util.Log;

public class PlatformControlRunnable implements Runnable
{
    private Activity m_activity;
    private boolean m_keepScreenOn;
    public PlatformControlRunnable(Activity activity, boolean keepScreenOn) {
        m_activity = activity;
        m_keepScreenOn = keepScreenOn;
    }

    // this method is called on Android Ui Thread
    @Override
    public void run() {
        if (m_keepScreenOn)
            m_activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        else
            m_activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }
}
