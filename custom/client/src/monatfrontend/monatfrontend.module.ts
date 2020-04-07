import 'angular-modal-service';
import 'angularjs-toaster';

import { frontendmodule } from '../../../../org/Hibachi/client/src/frontend/frontend.module';

//directives
import { MonatFlexshipCard } from './components/monatflexshipcard';
import { MonatFlexshipDetail } from './components/monatflexshipdetail';
import { MonatFlexshipOrderItem } from './components/monatflexship-orderitem';
import { MonatFlexshipShippingAndBillingCard } from './components/monatflexship-shippingandbillingcard';
import { MonatFlexshipOrderTotalCard } from './components/monatflexship-ordertotalcard';
import { MonatFlexshipPaymentMethodModal } from './components/monatflexship-modal-paymentmethod';
import { MonatFlexshipShippingMethodModal } from './components/monatflexship-modal-shippingmethod';
import { MonatFlexshipCancelModal } from './components/monatflexship-modal-cancel';
import { MonatFlexshipNameModal } from './components/monatflexship-modal-name';
import { MonatFlexshipAddGiftCardModal } from './components/monatflexship-modal-add-giftcard';
import { MonatFlexshipCartContainer } from './components/monatflexship-cart-container';
import { MonatFlexshipConfirm } from './components/monatflexship-confirm';
import { MonatFlexshipListing } from './components/monatflexshiplisting';
import { MonatFlexshipMenu } from './components/monatflexshipmenu';
import { MonatEnrollment } from './components/monatenrollment';
import { MonatEnrollmentVIP } from './components/monatenrollmentvip';
import { MonatEnrollmentStep } from './components/monatenrollmentstep';
import { MonatOrderItems } from './components/monat-order-items';
import { MaterialTextarea } from './components/material-textarea';
import { ObserveEvent } from './components/observe-event';

import { MonatFlexshipScheduleModal } from './components/flexship/modal-schedule';

import { MonatFlexshipDeleteModal } from './components/monatflexship-modal-delete';
import { WishlistDeleteModal } from './components/wishlist-delete-modal';
import { WishlistEditModal } from './components/wishlist-edit-modal';

import { SWFReviewListing } from './components/swfreviewlisting';
import { SWFWishlist } from './components/swfwishlist';
import { SWFAccount } from './components/swfmyaccount';
import { MonatProductCard } from './components/monatproductcard';
import { MonatProductModal } from './components/monat-product-modal';
import { MonatEnrollmentMP } from './components/monatenrollmentmp';
import { SponsorSearchSelector } from './components/sponsor-search-selector';
import { SWFPagination } from './components/swfpagination';
import { MonatProductReview } from './components/monat-product-review';

import { MonatMiniCart } from './components/minicart/monat-minicart';

import { MonatUpgrade } from './components/upgradeFlow/monatupgrade';
import { MonatUpgradeVIP } from './components/upgradeFlow/monatupgradevip';
import { MonatUpgradeStep } from './components/upgradeFlow/monatupgradestep';
import { MonatUpgradeMP } from './components/upgradeFlow/monatupgrademp';
import { ImageManager } from './components/image-manager';
import { AddressDeleteModal } from './components/address-delete-modal';
import { MonatConfirmMessageModel } from './components/monat-modal-confirm-message'
import { MonatBirthday } from './components/monatBirthday'
import { HybridCart } from './components/hybridCart'
import { EnrollmentFlexship } from './components/enrollmentFlexship'
import { AddressVerification } from './components/addressVerificationModal'
import { OFYEnrollment } from './components/ofyEnrollment'
import { PurchasePlusBar } from './directives/purchase-plus-bar';
import { FlexshipPurchasePlus } from './components/flexshipPurchasePlus';
import { FlexshipFlow } from './components/flexshipFlow/flexshipFlow';
import {ProductListingStep} from './components/flexshipFlow/productlistingstep';

// controllers
import { MonatForgotPasswordController } from './controllers/monat-forgot-password';
import { MonatSearchController } from './controllers/monat-search';
import { MonatCheckoutController } from './controllers/monat-checkout';
import { MonatProductListingController } from './controllers/monat-product-listing';
import { OnlyForYouController } from './controllers/monat-onlyforyou';

//services
import { MonatService } from './services/monatservice';
import { OrderTemplateService } from './services/ordertemplateservice';
import { MonatHttpInterceptor } from './services/monatHttpInterceptor';
import { MonatHttpQueueInterceptor } from './services/monatHttpQueueInterceptor'
import { MonatAlertService } from './services/monatAlertService';
import { MonatDatePicker} from './directives/monatdatepicker';

//declare variables out of scope
declare var $: any;

var monatfrontendmodule = angular
	.module('monatfrontend', [frontendmodule.name,'toaster', 'ngMessages'])
	//constants
	.constant('monatFrontendBasePath', '/Slatwall/custom/client/src')
	//directives
	.directive('monatFlexshipListing', MonatFlexshipListing.Factory())
	.directive('monatFlexshipCard', MonatFlexshipCard.Factory())
	.directive('monatFlexshipDetail', MonatFlexshipDetail.Factory())
	.directive('monatFlexshipOrderItem', MonatFlexshipOrderItem.Factory())
	.directive('monatFlexshipShippingAndBillingCard', MonatFlexshipShippingAndBillingCard.Factory())
	.directive('monatFlexshipOrderTotalCard', MonatFlexshipOrderTotalCard.Factory())
	.directive('monatFlexshipPaymentMethodModal', MonatFlexshipPaymentMethodModal.Factory())
	.directive('monatFlexshipShippingMethodModal', MonatFlexshipShippingMethodModal.Factory())
	
	.directive('monatFlexshipScheduleModal', MonatFlexshipScheduleModal.Factory())
	
	.directive('monatFlexshipCancelModal', MonatFlexshipCancelModal.Factory())
	.directive('monatFlexshipNameModal', MonatFlexshipNameModal.Factory())
	.directive('monatFlexshipAddGiftCardModal', MonatFlexshipAddGiftCardModal.Factory())
	.directive('monatFlexshipCartContainer', MonatFlexshipCartContainer.Factory())
	.directive('monatFlexshipConfirm', MonatFlexshipConfirm.Factory())
	.directive('monatFlexshipMenu', MonatFlexshipMenu.Factory())
	.directive('monatEnrollment', MonatEnrollment.Factory())
	.directive('enrollmentMp', MonatEnrollmentMP.Factory())
	.directive('monatEnrollmentStep', MonatEnrollmentStep.Factory())
	.directive('vipController', MonatEnrollmentVIP.Factory())
	.directive('monatOrderItems', MonatOrderItems.Factory())
	.directive('materialTextarea', MaterialTextarea.Factory())
	.directive('observeEvent', ObserveEvent.Factory())
	.directive('sponsorSearchSelector', SponsorSearchSelector.Factory())
	.directive('paginationController', SWFPagination.Factory())
	.directive('monatFlexshipDeleteModal', MonatFlexshipDeleteModal.Factory())
	.directive('wishlistDeleteModal', WishlistDeleteModal.Factory())
	.directive('wishlistEditModal', WishlistEditModal.Factory())
	.directive('addressDeleteModal', AddressDeleteModal.Factory())

	.directive('swfReviewListing', SWFReviewListing.Factory())
	.directive('swfWishlist', SWFWishlist.Factory())
	.directive('monatProductCard', MonatProductCard.Factory())
	.directive('monatProductModal', MonatProductModal.Factory())
	.directive('swfAccount', SWFAccount.Factory())
	.directive('monatMiniCart', MonatMiniCart.Factory())
	.directive('monatProductReview', MonatProductReview.Factory())

	.directive('monatUpgrade', MonatUpgrade.Factory())
	.directive('upgradeMp', MonatUpgradeMP.Factory())
	.directive('vipUpgradeController', MonatUpgradeVIP.Factory())
	.directive('monatUpgradeStep', MonatUpgradeStep.Factory())
	.directive('imageManager', ImageManager.Factory())
	.directive ('monatConfirmMessageModel',MonatConfirmMessageModel.Factory())
	.directive('monatDatePicker',MonatDatePicker.Factory())
	.directive('addressVerification',AddressVerification.Factory())

	.directive('monatBirthday',MonatBirthday.Factory())
	
	.directive('purchasePlusBar', PurchasePlusBar.Factory())

	.directive('hybridCart',HybridCart.Factory())
	.directive('enrollmentFlexship',EnrollmentFlexship.Factory())
	.directive('ofyEnrollment',OFYEnrollment.Factory())	
	.directive('flexshipPurchasePlus',FlexshipPurchasePlus.Factory())
	.directive('flexshipFlow',FlexshipFlow.Factory())
	.directive('productListingStep',ProductListingStep.Factory())
	
	// Controllers
	.controller('searchController', MonatSearchController)
	.controller('forgotPasswordController', MonatForgotPasswordController)
	.controller('checkoutController', MonatCheckoutController)
	.controller('productListingController', MonatProductListingController)
	.controller('onlyForYouController', OnlyForYouController)

	// Services
	.service('monatService', MonatService)
	.service('orderTemplateService', OrderTemplateService)
	.service('monatHttpInterceptor', MonatHttpInterceptor)
	.service("monatHttpQueueInterceptor", MonatHttpQueueInterceptor)
	.service('monatAlertService', MonatAlertService)
	.config(['$locationProvider', '$httpProvider','appConfig','localStorageCacheProvider', 'sessionStorageCacheProvider',
	($locationProvider, $httpProvider, appConfig, localStorageCacheProvider, sessionStorageCacheProvider) => {
			
			$locationProvider.html5Mode({ enabled: true, requireBase: false, rewriteLinks: false });
			
			//adding monat-http-interceptor
			$httpProvider.interceptors.push('monatHttpInterceptor');
			$httpProvider.interceptors.push('monatHttpQueueInterceptor');
			
			/**
	         * localStorageCache will be availabe to inject anywhere,
	         * this cache is shared b/w browser-tabs and windows
	         * this cache has no max-age
	         * this cache will be uniqueue per site
	         * 
	        */
			localStorageCacheProvider.override({
				'name': `ls.${appConfig.cmsSiteID || 'default'}`
			});
			
			/**
			 * sessionStorageCache will be availabe to inject anywhere,
			 * this cache is unique for every browser-window, and is sahred b/w tabs
			 * this cache will be uniqueue per site
			*/
			sessionStorageCacheProvider.override({
				'name': `ss.${appConfig.cmsSiteID || 'default'}`
			});
		},
	])
	.run(['appConfig','localStorageCache','sessionStorageCache', 
	(appConfig,localStorageCache,sessionStorageCache) =>{
		
		console.log("monat-module-run start");
		if(localStorageCache.get('instantiationKey') !== appConfig.instantiationKey){
			console.log("app-instantiation-key changed, resetting caches");
        	//if the app-instantiation-key is changed, clearign the caches
        	localStorageCache.removeAll(); 
        	sessionStorageCache.removeAll();
        	localStorageCache.put('instantiationKey', appConfig.instantiationKey);
        }
        console.log("app-key", localStorageCache.get('instantiationKey'));
        console.log("monat-module-run stop");

	}]);

export { monatfrontendmodule };