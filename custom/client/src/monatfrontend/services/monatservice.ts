import { Cache } from 'cachefactory';
import Cart from '../models/cart'
import cartOrderItem from '../models/cartOrderItem'

export interface IOption {
	name: string;
	value: any;
}


export class MonatService {
	public cart:Cart;
	public lastAddedSkuID: string = '';
	public previouslySelectedStarterPackBundleSkuID:string;
	public canPlaceOrder:boolean;
	public userIsEighteen:boolean;
	public hasOwnerAccountOnSession:boolean;
	public successfulActions = [];
	public showAddToCartMessage:boolean;
	public lastAddedProduct:cartOrderItem;
	
	//@ngInject
	constructor(
		private $q, 
		private $window, 
		private publicService, 
		private requestService, 
		private observerService,
		private utilityService,
		
		private localStorageCache: Cache,
		private sessionStorageCache: Cache,
		private inMemoryCache: Cache
	) {
		
		console.log("localCache keys: "+this.localStorageCache.keys());
		console.log("sessionCache keys: "+this.sessionStorageCache.keys());
		console.log("memoryCache keys: "+this.inMemoryCache.keys());
	}

	public getCart(refresh = false, param = '') {

		var deferred = this.$q.defer();
		let cachedCart = this.sessionStorageCache.get('cachedCart');
		
		if (refresh || angular.isUndefined(cachedCart) ){
			
			this.publicService.getCart(refresh, param)
				.then((data) => { 
					if(data &&  data.failureActions.length == 0){
						console.log("get-cart, puting it in session-cache")
						this.updateCartPropertiesOnService(data);
						deferred.resolve(data.cart);
					} else {
						throw data;
					}
				})
				.catch((e) => {
					console.log("get-cart, exception, removing it from session-cache", e);
					this.sessionStorageCache.remove('cachedCart');
					deferred.reject(e);
				});
				
		} else {
			this.updateCartPropertiesOnService({cart:cachedCart});
			deferred.resolve(cachedCart);
		}
		return deferred.promise;
	}

	/**
	 * actions => addOrderItem, removeOrderItem, updateOrderItemQuantity, ....
	 *
	*/
	private updateCart = (action: string, payload): Promise<any> => {
		let deferred = this.$q.defer();
		payload['returnJSONObjects'] = 'cart';

		this.publicService.doAction(action, payload)
			.then((data) => {
				this.successfulActions = [];
				if (data.cart && data.failureActions.length == 0) {
					console.log("update-cart, puting it in session-cache");
					this.successfulActions = data.successfulActions;
					this.sessionStorageCache.put('cachedCart', data.cart);
					this.handleCartResponseActions(data); //call before setting this.cart to snapshot
					this.updateCartPropertiesOnService(data);
					deferred.resolve(data.cart);
					this.observerService.notify( 'updatedCart', data.cart ); 
				} else {
					throw data;
				}
			})
			.catch((e) => {
				console.log("update-cart, exception, removing it from session-cache", e);
				this.sessionStorageCache.remove('cachedCart');
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

		return this.updateCart('addOrderItem', payload);
	}

	public removeFromCart(orderItemID: string) {
		let payload = {
			orderItemID: orderItemID,
		};
		return this.updateCart('removeOrderItem', payload);
	}

	public updateCartItemQuantity(orderItemID: string, quantity: number = 1) {
		let payload = {
			'orderItem.orderItemID': orderItemID,
			'orderItem.quantity': quantity,
		};
		return this.updateCart('updateOrderItemQuantity', payload);
	}
	
	public submitSponsor( sponsorID:string ) {
		return this.publicService.doAction('submitSponsor',{sponsorID});
	}
	
	public addEnrollmentFee( sponsorID:string ) {
		return this.publicService.doAction('addEnrollmentFee');
	}
	
	public selectStarterPackBundle(skuID: string, quantity: number = 1, upgradeFlow = 0) {
		let payload = {
			skuID: skuID,
			quantity: quantity,
		};
		
		if(upgradeFlow){
			payload['upgradeFlowFlag'] = 1;
		}
		
		if(this.previouslySelectedStarterPackBundleSkuID) {
			payload['previouslySelectedStarterPackBundleSkuID'] = this.previouslySelectedStarterPackBundleSkuID;
		}
		
		this.lastAddedSkuID = skuID;
		this.previouslySelectedStarterPackBundleSkuID = skuID;
		
		return this.updateCart('selectStarterPackBundle', payload);
	}
	

	/**
	 * options = {optionName:refresh, ---> option2:true, o3:false}
	*/
	public getOptions(options: {}, refresh = false) {
		var deferred = this.$q.defer();
		var optionsToFetch = this.makeListOfOptionsToFetch(options, refresh);

		if (refresh || (optionsToFetch && optionsToFetch.length)) {
			this.requestService
				.newPublicRequest('?slatAction=api:public.getOptions', { optionsList: optionsToFetch })
				.promise
				.then((data) => {
					var { messages, failureActions, successfulActions, ...realOptions } = data; //destructuring we dont want unwanted data in cached options
					Object.keys(realOptions).forEach( (key) => this.localStorageCache.put(key, realOptions[key] ) );
					this.returnOptions(options, deferred);
					//TODO handle errors
				});
		} else {
			this.returnOptions(options, deferred);
		}
		return deferred.promise;
	}

	private makeListOfOptionsToFetch(options: {}, refresh: boolean = false) {
		return Object.keys(options)
			.filter((key) => refresh || !!options[key] || !this.localStorageCache.get(key))
			.reduce((list, current) =>  this.utilityService.listAppend(list,current), '');
	}

	private returnOptions(options: {}, deferred) {
		let res = Object.keys(options)
			.reduce( (obj, key) => {
				return (<any>Object).assign(obj, { [key]: this.localStorageCache.get(key) })
			}, {});
		deferred.resolve(res);
	}
	

	public getOrderTemplateShippingMethodOptions(refresh = false) {
		return this.getOptions( {'orderTemplateShippingMethodOptions': refresh} );
	}

	public getFrequencyTermOptions(refresh = false) {
		return this.getOptions( {'frequencyTermOptions': refresh} );
	}
	
	public getFrequencyDateOptions(refresh = false) {
		return this.getOptions( {'frequencydateOptions': refresh} );
	}
	
	public getCancellationReasonTypeOptions(refresh = false) {
		return this.getOptions( {'cancellationReasonTypeOptions': refresh} );
	}
	
	public getScheduleDateChangeReasonTypeOptions(refresh = false) {
		return this.getOptions( {'scheduleDateChangeReasonTypeOptions': refresh} );
	}
	
	public getExpirationMonthOptions(refresh = false) {
		return this.getOptions( {'expirationMonthOptions': refresh} );
	}
	
	public getExpirationYearOptions(refresh = false) {
		return this.getOptions( {'expirationYearOptions': refresh} );
	}
	
    /**
     * TODO: move to the UtilityService
     * 
     * This method gets the value of a cookie by its name
     * Example cookie: "flexshipID=01234567" => "01234567"
    **/
    public getCookieValueByCookieName(name:string):string{
		let cookieString = document.cookie;
		let cookieArray = cookieString.split(';')
		let cookieValueArray = <Array<string>>cookieArray.filter( el => el.search(name) > -1 );
		if(!cookieValueArray.length) return '';
    	return  cookieValueArray[0].substr(cookieValueArray[0].indexOf('=') + 1);
    }
    
    /**
    	This method takes a date string and returns age in years
    **/
	public calculateAge(birthDate:string):number { 
		if(!birthDate) return;
		let birthDateObj = <any>Date.parse(birthDate);
	    let years = Date.now() - birthDateObj.getTime();
	    let age = new Date(years); 
	    let yearsOld = Math.abs(age.getUTCFullYear() - 1970);
	    this.userIsEighteen = yearsOld >= 18;
	    return yearsOld;
	}
	
		
	public adjustInputFocuses = () => {
		$('input, select').focus(function() {
			var ele = $(this);
			if ( !ele.isInEnrollmentViewport() ) {
				$('html, body').animate({
					scrollTop: ele.offset().top - 80 
				}, 800);
			}
		});
	}

	public getAccountWishlistItemIDs = () => {
		var deferred = this.$q.defer();
		this.publicService.doAction('getWishlistItemsForAccount').then( data => {
			deferred.resolve( data );
		});
		return deferred.promise;
	}
	
	public redirectToProperSite(redirectUrl:string){
		
		if(hibachiConfig.cmsSiteID != 'default'){
			redirectUrl = '/' + hibachiConfig.cmsSiteID + redirectUrl;
		}
		
		this.$window.location.href = redirectUrl;
	}
	
	public setNewlyCreatedFlexship(flexshipID: string){
		if(flexshipID && flexshipID.trim() !== '' ){
			this.sessionStorageCache.put('newlyCreatedFlexship', flexshipID);
		} else {
			this.sessionStorageCache.remove('newlyCreatedFlexship');
		}
	}
	
	public getNewlyCreatedFlexship(): string {
		return this.sessionStorageCache.get('newlyCreatedFlexship');
	}
	
	
	public setCurrentFlexship(flexshipID: string){
		if(flexshipID && flexshipID.trim() !== '' ){
			this.sessionStorageCache.put('currentFlexship', flexshipID);
		} else {
			this.sessionStorageCache.remove('currentFlexship');
		}
	}
	
	public getCurrentFlexship(): string {
		return this.sessionStorageCache.get('currentFlexship');
	}
	
	public updateCartPropertiesOnService(data:{['cart']:any, [key:string]:any}){
		this.cart = data.cart;
		this.cart['purchasePlusMessage'] = data.cart.appliedPromotionMessages ? data.cart.appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 )[0] : {};
		this.canPlaceOrder = data.cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
	}
	
	public handleCartResponseActions(data):void{
		if(!this.successfulActions.length) return;

		switch(true){
			case this.successfulActions[0].indexOf('addOrderItem') > -1:
				this.handleAddOrderItemSuccess(data);
				break;
			case this.successfulActions[0].indexOf('updateOrderItem') > -1:
				this.handleUpdateCartSuccess(data);
				break;
		}
	}
	
	public handleAddOrderItemSuccess(data:{['cart']:any, [key:string]:any}):void{
		let newCart = <Cart>data.cart;
	
		if(this.cart.orderItems.length && newCart.orderItems.length == this.cart.orderItems.length){
			this.handleUpdateCartSuccess(data);
			return;
		}
		this.showAddToCartMessage = true;
		this.lastAddedProduct = newCart.orderItems[newCart.orderItems.length - 1];
	}
	
	public handleUpdateCartSuccess(data:{['cart']:any, [key:string]:any}):void{
		let newCart = <Cart>data.cart;
		var index = 0;
		for(let item of newCart.orderItems){
			if(this.cart.orderItems[index] && this.cart.orderItems[index].quantity < item.quantity){
				this.showAddToCartMessage = true;
				this.lastAddedProduct = item;
				break;
			}
			index++;
		}
	}

}
