interface IOptions {
	name: string;
	value: any;
}

declare var angular: any;

export class MonatService {
	public cart;
	public lastAddedSkuID: string = '';
	public previouslySelectedStarterPackBundleSkuID:string;

	public cachedOptions = {
		frequencyTermOptions: <IOptions[]>null,
	};

	//@ngInject
	constructor(public publicService, public $q, public requestService) {}

	public getCart(refresh = false) {
		var deferred = this.$q.defer();
		if (refresh || angular.isUndefined(this.cart)) {
			this.publicService
				.getCart(refresh)
				.then((data) => {
					this.cart = data;
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
					deferred.resolve(data.cart);
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
	
	public selectStarterPackBundle(skuID: string, quantity: number = 1) {
		let payload = {
			skuID: skuID,
			quantity: quantity,
		};
		
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
}
