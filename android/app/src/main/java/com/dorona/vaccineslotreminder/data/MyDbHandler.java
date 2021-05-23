package com.dorona.vaccineslotreminder.data;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import com.dorona.vaccineslotreminder.params.Params;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MyDbHandler  extends SQLiteOpenHelper {
    public MyDbHandler(Context context){
        super(context, Params.DB_NAME,null,Params.DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
       System.out.println("dfsdfsdfsdf");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public List getAllReminders(){
        List remindersList=new ArrayList();
        SQLiteDatabase db=this.getReadableDatabase();
        String select = "SELECT * from Reminders";
         Cursor cursor= db.rawQuery(select,null);
         if(cursor.moveToFirst()){
             do{
                 Map<String,String> reminder=new HashMap<String,String>();
                 reminder.put("id",cursor.getString(0));
                 reminder.put("pincode",cursor.getString(1));
                 reminder.put("availableSlots",cursor.getString(2));
                 reminder.put("minimumAgeLimit",cursor.getString(3));
                 remindersList.add(reminder);

             }while (cursor.moveToNext());

         }
         return remindersList;
    }
}
