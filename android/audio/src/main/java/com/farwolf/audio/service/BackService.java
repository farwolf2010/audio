package com.farwolf.audio.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;

public class BackService extends Service {
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        String url=intent.getStringExtra("url");
        MusicService.getService().setUrl(url);
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        String url=intent.getStringExtra("url");
        MusicService.getService().setUrl(url);
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }
}
