import { Cache } from "cachefactory";
import {
	ObserverService,
	RequestService,
	UtilityService,
} from "@Hibachi/core/core.module";

import { PublicService } from "@Monat/monatfrontend.module";


import Cart from "@Monat/models/cart";
import cartOrderItem from "@Monat/models/cartOrderItem";

export type IOption = {
	name: string;
	value: any;
};

export class MonatService {
	public cart: Cart;
	public lastAddedSkuID: string = "";
	public previouslySelectedStarterPackBundleSkuID: string;
	public canPlaceOrder: boolean;
	public userIsEighteen: boolean;
	public hasOwnerAccountOnSession: boolean;
	public successfulActions = [];
	public showAddToCartMessage: boolean;
	public lastAddedProduct: cartOrderItem;
	public muraContent = {};
	public hairFilters = [{}];
	public skinFilters = [{}];
	public totalItemQuantityAfterDiscount = 0;
	public ofyItems;
	public qualifiedPromos = [];
	public promotionRewardSkus = {};
	
	//@ngInject
	constructor(
		private $q: ng.IQService,
		private $window: ng.IWindowService,
		private publicService: PublicService,
		private requestService: RequestService,
		private observerService: ObserverService,
		private utilityService: UtilityService,
		private localStorageCache: Cache,
		private ModalService,
	) {}

	public getCart(refresh = false, param = "") {
		var deferred = this.$q.defer();
		let cachedCart = this.publicService.getFromSessionCache("cachedCart");
		
		if (refresh || !cachedCart) {
			this.publicService
				.getCart(refresh, param)
				.then((data) => {
					if (data?.cart) {
						console.log("get-cart, putting it in session-cache");
						this.publicService.putIntoSessionCache("cachedCart", data.cart);

						this.updateCartPropertiesOnService(data);
						deferred.resolve(data.cart);
					} else {
						throw data;
					}
				})
				.catch((e) => {
					console.log("get-cart, exception, removing it from session-cache", e);
					this.publicService.removeFromSessionCache("cachedCart");
					deferred.reject(e);
				});
		} else {
			this.updateCartPropertiesOnService({ cart: cachedCart });
			deferred.resolve(cachedCart);
		}
		return deferred.promise;
	}
	
	public getQualifiedPromotionsForCart = (cart) =>{
		this.publicService.doAction('getQualifiedMerchandiseRewardsForOrder',{orderID:cart.orderID}).then(result=>{
			this.qualifiedPromos = result.rewards;
			return result.rewards;
		})
	}
	
	/**
	 * actions => addOrderItem, removeOrderItem, updateOrderItemQuantity, ....
	 *
	 */
	private updateCart = (action: string, payload): ng.IPromise<any> => {
		let deferred = this.$q.defer();
		payload["returnJsonObjects"] = "cart";

		this.publicService
			.doAction(action, payload)
			.then((data) => {
				this.successfulActions = [];
				//we're not checking for failure actions, as regardless of failures we still need to show the cart to the user
				if (data?.cart) {
					console.log("update-cart, putting it in session-cache");
					this.publicService.putIntoSessionCache("cachedCart", data.cart);

					this.successfulActions = data.successfulActions;
					this.handleCartResponseActions(data); //call before setting this.cart to snapshot
					this.updateCartPropertiesOnService(data);
					if(data.successfulActions){
						data.cart['successfulActions'] = data.successfulActions;
					}
					deferred.resolve(data.cart);
					this.observerService.notify("updatedCart", data.cart);
				} else {
					throw data;
				}
			})
			.catch((e) => {
				console.log("update-cart, exception, removing it from session-cache", e);
				this.publicService.removeFromSessionCache("cachedCart");
				deferred.reject(e);
			});

		return deferred.promise;
	};

	public addToCart(skuID: string, quantity: number = 1) {
		let payload = {
			skuID: skuID,
			quantity: quantity,
		};

		this.lastAddedSkuID = skuID;

		return this.updateCart("addOrderItem", payload);
	}
	
	public addMultipleToCart(data:any){
		return this.updateCart("addOrderItems",data);
	}

	public removeFromCart(orderItemID: string) {
		let payload = {
			orderItemID: orderItemID,
		};
		return this.updateCart("removeOrderItem", payload);
	}

	public updateCartItemQuantity(orderItemID: string, quantity: number = 1) {
		let payload = {
			"orderItem.orderItemID": orderItemID,
			"orderItem.quantity": quantity,
		};
		return this.updateCart("updateOrderItemQuantity", payload);
	}

	public submitSponsor(sponsorID: string) {
		return this.publicService.doAction("submitSponsor", { 
		    sponsorID:  sponsorID, 
		    returnJsonObjects: 'account'
		});
	}

	public addEnrollmentFee(sponsorID: string) {
		return this.publicService.doAction("addEnrollmentFee");
	}

	public selectStarterPackBundle(skuID: string, quantity: number = 1, upgradeFlow = 0) {
		let payload = {
			skuID: skuID,
			quantity: quantity,
		};

		if (upgradeFlow) {
			payload["upgradeFlowFlag"] = 1;
		}

		if (this.previouslySelectedStarterPackBundleSkuID) {
			payload[
				"previouslySelectedStarterPackBundleSkuID"
			] = this.previouslySelectedStarterPackBundleSkuID;
		}

		this.lastAddedSkuID = skuID;
		this.previouslySelectedStarterPackBundleSkuID = skuID;

		return this.updateCart("selectStarterPackBundle", payload);
	}

	/**
	 * options = {optionName:refresh, ---> option2:true, o3:false}
	 */
	public getOptions(options: {}, refresh = false, orderTemplateID='') {
		var deferred = this.$q.defer<any>();
		var optionsToFetch = this.makeListOfOptionsToFetch(options, refresh);

		if (refresh || (optionsToFetch && optionsToFetch.length)) {
			this.doPublicAction("getOptions", { optionsList: optionsToFetch, orderTemplateID:orderTemplateID }).then((data: any) => {
				var { messages, failureActions, successfulActions, ...realOptions } = data; //destructuring we don't want unwanted data in cached options
				Object.keys(realOptions).forEach((key) =>
					this.localStorageCache.put(key, realOptions[key])
				);
				this.returnOptions(options, deferred);
			});
		} else {
			this.returnOptions(options, deferred);
		}
		return deferred.promise;
	}

	private makeListOfOptionsToFetch(options: {}, refresh: boolean = false) {
		return Object.keys(options)
			.filter((key) => refresh || !!options[key] || !this.localStorageCache.get(key))
			.reduce((list, current) => this.utilityService.listAppend(list, current), "");
	}

	private returnOptions(options: {}, deferred) {
		let res = Object.keys(options).reduce((obj, key) => {
			return (<any>Object).assign(obj, {
				[key]: this.localStorageCache.get(key),
			});
		}, {});
		deferred.resolve(res);
	}

	public getSiteOrderTemplateShippingMethodOptions(refresh = false, orderTemplateID = '') {
		return this.getOptions({ siteOrderTemplateShippingMethodOptions: refresh });
	}

	public getFrequencyTermOptions(refresh = false) {
		return this.getOptions({ frequencyTermOptions: refresh });
	}

	public getFrequencyDateOptions(refresh = false) {
		return this.getOptions({ frequencyDateOptions: refresh });
	}

	public getCancellationReasonTypeOptions(refresh = false) {
		return this.getOptions({ cancellationReasonTypeOptions: refresh });
	}

	public getScheduleDateChangeReasonTypeOptions(refresh = false) {
		return this.getOptions({
			scheduleDateChangeReasonTypeOptions: refresh,
		});
	}

	public getExpirationMonthOptions(refresh = false) {
		return this.getOptions({ expirationMonthOptions: refresh });
	}

	public getExpirationYearOptions(refresh = false) {
		return this.getOptions({ expirationYearOptions: refresh });
	}

	/**
	 * TODO: move to the UtilityService
	 *
	 * This method gets the value of a cookie by its name
	 * Example cookie: "flexshipID=01234567" => "01234567"
	 **/
	public getCookieValueByCookieName(name: string): string {
		let cookieString = document.cookie;
		let cookieArray = cookieString.split(";");
		let cookieValueArray = <Array<string>>cookieArray.filter((el) => el.search(name) > -1);
		if (!cookieValueArray.length) return "";
		return cookieValueArray[0].substr(cookieValueArray[0].indexOf("=") + 1);
	}

	public getFlattenObject = (inObject: Object, delimiter: string = "."): Object => {
		var objectToReturn = {};
		for (var key in inObject) {
			if (!inObject.hasOwnProperty(key)) continue;

			if (typeof inObject[key] == "object" && inObject[key] !== null) {
				var flatObject = this.getFlattenObject(inObject[key]);
				for (var x in flatObject) {
					if (!flatObject.hasOwnProperty(x)) continue;
					objectToReturn[key + delimiter + x] = flatObject[x];
				}
			} else {
				objectToReturn[key] = inObject[key];
			}
		}
		return objectToReturn;
	};

	/**
    	This method takes a date string and returns age in years
    **/
	public calculateAge(birthDate: string): number {
		if (!birthDate) return;
		let birthDateObj = <any>Date.parse(birthDate);
		let years = Date.now() - birthDateObj.getTime();
		let age = new Date(years);
		let yearsOld = Math.abs(age.getUTCFullYear() - 1970);
		this.userIsEighteen = yearsOld >= 18;
		return yearsOld;
	}

	public adjustInputFocuses = () => {
		$("input, select").focus(function () {
			var ele = $(this);
			if (!ele.isInEnrollmentViewport()) {
				$("html, body").animate(
					{
						scrollTop: ele.offset().top - 80,
					},
					800
				);
			}
		});
	};


	public addEditAccountAddress(payload) {
		return this.publicService.doAction("addEditAccountAddress", payload);
	}

	public getAccountAddresses() {
		let deferred = this.$q.defer<any>();
		this.doPublicAction("getAccountAddresses")
			.then((data) => {
				if (!data?.accountAddresses) throw data;
				deferred.resolve(data);
			})
			.catch((e) => deferred.reject(e));
		return deferred.promise;
	}

	public getAccountPaymentMethods() {
		let deferred = this.$q.defer<any>();
		this.doPublicAction("getAccountPaymentMethods")
			.then((data) => {
				if (!data?.accountPaymentMethods) throw data;
				deferred.resolve(data);
			})
			.catch((e) => deferred.reject(e));
		return deferred.promise;
	}

	public getStateCodeOptionsByCountryCode(
		countryCode: string = hibachiConfig.countryCode,
		refresh = false
	) {
		let cacheKey = `stateCodeOptions_${countryCode}`;
		let deferred = this.$q.defer<any>();

		if (refresh || !this.localStorageCache.get(cacheKey)) {
			this.doPublicAction("getStateCodeOptionsByCountryCode", {
				countryCode: countryCode,
			}).then((data) => {
				if (!data?.stateCodeOptions) throw data;

				this.localStorageCache.put(cacheKey, {
					stateCodeOptions: data.stateCodeOptions,
					addressOptions: data.addressOptions,
				});
				deferred.resolve(data);
			})
			.catch((e) => deferred.reject(e));
		} else {
			deferred.resolve(this.localStorageCache.get(cacheKey));
		}
		return deferred.promise;
	}

	//************************* helper functions *****************************//

	public redirectToProperSite(redirectUrl: string) {
		if (hibachiConfig.cmsSiteID != "default") {
			redirectUrl = "/" + hibachiConfig.cmsSiteID + redirectUrl;
		}

		this.$window.location.href = redirectUrl;
	}

	/**
	 * doAction('actionName', ?{....whatever-data...})
	 */

	public doPublicAction(action: string, data?: any): ng.IPromise<any> {
		return this.requestService.newPublicRequest(this.createPublicAction(action), data).promise;
	}

	/**
	 * createPublicAction('WHATEVER') ==> /Slatwall/?slatAction=api:main:WHATEVER
	 */

	public createPublicAction(action: string) {
		return `${hibachiConfig.baseURL}?${hibachiConfig.action}=api:public.${action}`;
	}

	public formatAccountAddress(accountAddress): string {
		return `
        		${accountAddress?.accountAddressName} 
        		- ${accountAddress?.address_streetAddress} ${
			accountAddress?.address_street2Address?.trim() || " "
		}
    			${accountAddress?.address_city}, ${accountAddress?.address_stateCode} 
    			${accountAddress?.address_postalCode} ${accountAddress?.address_countryCode}
    		`;
	}

	//************************* CACHING helper functions *****************************//

	public setNewlyCreatedFlexship(flexshipID: string) {
		if (flexshipID?.trim()) {
			this.publicService.putIntoSessionCache("newlyCreatedFlexship", flexshipID);
		} else {
			this.publicService.removeFromSessionCache("newlyCreatedFlexship");
		}
	}

	public getNewlyCreatedFlexship(): string {
		return this.publicService.getFromSessionCache("newlyCreatedFlexship");
	}

	public setCurrentFlexship(flexship) {
		if (flexship?.orderTemplateID?.trim()) {
			this.publicService.putIntoSessionCache("currentFlexship", flexship);
		} else {
			this.publicService.removeFromSessionCache("currentFlexship");
		}
		return flexship;
	}

	public getCurrentFlexship(): { [key: string]: any } {
		return this.publicService.getFromSessionCache("currentFlexship");
	}

	public updateCartPropertiesOnService(data: { ["cart"]: any; [key: string]: any }) {
		data = this.hideNonPublicItems(data);
		this.cart = data.cart;
		// prettier-ignore
		this.cart['purchasePlusMessage'] = data.cart.appliedPromotionMessages ? data.cart.appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 )[0] : {};
		this.cart['canPlaceOrderMessage'] = data.cart.appliedPromotionMessages ? data.cart.appliedPromotionMessages.filter( message => message.promotionName.indexOf('Can Place Order') > -1 )[0] : {};
		this.canPlaceOrder = data.cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
		this.totalItemQuantityAfterDiscount = 0;
		for (let item of this.cart.orderItems) {
			this.totalItemQuantityAfterDiscount += item.extendedPriceAfterDiscount;
		}
	}

	public handleCartResponseActions(data): void {
		if (!this.successfulActions.length) return;

		switch (true) {
			case this.successfulActions[0].indexOf("addOrderItem") > -1:
				this.handleAddOrderItemSuccess(data);
				break;
			case this.successfulActions[0].indexOf("updateOrderItem") > -1:
				this.handleUpdateCartSuccess(data);
				break;
		}
	}
	
	public hideNonPublicItems(data: { ["cart"]: Cart; [key: string]: any }){
		data.cart.orderItems = data.cart.orderItems.filter( item => {
			if(!item.showInCartFlag){
				data.cart.totalItemQuantity -= item.quantity;
			}
			return item.showInCartFlag;
		});
		
		return data;
	}

	public handleAddOrderItemSuccess(data: { ["cart"]: any; [key: string]: any }): void {
		let newCart = <Cart>data.cart;

		if (
			this.cart.orderItems.length &&
			newCart.orderItems.length == this.cart.orderItems.length
		) {
			this.handleUpdateCartSuccess(data);
			return;
		}
		this.showAddToCartMessage = true;
		this.lastAddedProduct = newCart.orderItems[newCart.orderItems.length - 1];
	}

	public handleUpdateCartSuccess(data: { ["cart"]: any; [key: string]: any }): void {
		let newCart = <Cart>data.cart;
		var index = 0;
		for (let item of newCart.orderItems) {
			if (
				this.cart.orderItems[index] &&
				this.cart.orderItems[index].quantity < item.quantity
			) {
				this.showAddToCartMessage = true;
				this.lastAddedProduct = item;
				break;
			}
			index++;
		}
	}

	public getProductFilters() {
		return this.publicService
			.doAction("getProductListingFilters", null, "GET")
			.then((response) => {
				if (response.hairCategories) {
					this.hairFilters = response.hairCategories;
					this.skinFilters = response.skinCategories;
				}
				return {
					hairFilters: this.hairFilters,
					skinFilters: this.skinFilters,
				};
			});
	}
	
	public addOFYItem(skuID){
		var deferred = this.$q.defer<any>();
		this.publicService.doAction("addOFYProduct", { skuID: skuID, quantity: 1, returnJsonObjects: "cart" })
		.then((data: any) => {
			if (data?.cart) {
				console.log("update-cart, putting it in session-cache");
				this.publicService.putIntoSessionCache("cachedCart", data.cart);

				this.successfulActions = data.successfulActions;
				this.handleCartResponseActions(data); 
				this.updateCartPropertiesOnService(data);

				deferred.resolve(data.cart);
				this.observerService.notify("updatedCart", data.cart);
			} else {
				throw data;
			}
		});
		
		return deferred.promise;
	}
	
	public getOFYItemsForOrder(hardRefresh = false){
		var deferred = this.$q.defer<any>();
		if(this.ofyItems && !hardRefresh){
			deferred.resolve(this.ofyItems);
		}else{
			this.publicService.doAction("getOFYProductsForOrder").then((data: any) => {
				if (data?.ofyProducts) {
					this.ofyItems = data.ofyProducts;
					deferred.resolve(this.ofyItems);
				} else {
					throw data;
				}
			});
		}
		return deferred.promise;
	}
	
	public cartHasShippingFulfillmentMethodType(cart:Cart):boolean{
		let hasShippingMethodOption = false;
		for(let fulfillment of cart.orderFulfillments){
			if(fulfillment.fulfillmentMethod?.fulfillmentMethodType === 'shipping'){
				hasShippingMethodOption = true;
				break;
			}
		}
		return hasShippingMethodOption;
	}
	
	public getPromotionRewardSkus = (promotionRewardID)=>{
		var deferred = this.$q.defer();
		if(this.promotionRewardSkus[promotionRewardID]){
			deferred.resolve(this.promotionRewardSkus[promotionRewardID]);
		}else{
			let data = {
				orderID:this.cart.orderID,
				promotionRewardID:promotionRewardID
			};
			this.publicService.doAction('getQualifiedPromotionRewardSkusForOrder',data).then((result:any)=>{
				if(result.rewardSkus){
					this.promotionRewardSkus[promotionRewardID] = result.rewardSkus;
					deferred.resolve(result.rewardSkus);
				}else{
					throw result;
				}
			});
		}
		return deferred.promise;
	}
	
	
	// common-modals
	
	public launchWishlistsModal = (skuId:string, productId:string, productName:string) => {
		this.ModalService.showModal({
			component: 'swfWishlist',
			bodyClass: 'angular-modal-service-active',
			bindings: {
				skuId: skuId,
				productId: productId,
				productName: productName
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model : swfWishlist ', error);
		});
	}
}
