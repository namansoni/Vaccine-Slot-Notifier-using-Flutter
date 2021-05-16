package com.example.vaccineslotreminder;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.vaccineslotreminder.data.MyDbHandler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    String CHANNEL="Alarm";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL)
                .setMethodCallHandler((call,result)->{
                    if(call.method.equals("startAlarm")){
                        MyDbHandler dbHandler=new MyDbHandler(MainActivity.this);
                    }
                    if(call.method.equals("getAllReminders")){
                        MyDbHandler dbHandler=new MyDbHandler(MainActivity.this);
                        List<Map<String,String>> remindersList=dbHandler.getAllReminders();

                        for(int i=0;i<remindersList.size();i++){
                            System.out.println(remindersList.get(i).get("id"));
                        }
                    }
                    if(call.method.equals("startAlarm")){
                        Intent intent=new Intent(this,MyAlarmBroadcastReceiver.class);
                        PendingIntent pendingIntent=PendingIntent
                                .getBroadcast(this.getApplicationContext(),24345,intent,0);
                        AlarmManager alarmManager=(AlarmManager)getSystemService(ALARM_SERVICE);
                        alarmManager
                                .setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,3000,pendingIntent);

                    }

                });
    }
}
