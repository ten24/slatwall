import { MonatService } from "./monatservice";
import { PublicService } from "@Monat/monatfrontend.module";


export type OrderTemplateLight = {
    orderTemplateID     : string,
    orderTemplateName   : string
};

export type WishlistItemLight = {
    productID: string
}

export class OrderTemplateService {
	private orderTemplateTypeID: string = "";
	private cachedGetOrderTemplatesResponse: any;
	private cachedGetAccountGiftCardsResponse: any;
	public canPlaceOrderFlag: boolean;
	public mostRecentOrderTemplate: any;
	public currentOrderTemplateID: string;
	public showAddToCartMessage: boolean;
	public lastAddedProduct;
	public cartTotalThresholdForOFYAndFreeShipping;
	public appliedPromotionCodeList = [];
	
	//@ngInject
	constructor(
		public $q: ng.IQService,
		public monatService: MonatService,
		public publicService: PublicService,
	) {}

	/**
	 * This function is being used to fetch flexships and wishLists
	 *
	 *
	 */
	public getOrderTemplates = (
		orderTemplateTypeID: string,
		pageRecordsShow = 100,
		currentPage = 1,
		refresh = false
	) => {
		var deferred = this.$q.defer<any>();
		// if we're gonna use pagination, we shouldn't cache
		if (
			orderTemplateTypeID == this.orderTemplateTypeID &&
			this.cachedGetOrderTemplatesResponse &&
			!refresh
		) {
			deferred.resolve(this.cachedGetOrderTemplatesResponse);
		} else {
			this.orderTemplateTypeID = orderTemplateTypeID;

			var data = {
				currentPage: currentPage,
				pageRecordsShow: pageRecordsShow,
				orderTemplateTypeID: orderTemplateTypeID,
			};

			this.monatService
				.doPublicAction("getOrderTemplates", data)
				.then((result) => {
					// TODO additional checks to make sure it's a successful response
					this.cachedGetOrderTemplatesResponse = result;
					deferred.resolve(this.cachedGetOrderTemplatesResponse);
				})
				.catch((e) => {
					deferred.reject(e);
				});
		}
		return deferred.promise;
	};

	public getAccountGiftCards(refresh = false) {
		var deferred = this.$q.defer();

		if (refresh || !this.cachedGetAccountGiftCardsResponse) {
			this.monatService
				.doPublicAction("getAccountGiftCards")
				.then((data) => {
					if (!data?.giftCards) throw data;

					this.cachedGetAccountGiftCardsResponse = data.giftCards;
					deferred.resolve(this.cachedGetAccountGiftCardsResponse);
				})
				.catch((e) => deferred.reject(e));
		} else {
			deferred.resolve(this.cachedGetAccountGiftCardsResponse);
		}
		return deferred.promise;
	}

	public applyGiftCardToOrderTemplate = (orderTemplateID, giftCardID, amountToApply) => {
		var data = {
			giftCardID: giftCardID,
			amountToApply: amountToApply,
			orderTemplateID: orderTemplateID,
		};

		return this.monatService.doPublicAction("applyGiftCardToOrderTemplate", data);
	};

	public getOrderTemplateItems = (
		orderTemplateID,
		pageRecordsShow = 100,
		currentPage = 1,
		orderTemplateTypeID?
	) => {
		var data = {
			orderTemplateID: orderTemplateID,
			currentPage: currentPage,
			pageRecordsShow: pageRecordsShow,
		};

		if (orderTemplateTypeID) {
			data["orderTemplateTypeID"] = orderTemplateTypeID;
		}

		return this.monatService.doPublicAction("getOrderTemplateItems", data);
	};

	public getOrderTemplateDetails = (
		orderTemplateID: string,
		optionalProperties: string = "",
		nullAccountFlag = false
	) => {
		var deferred = this.$q.defer();
		var data = {
			orderTemplateID: orderTemplateID,
			optionalProperties: optionalProperties,
			nullAccountFlag: nullAccountFlag,
		};

		this.monatService
			.doPublicAction("getOrderTemplateDetails", data)
			.then((res) => {
				if (res.orderTemplate && res.orderTemplate.canPlaceOrderFlag) {
					this.canPlaceOrderFlag = res.orderTemplate.canPlaceOrderFlag;
					this.mostRecentOrderTemplate = res.orderTemplate;
				}
				deferred.resolve(res);
			})
			.catch((e) => {
				deferred.reject(e);
			});
		return deferred.promise;
	};

	public updateShipping = (data) => {
		return this.monatService.doPublicAction("updateOrderTemplateShipping", data);
	};

	public updateBilling = (data) => {
		return this.monatService.doPublicAction("updateOrderTemplateBilling", data);
	};

	public activateOrderTemplate = (data) => {
		return this.monatService.doPublicAction("activateOrderTemplate", data);
	};

	public updateOrderTemplateShippingAndBilling = (
		orderTemplateID,
		shippingMethodID,
		shippingAccountAddressID,
		billingAccountAddressID,
		accountPaymentMethodID
	) => {
		let payload = {
			"orderTemplateID": orderTemplateID,
			"shippingMethodID": shippingMethodID,
			"shippingAccountAddress.value": shippingAccountAddressID,
			"billingAccountAddress.value": billingAccountAddressID,
			"accountPaymentMethod.value": accountPaymentMethodID,
			"optionalProperties":"purchasePlusTotal,otherDiscountTotal"
		};
		return this.monatService.doPublicAction(
			"updateOrderTemplateShippingAndBilling",
			this.getFlattenObject(payload)
		);
	};

	/**
	 * orderTemplateID:string,
	 * orderTemplateCancellationReasonType:string,  => OrderTemplateCancellationReason::TypeID
	 * orderTemplateCancellationReasonTypeOther?:string => some explanation from user
	 */

	public cancelOrderTemplate = (
		orderTemplateID: string,
		orderTemplateCancellationReasonType: string,
		orderTemplateCancellationReasonTypeOther: string = ""
	) => {
		let payload = {};
		payload["orderTemplateID"] = orderTemplateID;
		payload["orderTemplateCancellationReasonType"] = orderTemplateCancellationReasonType;
		payload[
			"orderTemplateCancellationReasonTypeOther"
		] = orderTemplateCancellationReasonTypeOther;

		return this.monatService.doPublicAction(
			"cancelOrderTemplate",
			this.getFlattenObject(payload)
		);
	};

	/**
     * 
       'orderTemplateID',
       'orderTemplateName'
     * 
    */

	public editOrderTemplate = (orderTemplateID: string, orderTemplateName: string) => {
		let payload = {
			orderTemplateID: orderTemplateID,
			orderTemplateName: orderTemplateName,
		};

		return this.monatService.doPublicAction("editOrderTemplate", payload);
	};

	/**
     * 
     * {
     * 
        'orderTemplateID': this.orderTemplate.orderTemplateID,
    	'orderTemplateScheduleDateChangeReasonTypeID': this.formData.selectedReason.value,
    	'frequencyTerm.value': this.formData.selectedFrequencyTermID,
        
        //optional
		'otherScheduleDateChangeReasonNotes': this.formData['otherReasonNotes'],
        'scheduleOrderNextPlaceDateTime': this.nextPlaceDateTime,
    	'skipNextMonthFlag  = 1,
     * }
     * 
     * 
     * 
    */

	public updateOrderTemplateSchedule = (data) => {
		return this.monatService.doPublicAction("updateOrderTemplateSchedule", data);
	};

	public updateOrderTemplateFrequency = (
		orderTemplateID: string,
		frequencyTermID: string,
		scheduleOrderDayOfTheMonth?: number
	) => {
		
		let deferred = this.$q.defer(); 
		let payload = {
			"orderTemplateID": orderTemplateID,
			"frequencyTerm.value": frequencyTermID,
		};
		 
		if(this.mostRecentOrderTemplate){
			this.mostRecentOrderTemplate['scheduleOrderDayOfTheMonth'] = scheduleOrderDayOfTheMonth;
		}
		 
		if (scheduleOrderDayOfTheMonth) {
			payload["scheduleOrderDayOfTheMonth"] = scheduleOrderDayOfTheMonth;
		}
		
		 this.monatService.doPublicAction("updateOrderTemplateFrequency", payload).then(res => {
		 	if(res.successfulActions && res.successfulActions.indexOf('public:order.deleteOrderTemplatePromoItem') > -1){
		 		this.splicePromoItem();
		 	}
		 	
    		deferred.resolve(res);
        }).catch(e =>{
            deferred.reject(e);
        });
        
		return deferred.promise;
	};
	
	public splicePromoItem = () => {
		let index = 0;
		for(let item of this.mostRecentOrderTemplate.orderTemplateItems){
			if(item.temporaryFlag){
				this.mostRecentOrderTemplate.orderTemplateItems.splice(index, 1);
				this.mostRecentOrderTemplate.calculatedOrderTemplateItemsCount--;
			}
			index++;
		}
	}

	public getWishlistItems = (
		orderTemplateID,
		pageRecordsShow = 100,
		currentPage = 1,
		orderTemplateTypeID?
	) => {
		var data = {
			orderTemplateID: orderTemplateID,
			currentPage: currentPage,
			pageRecordsShow: pageRecordsShow,
		};

		if (orderTemplateTypeID) {
			data["orderTemplateTypeID"] = orderTemplateTypeID;
		}

		return this.monatService.doPublicAction("getWishlistItems", data);
	};

	/**
     * 
       'orderTemplateID',
       'skuID',
       'quantity'
       temporaryFlag -> For OFY/Promotional item
     * 
    */ 
    public addOrderTemplateItem = (skuID:string, orderTemplateID:string, quantity:number=1, temporaryFlag=false, optionalData = {}) => {
        optionalData['orderTemplateID'] = orderTemplateID;
        optionalData['skuID'] = skuID;
        optionalData['quantity'] = quantity;
        optionalData['temporaryFlag'] = temporaryFlag;
        let deferred = this.$q.defer(); 
	  
        this.publicService.doAction('addOrderTemplateItem',optionalData).then(res=>{
            if(res.orderTemplate){
                this.manageOrderTemplate(res.orderTemplate);
                this.updateOrderTemplateDataOnService(res.orderTemplate);
            }
            deferred.resolve(res);
        }).catch(e =>{
            deferred.reject(e);
        });
        
       return deferred.promise;
    }
    
    
    /**
     * 
       'orderTemplateItemID',
       'quantity'
     * 
    */

	public editOrderTemplateItem = (orderTemplateItemID: string, newQuantity: number = 1) => {
		let payload = {
			orderTemplateItemID: orderTemplateItemID,
			quantity: newQuantity,
		};

		return this.monatService.doPublicAction("editOrderTemplateItem", payload);
	};
	

	public deleteOrderTemplateItem = (orderTemplateItemID) => {
		return this.publicService.doAction("deleteOrderTemplateItem", {
			orderTemplateItemID: orderTemplateItemID,
		});
	};

	/**
	 * orderTemplateItemID
	 *
	 */

	public removeOrderTemplateItem = (orderTemplateItemID: string) => {
		let payload = { orderTemplateItemID: orderTemplateItemID };
		return this.monatService.doPublicAction("removeOrderTemplateItem", payload);
	};

	/**
	 * for more details https://gist.github.com/penguinboy/762197
	 */

	public getFlattenObject = (inObject: Object, delimiter: string = "."): Object => {
		var outObject = {};
		for (var key in inObject) {
			if (!inObject.hasOwnProperty(key)) continue;

			if (typeof inObject[key] == "object" && inObject[key] !== null) {
				var flatObject = this.getFlattenObject(inObject[key]);
				for (var x in flatObject) {
					if (!flatObject.hasOwnProperty(x)) continue;
					outObject[key + delimiter + x] = flatObject[x];
				}
			} else {
				outObject[key] = inObject[key];
			}
		}
		return outObject;
	};

	/**
	 * for more details  https://stackoverflow.com/a/42696154
	 */

	public getUnFlattenObject = (inObject: Object, delimiter: string = "_") => {
		let outObject = {};
		
		Object.keys(inObject).forEach( (flattenedKey) => {
			walkThePathAndSet( flattenedKey.split(delimiter), outObject, inObject[flattenedKey]);
		})

		let walkThePathAndSet = (path:Array<string>, object:Object, value:any) =>{
			let [key, ...remainingPath] = path;
			if(remainingPath?.length){
				object[key] = object[key] || isNaN(Number(remainingPath[0])) ? {} : [];
				walkThePathAndSet(remainingPath, object[key], value);
			} else {
				object[key] = value;
			}
		}

		return outObject;
	};

	public createOrderTemplate = (
		orderTemplateSystemCode,
		context = "save",
		setOnHibachiScopeFlag = false
	) => {
		return this.publicService.doAction("createOrderTemplate", {
			orderTemplateSystemCode: orderTemplateSystemCode,
			saveContext: context,
			returnJsonObjects: "",
			setOnHibachiScopeFlag: setOnHibachiScopeFlag,
		});
	};

	public getOrderTemplatesLight = (orderTemplateTypeID = "2c9280846b712d47016b75464e800014") => {
		return this.publicService.doAction("getAccountOrderTemplateNamesAndIDs", {
			orderTemplateTypeID: orderTemplateTypeID,
		});
	};

	public getOrderTemplateSettings() {
		return this.publicService.doAction("getDaysToEditOrderTemplateSetting");
	}

	public deleteOrderTemplate(orderTemplateID) {
		return this.monatService.doPublicAction("deleteOrderTemplate", {
			orderTemplateID: orderTemplateID,
		});
	}
	
	public getSetOrderTemplateOnSession(optionalProperties = '', saveContext = 'upgradeFlow', setIfNullFlag = true, nullAccountFlag = true){
        let deferred = this.$q.defer();
    
		let data ={
            saveContext: saveContext,
            setIfNullFlag: setIfNullFlag,
            optionalProperties: optionalProperties,
            nullAccountFlag:nullAccountFlag,
            returnJSONObjects:''
        }
        
        this.publicService.doAction('getSetFlexshipOnSession', data).then(res=>{
            if(res.orderTemplate && typeof res.orderTemplate == 'string'){
                this.currentOrderTemplateID = res.orderTemplate;
            }else if(res.orderTemplate){
                this.manageOrderTemplate(res.orderTemplate); 
                this.updateOrderTemplateDataOnService(res.orderTemplate);
            }
            deferred.resolve(res);
	    }).catch( (e) => {
           deferred.reject(e);
       });
       
       return deferred.promise;
	}
	
    public calculateSRPOnOrder= (orderTemplate):number =>{
    	if(!orderTemplate.orderTemplateItems) return;
    	let suggestedRetailPrice = 0;
    	for(let item of orderTemplate.orderTemplateItems){
    		suggestedRetailPrice += (item.calculatedListPrice * item.quantity);
    	}
    	
    	return suggestedRetailPrice;
    }
    
    //handle any new data on the order template
    public manageOrderTemplate(template){
        let newOrderTemplate = template;
        if(!this.mostRecentOrderTemplate || !newOrderTemplate.orderTemplateItems) return;
        //if the new orderTemplateItems length is > than the old orderTemplateItems, a new item has been added       
        if(newOrderTemplate.orderTemplateItems.length > this.mostRecentOrderTemplate.orderTemplateItems.length || newOrderTemplate.orderTemplateItems.length && !this.mostRecentOrderTemplate){
            this.showAddToCartMessage = true;
            this.lastAddedProduct = newOrderTemplate.orderTemplateItems[0];
            return;
        }
        
        
        let index = 0;
        
        //Loop over orderTemplateItems to see if quantity has increased on one, if so, the item has been updated
		for(let item of newOrderTemplate.orderTemplateItems){
			if(
			    this.mostRecentOrderTemplate.orderTemplateItems[index] 
			    && this.mostRecentOrderTemplate.orderTemplateItems[index].orderTemplateItemID == item.orderTemplateItemID
			    && this.mostRecentOrderTemplate.orderTemplateItems[index].quantity < item.quantity)
			{
				this.showAddToCartMessage = true;
				this.lastAddedProduct = item;
				break;
			}
			index++;
		}
	}

    
    public updateOrderTemplateDataOnService(orderTemplate){
        this.currentOrderTemplateID = orderTemplate.orderTemplateID
        this.mostRecentOrderTemplate = orderTemplate;
        this.canPlaceOrderFlag = orderTemplate.canPlaceOrderFlag || this.canPlaceOrderFlag;
        let promoArray = this.mostRecentOrderTemplate.appliedPromotionMessagesJson?.length ? JSON.parse(this.mostRecentOrderTemplate.appliedPromotionMessagesJson) : [];
        this.mostRecentOrderTemplate['purchasePlusMessage'] = promoArray.length ? promoArray.filter( message => message.promotion_promotionName.indexOf('Purchase Plus') > -1 )[0] : {};
        this.mostRecentOrderTemplate['suggestedPrice'] = this.calculateSRPOnOrder(this.mostRecentOrderTemplate);
       
        if(this.mostRecentOrderTemplate.cartTotalThresholdForOFYAndFreeShipping){
            this.cartTotalThresholdForOFYAndFreeShipping = this.mostRecentOrderTemplate.cartTotalThresholdForOFYAndFreeShipping;
        }
    }
    
    public addPromotionCode(promotionCode:string, orderTemplateID = this.currentOrderTemplateID){
        let deferred = this.$q.defer();
    
		let data ={
            orderTemplateID: orderTemplateID,
            promotionCode: promotionCode,
            optionalProperties: 'purchasePlusTotal,otherDiscountTotal'
        }
        
        this.publicService.doAction('addOrderTemplatePromotionCode', data).then(res=>{
        	if(res.appliedOrderTemplatePromotionCodes){
        		this.appliedPromotionCodeList = res.appliedOrderTemplatePromotionCodes;
        	}
        	this.mostRecentOrderTemplate = res.orderTemplate;
            deferred.resolve(res);
	    }).catch( (e) => {
           deferred.reject(e);
       });
       
       return deferred.promise;
    }
    
    public getAppliedPromotionCodes(orderTemplateID = this.currentOrderTemplateID){
        let deferred = this.$q.defer();
    
		let data ={
            orderTemplateID: orderTemplateID,
        }
        
        this.publicService.doAction('getAppliedOrderTemplatePromotionCodes', data).then(res=>{
        
        	if(res.appliedOrderTemplatePromotionCodes){
        		this.appliedPromotionCodeList = res.appliedOrderTemplatePromotionCodes;
        	}
        	
            deferred.resolve(res);
	    }).catch( (e) => {
           deferred.reject(e);
       });
       
 
       return deferred.promise;
    }
    
    public removePromotionCode(promotionCodeID:string, orderTemplateID = this.currentOrderTemplateID){
        let deferred = this.$q.defer();
    
		let data ={
			promotionCodeID: promotionCodeID,
            orderTemplateID: orderTemplateID,
            'optionalProperties': 'purchasePlusTotal,otherDiscountTotal'
        }
        
        this.publicService.doAction('removeOrderTemplatePromotionCode', data).then(res=>{
        
        	if(res.appliedOrderTemplatePromotionCodes){
        		this.appliedPromotionCodeList = res.appliedOrderTemplatePromotionCodes;
        	}
        	this.mostRecentOrderTemplate = res.orderTemplate;
            deferred.resolve(res);
	    }).catch( (e) => {
           deferred.reject(e);
       });
       
 
       return deferred.promise;
    }
    
    
    
    
    /*********************** Wish-List *************************/

	public addItemAndCreateWishlist = ( orderTemplateName: string, skuID: string, productID: string) => {
	   
	   let deferred = this.$q.defer();

		return this.publicService.doAction("addItemAndCreateWishlist", { orderTemplateName, skuID }).then( data => {
    	    if( !data?.successfulActions?.includes('public:orderTemplate.addItemAndCreateWishlist') ){ throw(data) }
		    
		    //  update cache
		    this.addProductIdIntoWishlistItemsCache(productID);
		    this.addWishlistIntoSessionCache(data.newWishlist);
		    deferred.resolve(data);
        })
        .catch( deferred.reject );
        
        return deferred.promise;
	};
	
	
    public addWishlistItem = (orderTemplateID:string, skuID:string, productID: string) => {
        let deferred = this.$q.defer(); 
	  
        this.publicService.doAction('addWishlistItem',{ orderTemplateID, skuID }).then( data => {
            
            if(!data?.successfulActions?.includes('public:orderTemplate.addWishlistItem') ){ throw(data) }
            
            this.addProductIdIntoWishlistItemsCache(productID);
            deferred.resolve(data);
        })
        .catch( deferred.reject );
        
        return deferred.promise;
    }
    
    /**
	 * This function gets the wishlisItems `[ { productID: string }]` and cache them on session-cache
	*/
    public getAccountWishlistItemIDs = (refresh=false) => {
	    
	    var deferred = this.$q.defer<WishlistItemLight[]>();
	    
		let cachedAccountWishlistItemIDs = this.publicService.getFromSessionCache("cachedAccountWishlistItemIDs");
		
		if (refresh || !cachedAccountWishlistItemIDs) {
			this.publicService.doAction("getWishlistItemsForAccount")
			.then((data) => {
			    
			    if(!data?.wishlistItems){
                    throw(data);
                }
				console.log("cachedAccountWishlistItemIDs, putting it in session-cache");
				
				this.publicService.putIntoSessionCache("cachedAccountWishlistItemIDs", data.wishlistItems);
				
				deferred.resolve(data.wishlistItems);
			})
			.catch((e) => {
				console.log("cachedAccountWishlistItemIDs, exception, removing it from session-cache", e);
				this.publicService.removeFromSessionCache("cachedAccountWishlistItemIDs");
				deferred.reject(e);
			});
		} 
		else {
			deferred.resolve(cachedAccountWishlistItemIDs);
		}
		
		return deferred.promise;
	};
	
	private addProductIdIntoWishlistItemsCache( productID:string ){
        //update-cache, put new product into wishlist-items
        let cachedAccountWishlistItemIDs = this.publicService.getFromSessionCache('cachedAccountWishlistItemIDs') || [];
        cachedAccountWishlistItemIDs.push({'productID': productID});
        this.publicService.putIntoSessionCache("cachedAccountWishlistItemIDs", cachedAccountWishlistItemIDs);
    }
    
    private addWishlistIntoSessionCache = ( wishlist: OrderTemplateLight) => {
        //update-cache, put new product into wishlist-items
        let cachedWishlists = this.publicService.getFromSessionCache('cachedWishlists') || [];
        cachedWishlists.push(wishlist);
        this.publicService.putIntoSessionCache("cachedWishlists", cachedWishlists);
    }
    
	
	/**
	 * This function gets the wishlists `{ namd, ID }` and cache them on session-cache
	*/
	public getWishLists = ( refresh = false ) => {
	    
	    var deferred = this.$q.defer<OrderTemplateLight[]>();
		let cachedWishlists = this.publicService.getFromSessionCache("cachedWishlists");
		
		if (refresh || !cachedWishlists) {
			
			this.getOrderTemplatesLight('2c9280846b712d47016b75464e800014')
			.then( (data) => {
			
			    if(!data?.orderTemplates){
                    throw(data);
                }
				
				console.log("getWishLists, success, putting in session-cache");
				this.publicService.putIntoSessionCache("cachedWishlists", data.orderTemplates);
				deferred.resolve(data.orderTemplates);
			})
			.catch( (e) => {
				console.log("getWishLists, exception, removing from session-cache", e);
				this.publicService.removeFromSessionCache("cachedWishlists");
				deferred.reject(e);
			});
		} 
		else {
			deferred.resolve(cachedWishlists);
		}
		
		return deferred.promise;
	};
	
	
}
