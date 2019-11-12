import 'angular-modal-service';

import { frontendmodule } from '../../../../org/Hibachi/client/src/frontend/frontend.module';

//directives
import { MonatFlexshipCard } from './components/monatflexshipcard';
import { MonatFlexshipDetail } from './components/monatflexshipdetail';
import { MonatFlexshipOrderItem } from './components/monatflexship-orderitem';
import { MonatFlexshipShippingAndBillingCard } from './components/monatflexship-shippingandbillingcard';
import { MonatFlexshipOrderTotalCard } from './components/monatflexship-ordertotalcard';
import { MonatFlexshipPaymentMethodModal } from './components/monatflexship-modal-paymentmethod';
import { MonatFlexshipShippingMethodModal } from './components/monatflexship-modal-shippingmethod';
import { MonatFlexshipChangeOrSkipOrderModal } from './components/monatflexship-modal-changeorskiporder';
import { MonatFlexshipCancelModal } from './components/monatflexship-modal-cancel';
import { MonatFlexshipNameModal } from './components/monatflexship-modal-name';
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
import { MonatFlexshipFrequencyModal } from './components/monatflexship-modal-deliveryfrequency';

import { SWFReviewListing } from './components/swfreviewlisting';
import { SWFWishlist } from './components/swfwishlist';
import { SWFAccount } from './components/swfmyaccount';
import { MonatProductCard } from './components/monatproductcard';
import { MonatEnrollmentMP } from './components/monatenrollmentmp';
import { SponsorSearchSelector } from './components/sponsor-search-selector';
import { SWFPagination } from './components/swfpagination';

import { MonatMiniCart } from './components/minicart/monat-minicart';

import { MonatSearchController } from './controllers/monat-search';
import { MonatCheckoutController } from './controllers/monat-checkout';


//services
import { MonatService } from './services/monatservice';
import { OrderTemplateService } from './services/ordertemplateservice';
import { MonatHttpInterceptor } from './services/monatHttpInterceptor';

//declare variables out of scope
declare var $: any;

var monatfrontendmodule = angular
	.module('monatfrontend', [frontendmodule.name, 'angularModalService'])
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
	.directive('monatFlexshipChangeOrSkipOrderModal', MonatFlexshipChangeOrSkipOrderModal.Factory())
	.directive('monatFlexshipCancelModal', MonatFlexshipCancelModal.Factory())
	.directive('monatFlexshipNameModal', MonatFlexshipNameModal.Factory())
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
	.directive('monatFlexshipFrequencyModal', MonatFlexshipFrequencyModal.Factory())
	.directive('paginationController', SWFPagination.Factory())

	.directive('swfReviewListing', SWFReviewListing.Factory())
	.directive('swfWishlist', SWFWishlist.Factory())
	.directive('monatProductCard', MonatProductCard.Factory())
	.directive('swfAccount', SWFAccount.Factory())

	.directive('monatMiniCart', MonatMiniCart.Factory())
	
	// Controllers
	.controller('searchController', MonatSearchController)
	.controller('checkoutController', MonatCheckoutController)
	
	// Services
	.service('monatService', MonatService)
	.service('orderTemplateService', OrderTemplateService)
	.service('monatHttpInterceptor', MonatHttpInterceptor)

	.config([
		'ModalServiceProvider',
		'$locationProvider',
		'$httpProvider',
		(ModalServiceProvider, $locationProvider, $httpProvider) => {
			// to set a default close delay on modals
			ModalServiceProvider.configureOptions({ closeDelay: 0 });
			$locationProvider.html5Mode({ enabled: true, requireBase: false, rewriteLinks: false });
			
			//adding monat-http-interceptor
			$httpProvider.interceptors.push('monatHttpInterceptor');
		},
	]);

export { monatfrontendmodule };
