/**
 * Copyright (c) 2014 Nokia Corporation and/or its subsidiary(-ies).
 * See the license text file delivered with this project for more information.
 */

package uk.co.piggz.galaxy_attack_hd;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import com.android.vending.billing.IInAppBillingService;
import com.nokia.payment.iap.aidl.INokiaIAPService;

@SuppressWarnings("NonBooleanMethodNameMayNotStartWithQuestion")
public class PaymentService {

	private IInAppBillingService googleIABService = null;
	private INokiaIAPService     nokiaIAPService  = null;

	private boolean useGoogleBilling = false;

	public int isBillingSupported(final int apiVersion, final String packageName, final String type)
		throws RemoteException {

		return useGoogleBilling
			   ? googleIABService.isBillingSupported(apiVersion, packageName, type)
			   : nokiaIAPService.isBillingSupported(apiVersion, packageName, type);
	}

	public Bundle getBuyIntent(final int apiVersion, final String packageName, final String sku,
		final String type, final String developerPayload) throws RemoteException {

		return useGoogleBilling
			   ? googleIABService.getBuyIntent(apiVersion, packageName, sku, type, developerPayload)
			   : nokiaIAPService.getBuyIntent(apiVersion, packageName, sku, type, developerPayload);
        }

        public Bundle getPurchases(final int apiVersion, final String packageName, final String type,
        final Bundle skusBundle, final String continuationToken) throws RemoteException {
            return useGoogleBilling
                   ? googleIABService.getPurchases(apiVersion, packageName, type, continuationToken)
                   : nokiaIAPService.getPurchases(apiVersion, packageName, type, skusBundle, continuationToken);
        }

	public Bundle getSkuDetails(final int apiVersion, final String packageName, final String type,
		final Bundle skusBundle) throws RemoteException {

		return useGoogleBilling
			   ? googleIABService.getSkuDetails(apiVersion, packageName, type, skusBundle)
			   : nokiaIAPService.getProductDetails(apiVersion, packageName, type, skusBundle);

	}

	public int consumePurchase(final int apiVersion, final String packageName, final String purchaseToken)
		throws RemoteException {

		return useGoogleBilling
			   ? googleIABService.consumePurchase(apiVersion, packageName, purchaseToken)
			   : nokiaIAPService.consumePurchase(apiVersion, packageName, null, purchaseToken);
	}

	public void mapProducts(final int apiVersion, final String packageName, final Bundle productMap)
		throws RemoteException {

		if (!useGoogleBilling) {
			nokiaIAPService.setProductMappings(apiVersion, packageName, productMap);
		}

	}

	public void useGoogleIAB(final IInAppBillingService service) {
		useGoogleBilling = true;

		googleIABService = service;
	}

	public void useNokiaIAP(final INokiaIAPService service) {
		useGoogleBilling = false;

		nokiaIAPService = service;
	}

	public void setService(final Context context, final IBinder service) {

                if (GalaxyAttackUtils.isNokiaNIAPAvailable(context)) {
			useNokiaIAP(INokiaIAPService.Stub.asInterface(service));
		} else {
			useGoogleIAB(IInAppBillingService.Stub.asInterface(service));
		}
	}

	public void clearService() {
		nokiaIAPService = null;
		googleIABService = null;
	}

	public Intent getServiceIntent(final Context context) {
                return GalaxyAttackUtils.isNokiaNIAPAvailable(context)
			   ? new Intent("com.nokia.payment.iapenabler.InAppBillingService.BIND")
			   : new Intent("com.android.vending.billing.InAppBillingService.BIND");
	}

	@Override
	public String toString() {
		return String.format("PaymentOneAPKService{googleIABService=%s, nokiaIAPService=%s, useGoogleBilling=%s}",
			googleIABService,
			nokiaIAPService,
			useGoogleBilling);
	}
}
