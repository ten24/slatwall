interface IOptions {
	name: string;
	value: any;
}

declare var angular: any;
declare var hibachiConfig: any;

export class MonatService {
	public cart;
	public lastAddedSkuID: string = '';
	public previouslySelectedStarterPackBundleSkuID:string;
	public canPlaceOrder:boolean;
	public cachedOptions = {
		frequencyTermOptions: <IOptions[]>null,
		countryCodeOptions: <IOptions[]>null,
	};
	public userIsEighteen:boolean;
	public hasOwnerAccountOnSession:boolean;
	
	//@ngInject
	constructor(public publicService, public $q, public $window, public requestService, private observerService) {}

	public getCart(refresh = false, param = '') {

		var deferred = this.$q.defer();
		if (refresh || angular.isUndefined(this.cart)) {
			this.publicService
				.getCart(refresh, param)
				.then((data) => {
					this.cart = data;
					let cart = data.cart ? data.cart : data;
					this.canPlaceOrder = cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
					this.cart['purchasePlusMessage'] = cart.appliedPromotionMessages ? cart.appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 )[0] : '';
					deferred.resolve(this.cart);
				})
				.catch((e) => {
					deferred.reject(e);
				});
		} else {
			deferred.resolve(this.cart);
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
				if (data.cart) {
					this.cart = data.cart;
					this.canPlaceOrder = this.cart.orderRequirementsList.indexOf('canPlaceOrderReward') == -1;
					this.cart['purchasePlusMessage'] = this.cart.appliedPromotionMessages ? this.cart.appliedPromotionMessages.filter( message => message.promotionName.indexOf('Purchase Plus') > -1 ) : '';
					deferred.resolve(data.cart);
					this.observerService.notify( 'updatedCart', data.cart ); 
				} else {
					throw data;
				}
			})
			.catch((e) => {
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
				.promise.then((data) => {
					var { messages, failureActions, successfulActions, ...realOptions } = data; //destructuring we dont want unwanted data in cached options
					this.cachedOptions = { ...this.cachedOptions, ...realOptions }; // override and merge with old options
					this.sendOptionsBack(options, deferred);
					//TODO handle errors
				});
		} else {
			this.sendOptionsBack(options, deferred);
		}
		return deferred.promise;
	}

	private makeListOfOptionsToFetch(options: {}, refresh: boolean = false) {
		return Object.keys(options)
			.filter((key) => refresh || !!options[key] || !this.cachedOptions[key])
			.reduce((previous, current) => {
				if (current) {
					previous = previous.length ? previous + ',' + current : current;
				}
				return previous;
			}, '');
	}

	private sendOptionsBack(options: {}, deferred) {
		let res = Object.keys(options).reduce(
			(result, key) => (<any>Object).assign(result, { [key]: this.cachedOptions[key] }),
			{},
		);
		deferred.resolve(res);
	}

	public getFrequencyTermOptions(refresh = false) {
		var deferred = this.$q.defer();
		if (refresh || !this.cachedOptions.frequencyTermOptions) {
			this.requestService
				.newPublicRequest('?slatAction=api:public.getFrequencyTermOptions')
				.promise.then((data) => {
					this.cachedOptions.frequencyTermOptions = data.frequencyTermOptions;
					deferred.resolve(this.cachedOptions.frequencyTermOptions);
				});
		} else {
			deferred.resolve(this.cachedOptions.frequencyTermOptions);
		}
		return deferred.promise;
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

    public countryCodeOptions = (refresh = false)=>{
        var deferred = this.$q.defer();
		if (refresh || !this.cachedOptions.countryCodeOptions) {
			this.publicService
				.getCountries()
				.then((data) => {
					this.cachedOptions.countryCodeOptions = data.countryCodeOptions;
					deferred.resolve(this.cachedOptions.countryCodeOptions);
				});
		} else {
			deferred.resolve(this.cachedOptions.countryCodeOptions);
		}
		return deferred.promise;
    }
    
    /**
    	This method gets the value of a cookie by its name
    	Example cookie: "flexshipID=01234567" => "01234567"
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

}
