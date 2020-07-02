import "angular-modal-service";
import "angularjs-toaster";

import { frontendmodule } from "../../../../org/Hibachi/client/src/frontend/frontend.module";

//directives
import { MonatFlexshipCard } from "./components/monatflexshipcard";
import { MonatFlexshipDetail } from "./components/monatflexshipdetail";
import { MonatFlexshipOrderItem } from "./components/monatflexship-orderitem";
import { MonatFlexshipShippingAndBillingCard } from "./components/monatflexship-shippingandbillingcard";
import { MonatFlexshipOrderTotalCard } from "./components/monatflexship-ordertotalcard";

import { MonatFlexshipAddGiftCardModal } from "./components/flexship/modals/add-giftcard";
import { MonatFlexshipCancelModal } from "./components/flexship/modals/cancel";
import { MonatFlexshipDeleteModal } from "./components/flexship/modals/delete";
import { MonatFlexshipNameModal } from "./components/flexship/modals/name";
import { MonatFlexshipPaymentMethodModal } from "./components/flexship/modals/paymentmethod";
import { MonatFlexshipScheduleModal } from "./components/flexship/modals/schedule";
import { MonatFlexshipShippingMethodModal } from "./components/flexship/modals/shippingmethod";

import { MonatFlexshipCartContainer } from "./components/monatflexship-cart-container";
import { MonatFlexshipConfirm } from "./components/monatflexship-confirm";
import { MonatFlexshipListing } from "./components/monatflexshiplisting";
import { MonatFlexshipMenu } from "./components/monatflexshipmenu";
import { MonatEnrollment } from "./components/monatenrollment";
import { MonatEnrollmentVIP } from "./components/monatenrollmentvip";
import { MonatEnrollmentStep } from "./components/monatenrollmentstep";
import { MonatOrderItems } from "./components/monat-order-items";
import { MaterialTextarea } from "./components/material-textarea";
import { ObserveEvent } from "./components/observe-event";

import { WishlistEditModal   } from "./components/wishlist-edit-modal";
import { WishlistShareModal  } from "./components/wishlist-share-modal";
import { WishlistDeleteModal } from "./components/wishlist-delete-modal";

import { SWFReviewListing } from "./components/swfreviewlisting";
import { SWFWishlist } from "./components/swfwishlist";
import { SWFAccount } from "./components/swfmyaccount";
import { MonatProductCard } from "./components/monatproductcard";
import { MonatProductModal } from "./components/monat-product-modal";
import { MonatEnrollmentMP } from "./components/monatenrollmentmp";
import { SponsorSearchSelector } from "./components/sponsor-search-selector";
import { SWFPagination } from "./components/swfpagination";
import { MonatProductReview } from "./components/monat-product-review";

import { MonatMiniCart } from "./components/minicart/monat-minicart";

import { MonatUpgrade } from "./components/upgradeFlow/monatupgrade";
import { MonatUpgradeVIP } from "./components/upgradeFlow/monatupgradevip";
import { MonatUpgradeStep } from "./components/upgradeFlow/monatupgradestep";
import { MonatUpgradeMP } from "./components/upgradeFlow/monatupgrademp";
import { ImageManager } from "./components/image-manager";
import { AddressDeleteModal } from "./components/address-delete-modal";
import { MonatConfirmMessageModel } from "./components/monat-modal-confirm-message";
import { MonatBirthday } from "./components/monatBirthday";
import { HybridCart } from "./components/hybridCart";
import { EnrollmentFlexship } from "./components/enrollmentFlexship";
import { AddressVerification } from "./components/addressVerificationModal";
import { OFYEnrollment } from "./components/ofyEnrollment";
import { PurchasePlusBar } from "./directives/purchase-plus-bar";
import { FlexshipPurchasePlus } from "./components/flexshipPurchasePlus";

import { FlexshipFlow } from "./components/flexshipFlow/flexshipFlow";
import { ProductListingStep } from "./components/flexshipFlow/productlistingstep";
import { FrequencyStep } from "./components/flexshipFlow/frequencyStep";
import { FlexshipCheckoutStep } from "./components/flexshipFlow/checkout-step";
import { FlexshipCheckoutShippingAddress } from "./components/flexshipFlow/checkout-components/shipping-address";
import { FlexshipCheckoutShippingMethod } from "./components/flexshipFlow/checkout-components/shipping-method";
import { ReviewStep } from "./components/flexshipFlow/reviewStep";

import { AccountAddressForm } from "./components/account-address-form";

// controllers
import { MonatForgotPasswordController } from "./controllers/monat-forgot-password";
import { MonatSearchController } from "./controllers/monat-search";
import { MonatCheckoutController } from "./controllers/monat-checkout";
import { MonatProductListingController } from "./controllers/monat-product-listing";
import { OnlyForYouController } from "./controllers/monat-onlyforyou";

//services
import { MonatService } from "./services/monatservice";
import { PayPalService } from "./services/paypalservice";
import { OrderTemplateService } from "./services/ordertemplateservice";
import { MonatHttpInterceptor } from "./services/monatHttpInterceptor";
import { MonatHttpQueueInterceptor } from "./services/monatHttpQueueInterceptor";
import { MonatAlertService } from "./services/monatAlertService";
import { MonatDatePicker } from "./directives/monatdatepicker";

//State-management
import { FlexshipCheckoutStore } from "./states/flexship-checkout-store";

//declare variables out of scope
declare var $: any;

var monatfrontendmodule = angular
	.module("monatfrontend", [frontendmodule.name, "toaster", "ngMessages"])
	//constants
	.constant("monatFrontendBasePath", "/Slatwall/custom/client/src")
	//directives
	.directive("monatFlexshipListing", MonatFlexshipListing.Factory())
	.directive("monatFlexshipCard", MonatFlexshipCard.Factory())
	.directive("monatFlexshipDetail", MonatFlexshipDetail.Factory())
	.directive("monatFlexshipOrderItem", MonatFlexshipOrderItem.Factory())
	.directive("monatFlexshipShippingAndBillingCard", MonatFlexshipShippingAndBillingCard.Factory())
	.directive("monatFlexshipOrderTotalCard", MonatFlexshipOrderTotalCard.Factory())

	.directive("monatFlexshipPaymentMethodModal", MonatFlexshipPaymentMethodModal.Factory())
	.directive("monatFlexshipShippingMethodModal", MonatFlexshipShippingMethodModal.Factory())
	.directive("monatFlexshipScheduleModal", MonatFlexshipScheduleModal.Factory())
	.directive("monatFlexshipCancelModal", MonatFlexshipCancelModal.Factory())
	.directive("monatFlexshipNameModal", MonatFlexshipNameModal.Factory())
	.directive("monatFlexshipAddGiftCardModal", MonatFlexshipAddGiftCardModal.Factory())

	.directive("monatFlexshipCartContainer", MonatFlexshipCartContainer.Factory())
	.directive("monatFlexshipConfirm", MonatFlexshipConfirm.Factory())
	.directive("monatFlexshipMenu", MonatFlexshipMenu.Factory())

	.directive("monatEnrollment", MonatEnrollment.Factory())
	.directive("enrollmentMp", MonatEnrollmentMP.Factory())
	.directive("monatEnrollmentStep", MonatEnrollmentStep.Factory())
	.directive("vipController", MonatEnrollmentVIP.Factory())
	.directive("monatOrderItems", MonatOrderItems.Factory())
	.directive("materialTextarea", MaterialTextarea.Factory())
	.directive("observeEvent", ObserveEvent.Factory())
	.directive("sponsorSearchSelector", SponsorSearchSelector.Factory())
	.directive("paginationController", SWFPagination.Factory())
	.directive("monatFlexshipDeleteModal", MonatFlexshipDeleteModal.Factory())
	.directive("wishlistEditModal", WishlistEditModal.Factory())
	.directive("wishlistShareModal", WishlistShareModal.Factory())
	.directive("wishlistDeleteModal", WishlistDeleteModal.Factory())
	.directive("addressDeleteModal", AddressDeleteModal.Factory())

	.directive("swfReviewListing", SWFReviewListing.Factory())
	.directive("swfWishlist", SWFWishlist.Factory())
	.directive("monatProductCard", MonatProductCard.Factory())
	.directive("monatProductModal", MonatProductModal.Factory())
	.directive("swfAccount", SWFAccount.Factory())
	.directive("monatMiniCart", MonatMiniCart.Factory())
	.directive("monatProductReview", MonatProductReview.Factory())

	.directive("monatUpgrade", MonatUpgrade.Factory())
	.directive("upgradeMp", MonatUpgradeMP.Factory())
	.directive("vipUpgradeController", MonatUpgradeVIP.Factory())
	.directive("monatUpgradeStep", MonatUpgradeStep.Factory())
	.directive("imageManager", ImageManager.Factory())
	.directive("monatConfirmMessageModel", MonatConfirmMessageModel.Factory())
	.directive("monatDatePicker", MonatDatePicker.Factory())
	.directive("addressVerification", AddressVerification.Factory())

	.directive("monatBirthday", MonatBirthday.Factory())

	.directive("purchasePlusBar", PurchasePlusBar.Factory())

	.directive("hybridCart", HybridCart.Factory())
	.directive("enrollmentFlexship", EnrollmentFlexship.Factory())
	.directive("ofyEnrollment", OFYEnrollment.Factory())
	.directive("flexshipPurchasePlus", FlexshipPurchasePlus.Factory())
	.directive("flexshipFlow", FlexshipFlow.Factory())
	.directive("productListingStep", ProductListingStep.Factory())
	.directive("frequencyStep", FrequencyStep.Factory())
	.directive("flexshipCheckoutStep", FlexshipCheckoutStep.Factory())
	.directive("flexshipCheckoutShippingAddress", FlexshipCheckoutShippingAddress.Factory())
	.directive("flexshipCheckoutShippingMethod", FlexshipCheckoutShippingMethod.Factory())
	.directive("accountAddressForm", AccountAddressForm.Factory())
	.directive("reviewStep", ReviewStep.Factory())
	
	// Controllers
	.controller("searchController", MonatSearchController)
	.controller("forgotPasswordController", MonatForgotPasswordController)
	.controller("checkoutController", MonatCheckoutController)
	.controller("productListingController", MonatProductListingController)
	.controller("onlyForYouController", OnlyForYouController)

	// Services
	.service("monatService", MonatService)
	.service("payPalService", PayPalService)
	.service("orderTemplateService", OrderTemplateService)
	.service("monatHttpInterceptor", MonatHttpInterceptor)
	.service("monatHttpQueueInterceptor", MonatHttpQueueInterceptor)
	.service("monatAlertService", MonatAlertService)

	//state-stores
	.service("flexshipCheckoutStore", FlexshipCheckoutStore)

	.config([
		"$locationProvider",
		"$httpProvider",
		"appConfig",
		"localStorageCacheProvider",
		"sessionStorageCacheProvider",
		(
			$locationProvider,
			$httpProvider,
			appConfig,
			localStorageCacheProvider,
			sessionStorageCacheProvider
		) => {
			$locationProvider.html5Mode({ enabled: true, requireBase: false, rewriteLinks: false });

			//adding monat-http-interceptor
			$httpProvider.interceptors.push("monatHttpInterceptor");
			$httpProvider.interceptors.push("monatHttpQueueInterceptor");

			/**
			 * localStorageCache will be availabe to inject anywhere,
			 * this cache is shared b/w browser-tabs and windows
			 * this cache has no max-age
			 * this cache will be uniqueue per site
			 *
			 */
			localStorageCacheProvider.override({
				name: `ls.${appConfig.cmsSiteID || "default"}`,
			});

			/**
			 * sessionStorageCache will be availabe to inject anywhere,
			 * this cache is unique for every browser-window, and is sahred b/w tabs
			 * this cache will be uniqueue per site
			 */
			sessionStorageCacheProvider.override({
				name: `ss.${appConfig.cmsSiteID || "default"}`,
			});
		},
	])
	.run([
		"appConfig",
		"localStorageCache",
		"observerService",
		"publicService",
		(appConfig, localStorageCache, observerService, publicService) => {
			if (localStorageCache.get("instantiationKey") !== appConfig.instantiationKey) {
				console.log("app-instantiation-key changed, resetting local-storage caches");
				localStorageCache.removeAll();
				localStorageCache.put("instantiationKey", appConfig.instantiationKey);
			}
			console.log("app-instantiationKey-key", localStorageCache.get("instantiationKey"));

			//we're using the current-account-id as the cache-owner for the sessionStorageCache
			let logoutSuccessCallback = () => {
				console.log("on logoutSuccessCallback");
				hibachiConfig.accountID = undefined;
			};

			let loginSuccessCallback = () => {
				console.log("Called loginSuccessCallback");
				hibachiConfig.accountID = publicService.account?.accountID;
			};
			
			observerService.attach(loginSuccessCallback, "loginSuccess");
			observerService.attach(logoutSuccessCallback, "logoutSuccess");
			if(window.location.pathname.indexOf('enrollment') == -1){
				console.log('getting account')
				publicService.getAccount().then(result=>{
					observerService.notify('getAccountSuccess',result);
				})
				.catch(result=>{
					observerService.notify('getAccountFailure',result);
				})
			}
		},
	]);

export { monatfrontendmodule };
