package uk.co.piggz.galaxy_attack_hd;

import com.android.vending.billing.*;
import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import android.util.Log;
import android.os.Bundle;
import android.os.IBinder;
import android.content.ServiceConnection;
import android.os.RemoteException;
import android.content.Intent;
import android.content.ComponentName;
import android.content.Context;
import android.app.PendingIntent;
import org.json.JSONObject;
import java.util.ArrayList;
import android.widget.Toast;
import com.amazon.ags.api.*;
import java.util.EnumSet;
import static uk.co.piggz.galaxy_attack_hd.GalaxyAttackUtils.getErrorMessage;

public class GalaxyAttackHDActivity extends QtActivity
{
    private static GalaxyAttackHDActivity m_instance;
    public static final int TOAST_DURATION = 1500;
    private IInAppBillingService m_service;
    //reference to the agsClient
    AmazonGamesClient agsClient;

    private ServiceConnection m_serviceConnection = new ServiceConnection() {
       @Override
       public void onServiceDisconnected(ComponentName name)
       {
           m_service = null;
       }

       @Override
       public void onServiceConnected(ComponentName name, IBinder service)
       {
           m_service = IInAppBillingService.Stub.asInterface(service);
       }
    };

    public GalaxyAttackHDActivity()
    {
        m_instance = this;
    }

    AmazonGamesCallback callback = new AmazonGamesCallback() {
            @Override
            public void onServiceNotReady(AmazonGamesStatus status) {
                Log.e("-----AGS Service Not Ready", "---");
            }
            @Override
            public void onServiceReady(AmazonGamesClient amazonGamesClient) {
                agsClient = amazonGamesClient;
                agsClient.initializeJni();
                Log.e("-----AGS Service Ready", "---");
            }
    };


    //list of features your game uses (in this example, achievements and leaderboards)
    EnumSet<AmazonGamesFeature> myGameFeatures = EnumSet.of(
            AmazonGamesFeature.Achievements, AmazonGamesFeature.Leaderboards);

    @Override
    public void onResume() {
        super.onResume();
        AmazonGamesClient.initialize(this, callback, myGameFeatures);
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        bindService(new Intent("com.android.vending.billing.InAppBillingService.BIND"),
                    m_serviceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void onDestroy()
    {
        super.onDestroy();

        unbindService(m_serviceConnection);
    }

    private static native void activityStopped();

    @Override
    public void onStop()
    {
        super.onStop();

 //       activityStopped();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 1001) {
            int responseCode = data.getIntExtra("RESPONSE_CODE", -1);
            String purchaseData = data.getStringExtra("INAPP_PURCHASE_DATA");

             if (resultCode == RESULT_OK) {
                try {
                    JSONObject jo = new JSONObject(purchaseData);
                    String sku = jo.getString("productId");
                    int purchaseState = jo.getInt("purchaseState");
                    //String payload = jo.getString("developerPayload");
                    String purchaseToken = jo.getString("purchaseToken");

                    itemPurchased(sku, purchaseState);

                } catch (Exception e) {
                    e.printStackTrace();
                }
             } else {
                //itemPurchased("unknown", 1);
                Log.e(QtApplication.QtTAG, "Buying game failed: Result code == " + resultCode);
             }
        }
    }

    private static native void itemPurchased(String itemName, int purchaseState);

    public static void purchaseItem(String itemName)
    {
        Log.e(QtApplication.QtTAG, "In purhaseItem");

        if (m_instance.m_service == null) {
            Log.e(QtApplication.QtTAG, "Buying item failed: No billing service");
            return;
        }

        try {
            Bundle buyIntentBundle = m_instance.m_service.getBuyIntent(3,
                                                                       m_instance.getPackageName(),
                                                                       itemName,
                                                                       "inapp",
                                                                       "");
            int responseCode = buyIntentBundle.getInt("RESPONSE_CODE");
            Log.e(QtApplication.QtTAG, "Buying item: Response code == " + responseCode);
            if (responseCode == 0) {
                PendingIntent pendingIntent = buyIntentBundle.getParcelable("BUY_INTENT");
                m_instance.startIntentSenderForResult(pendingIntent.getIntentSender(),
                                                      1001, new Intent(), Integer.valueOf(0), Integer.valueOf(0),
                                                      Integer.valueOf(0));
                return;
            } else {
                if (responseCode == 7) { //already purchsed
                    itemPurchased(itemName, 0);
                } else {
                    Log.e(QtApplication.QtTAG, "Buying item failed: Response code == " + responseCode);
                }
            }
        } catch (Exception e) {
            Log.e(QtApplication.QtTAG, "Exception caught when buying item!", e);
        }
    }

    public static int checkItemPurchased(String itemName)
    {
        Log.e(QtApplication.QtTAG, "In checkItemPurhased");
        int purchased = -1;
        if (m_instance.m_service == null) {
            Log.e(QtApplication.QtTAG, "Check game failed: No billing service");
            return purchased;
        }

        try {
            Bundle ownedItems = m_instance.m_service.getPurchases(3, m_instance.getPackageName(),
                                                                       "inapp",
                                                                       null);
           int response = ownedItems.getInt("RESPONSE_CODE");
           if (response == 0) {
              ArrayList<String> ownedSkus = ownedItems.getStringArrayList("INAPP_PURCHASE_ITEM_LIST");
              ArrayList<String> purchaseDataList = ownedItems.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
              ArrayList<String> signatureList = ownedItems.getStringArrayList("INAPP_DATA_SIGNATURE_LIST");
              String continuationToken = ownedItems.getString("INAPP_CONTINUATION_TOKEN");

              Log.i(QtApplication.QtTAG, "Purchase List Size:" + purchaseDataList.size());
              Log.i(QtApplication.QtTAG, ownedItems.toString());
              for (int i = 0; i < purchaseDataList.size(); ++i) {
                 String purchaseData = purchaseDataList.get(i);
                 String signature = signatureList.get(i);
                 String sku = ownedSkus.get(i);

                 Log.i(QtApplication.QtTAG, "A purchased item" + purchaseData + " " + signature + " " + sku);
                 if (sku.equals(itemName)) {
                    Log.i(QtApplication.QtTAG, "Match found!");
                    purchased = 0;
                 }
              }
           }

        } catch (Exception e) {
            Log.e(QtApplication.QtTAG, "Exception caught when checking item bought!", e);
        }
        return purchased;
    }

    protected void toastMessage(final String message) {

            runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                            Toast.makeText(getApplicationContext(), message, TOAST_DURATION).show();
                    }
            });

    }

}
