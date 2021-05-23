package com.dorona.vaccineslotreminder;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.PowerManager;
import android.provider.Settings;

import androidx.annotation.NonNull;

import com.dorona.vaccineslotreminder.data.MyDbHandler;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    String CHANNEL = "Alarm";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("getAllReminders")) {
                        MyDbHandler dbHandler = new MyDbHandler(MainActivity.this);
                        List<Map<String, String>> remindersList = dbHandler.getAllReminders();

                        for (int i = 0; i < remindersList.size(); i++) {
                            System.out.println(remindersList.get(i).get("id"));
                        }
                    }
                    if (call.method.equals("startAlarm")) {
//                        Intent intent=new Intent(this,MyAlarmBroadcastReceiver.class);
//                        PendingIntent pendingIntent=PendingIntent
//                                .getBroadcast(this.getApplicationContext(),24345,intent,0);
//                        AlarmManager alarmManager=(AlarmManager)getSystemService(ALARM_SERVICE);
//                        alarmManager
//                                .setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+1000,3000,pendingIntent);
                        MyDbHandler dbHandler = new MyDbHandler(MainActivity.this);

                        Intent intent1 = new Intent(this, MyAlarmBroadcastReceiver.class);
                        PendingIntent pendingIntent1 = PendingIntent
                                .getBroadcast(this.getApplicationContext(), 12345, intent1, 0);
                        AlarmManager alarmManager1 = (AlarmManager) getSystemService(ALARM_SERVICE);
                        alarmManager1.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), AlarmManager.INTERVAL_FIFTEEN_MINUTES, pendingIntent1);


//                        Intent intent2=new Intent(this,ScheduleAllAlarms.class);
//                        PendingIntent pendingIntent2=PendingIntent
//                                .getBroadcast(this.getApplicationContext(),54321,intent2,0);
//                        AlarmManager alarmManager2=(AlarmManager)getSystemService(ALARM_SERVICE);
//                        alarmManager2
//                                .setRepeating(AlarmManager.RTC_WAKEUP,System.currentTimeMillis(),AlarmManager.INTERVAL_DAY,pendingIntent2);

                    }
                    if (call.method.equals("openAppInfo")) {
                        Intent settingIntent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                        settingIntent.setData(Uri.parse("package:" + getApplicationContext().getPackageName()));
                        startActivity(settingIntent);
                        System.out.println("SETTING OPENED");
                    }

                    if (call.method.equals("checkForBatteryOptimization")) {
                        String packageName = getPackageName();
                        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
                        if (pm.isIgnoringBatteryOptimizations(packageName)) {
                            result.success(true);
                        } else {
                           result.success(false);
                        }

                    }
                    if(call.method.equals("launchBatteryOptimizationDialog")){
                        Intent intent = new Intent();
                        String packageName = getPackageName();
                        intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                        intent.setData(Uri.parse("package:" + packageName));
                        startActivity(intent);
                    }

                });
    }
}
