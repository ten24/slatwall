export class OrderTemplateService { 
   
   private orderTemplateTypeID:string='';
   private cachedGetOrderTemplatesResponse:any;
   private cachedGetAccountGiftCardsResponse:any;
   public canPlaceOrderFlag:boolean;
   public mostRecentOrderTemplate:any;
   public currentOrderTemplateID:string;
   public showAddToCartMessage:boolean;
   public lastAddedProduct;
   public cartTotalThresholdForOFYAndFreeShipping;
   
   //@ngInject
   constructor(
        public requestService,
        public $hibachi,
        public $rootScope,
        public publicService,
        public $q
    ){

   } 
   
   /**
    * This function is being used to fetch flexships and wishLists 
    * 
    * 
   */
   public getOrderTemplates = (orderTemplateTypeID:string, pageRecordsShow=100, currentPage=1, refresh=false,) =>{
       var deferred = this.$q.defer();
       
       // if we're gonna use pagination, we shoudn't cache 
       if(orderTemplateTypeID == this.orderTemplateTypeID  && this.cachedGetOrderTemplatesResponse && !refresh){
           deferred.resolve(this.cachedGetOrderTemplatesResponse);
       } else {
       
           this.orderTemplateTypeID = orderTemplateTypeID;
    
            var data = {
               currentPage: currentPage,
               pageRecordsShow: pageRecordsShow,
               orderTemplateTypeID: orderTemplateTypeID
           }
           
           this.publicService.doAction('?slatAction=api:public.getordertemplates', data)
           .then( (result) => {
               
               // TODO additional checks to make sure it's a successful response
               this.cachedGetOrderTemplatesResponse = result; 
               deferred.resolve(this.cachedGetOrderTemplatesResponse);
               
           })
           .catch( (e) => {
               deferred.reject(e);
           });
       }
       return deferred.promise;
   }
   
   
   public getAccountGiftCards(refresh = false) {
		var deferred = this.$q.defer();
		
		if (refresh || !this.cachedGetAccountGiftCardsResponse) {
			
			this.publicService
				.doAction('?slatAction=api:public.getAccountGiftCards')
				.then((data) => {
				    if(data && data.giftCards) {
    					this.cachedGetAccountGiftCardsResponse = data.giftCards;
    					deferred.resolve(this.cachedGetAccountGiftCardsResponse);
				    } else {
				        throw(data);
				    }
				})
				.catch((e) => {
					deferred.reject(e);
				});
				
		} else {
			deferred.resolve(this.cachedGetAccountGiftCardsResponse);
		}
		return deferred.promise;
	}
	
	
	public applyGiftCardToOrderTemplate = (orderTemplateID, giftCardID, amountToApply) => {
	    var data = {
            'orderTemplateID' : orderTemplateID,
            'giftCardID' : giftCardID,
            'amountToApply' : amountToApply
       }
      
       return this.requestService.newPublicRequest('?slatAction=api:public.applyGiftCardToOrderTemplate',data).promise;
	}
   
    public getOrderTemplateItems = (orderTemplateID, pageRecordsShow=100, currentPage=1,orderTemplateTypeID?) =>{
       var data = {
           'orderTemplateID' : orderTemplateID,
           'currentPage' : currentPage,
           'pageRecordsShow' : pageRecordsShow
       }
       
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       
       return this.requestService.newPublicRequest('?slatAction=api:public.getordertemplateitems',data).promise;
    }
   
    public getOrderTemplateDetails = (orderTemplateID:string, optionalProperties:string="", nullAccountFlag = false) => {
        var deferred = this.$q.defer();
        var data = {
            "orderTemplateID" : orderTemplateID,
            "optionalProperties" : optionalProperties,
            "nullAccountFlag" :nullAccountFlag
        }
        
       this.publicService.doAction('getOrderTemplateDetails', data).then(res=>{
       
           if(res.orderTemplate && res.orderTemplate.canPlaceOrderFlag){
               this.canPlaceOrderFlag = res.orderTemplate.canPlaceOrderFlag;
               this.mostRecentOrderTemplate = res.orderTemplate;
           } 
           
           deferred.resolve(res);
        }).catch((e) => {
			deferred.reject(e);
		});
		return deferred.promise;
    }
   
    public updateShipping = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateShipping', data)
                  .promise;
    }

    public updateBilling = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateBilling', data)
                  .promise;
    }

    public activateOrderTemplate = (data) => {
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.activateOrderTemplate', data)
                  .promise;
    }
    
  
    /**
     * orderTemplateID:string, 
     * orderTemplateCancellationReasonType:string,  => OrderTEmplateCancellationReason::TypeID
     * orderTemplateCancellationReasonTypeOther?:string => some explaination from user
     */ 
    public cancelOrderTemplate = (orderTemplateID:string, orderTemplateCancellationReasonType:string, orderTemplateCancellationReasonTypeOther:string = "") => {
        
        let payload = {};
    	payload['orderTemplateID'] = orderTemplateID;
    	payload['orderTemplateCancellationReasonType'] =  orderTemplateCancellationReasonType;
    	payload['orderTemplateCancellationReasonTypeOther'] = orderTemplateCancellationReasonTypeOther;

    	payload = this.getFlattenObject(payload);
    	
        return this.requestService
                  .newPublicRequest('?slatAction=api:public.cancelOrderTemplate', payload)
                  .promise;
    }
    
    /**
     * 
       'orderTemplateID',
       'orderTemplateName'
     * 
    */ 
    public editOrderTemplate = (orderTemplateID:string, orderTemplateName:string) => {
        let payload = {
			'orderTemplateID': orderTemplateID,
			'orderTemplateName': orderTemplateName
		};
		
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.editOrderTemplate',payload)
                  .promise;
    }
    
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
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateSchedule', data)
                  .promise;
    }
    
    public updateOrderTemplateFrequency = (orderTemplateID:string, frequencyTermID:string, scheduleOrderDayOfTheMonth?:number ) => {
       
        let payload = {
    		'orderTemplateID' : orderTemplateID,
    		'frequencyTerm.value' : frequencyTermID
    	};
    	
    	if(scheduleOrderDayOfTheMonth) {
    	    payload['scheduleOrderDayOfTheMonth'] =  scheduleOrderDayOfTheMonth;
    	}
    	
        return this.requestService
                  .newPublicRequest('?slatAction=api:public.updateOrderTemplateFrequency', payload)
                  .promise;
    }
	
	public getWishlistItems = (orderTemplateID, pageRecordsShow=100, currentPage=1,orderTemplateTypeID?) =>{
    
       var data = {
           orderTemplateID:orderTemplateID,
           currentPage:currentPage,
           pageRecordsShow:pageRecordsShow
       }
       
       if(orderTemplateTypeID){
           data['orderTemplateTypeID'] = orderTemplateTypeID;
       }
       
       return this.requestService.newPublicRequest('?slatAction=api:public.getWishlistitems',data).promise;
    }

    /**
     * 
       'orderTemplateID',
       'skuID',
       'quantity'
       temporaryFlag -> For OFY/Promotional item
     * 
    */ 
    public addOrderTemplateItem = (skuID:string, orderTemplateID:string, quantity:number=1, temporaryFlag: false) => {
        let payload = {
			'orderTemplateID': orderTemplateID,
			'skuID': skuID,
			'quantity': quantity,
			'temporaryFlag': temporaryFlag
		};
		
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.addOrderTemplateItem',payload)
                  .promise;
    }
    
    
    /**
     * 
       'orderTemplateItemID',
       'quantity'
     * 
    */ 
    public editOrderTemplateItem = (orderTemplateItemID:string, newQuantity:number=1) => {
        let payload = {
			'orderTemplateItemID': orderTemplateItemID,
			'quantity': newQuantity
		};
		
       return this.requestService
                  .newPublicRequest('?slatAction=api:public.editOrderTemplateItem',payload)
                  .promise;
    }
    

   public addOrderTemplateItemAndCreateWishlist = (orderTemplateName:string, skuID, quantity:number = 1)=>{
        const data = {
           orderTemplateName:orderTemplateName,
           skuID:skuID,
           quantity:quantity
        };
        
        return this.$rootScope.hibachiScope.doAction("addItemAndCreateWishlist",data);
   }
   
    public deleteOrderTemplateItem = (orderTemplateItemID)=>{
        return this.$rootScope.hibachiScope.doAction("deleteOrderTemplateItem", {orderTemplateItemID: orderTemplateItemID});
   }

    
    /**
     * orderTemplateItemID
     * 
    */ 
    public removeOrderTemplateItem = (orderTemplateItemID:string) => {

        let payload = {'orderTemplateItemID': orderTemplateItemID };
        return this.requestService
                  .newPublicRequest('?slatAction=api:public.removeOrderTemplateItem',payload)
                  .promise;
    }

   /**
    * for more details https://gist.github.com/penguinboy/762197
   */ 
    public getFlattenObject = (inObject:Object, delimiter:string='.') : Object => {
        var objectToReturn = {};
        for (var key in inObject) {
            if (!inObject.hasOwnProperty(key)) continue;
    
            if ((typeof inObject[key]) == 'object' && inObject[key] !== null) {
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
    }
    
    /**
     * for more details  https://stackoverflow.com/a/42696154 
    */ 
    public getUnflattenObject = (inObject:Object, delimiter:string='_') => {
      var objectToReturn = {};
      for (var flattenkey in inObject) {
        var keys = flattenkey.split(delimiter);
        keys.reduce(function(r, e, j) {
          return r[e] || (r[e] = isNaN(Number(keys[j + 1])) ? (keys.length - 1 == j ? inObject[flattenkey] : {}) : []);
        }, objectToReturn);
      }
      return objectToReturn;
    }

    public createOrderTemplate = (orderTemplateSystemCode, context="save") => {
        return this.$rootScope.hibachiScope.doAction("createOrderTemplate",{
            orderTemplateSystemCode: orderTemplateSystemCode,
            saveContext: context,
            returnJSONObjects:''
        });
    }   
    
   public getOrderTemplatesLight = (orderTemplateTypeID="2c9280846b712d47016b75464e800014") =>{
       return this.publicService.doAction('getAccountOrderTemplateNamesAndIDs', {ordertemplateTypeID: orderTemplateTypeID});
   }
   
   	public getOrderTemplateSettings(){
		return this.publicService.doAction('getDaysToEditOrderTemplateSetting');
	}
	
   	public deleteOrderTemplate(orderTemplateID){
		return this.publicService.doAction('deleteOrderTemplate', {orderTemplateID: orderTemplateID });
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
                this.currentOrderTemplateID = res.orderTemplate.orderTemplateID
                this.mostRecentOrderTemplate = res.orderTemplate;
                this.canPlaceOrderFlag = res.orderTemplate.canPlaceOrderFlag;
                let promoArray = this.mostRecentOrderTemplate.appliedPromotionMessagesJson?.length ? JSON.parse(this.mostRecentOrderTemplate.appliedPromotionMessagesJson) : [];
                this.mostRecentOrderTemplate['purchasePlusMessage'] = promoArray.length ? promoArray.filter( message => message.promotion_promotionName.indexOf('Purchase Plus') > -1 )[0] : {};
                this.mostRecentOrderTemplate['suggestedPrice'] = this.calculateSRPOnOrder(this.mostRecentOrderTemplate);
                if(this.mostRecentOrderTemplate.cartTotalThresholdForOFYAndFreeShipping){
                    this.cartTotalThresholdForOFYAndFreeShipping = this.mostRecentOrderTemplate.cartTotalThresholdForOFYAndFreeShipping;
                }
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
    		suggestedRetailPrice += item.calculatedListPrice;
    	}
    	
    	return suggestedRetailPrice;
    }
    
    //handle any new data on the order template
    public manageOrderTemplate(template){
        let newOT = template;
      
        if(!this.mostRecentOrderTemplate || !newOT.orderTemplateItems) return;
        
        //if the new orderTemplateItems length is > than the old orderTemplateItems, a new item has been added       
        if(newOT.orderTemplateItems.length > this.mostRecentOrderTemplate.orderTemplateItems.length){
            this.showAddToCartMessage = true;
            this.lastAddedProduct = newOT.orderTemplateItems[0];
            return;
        }
        
        let index = 0;
        
        //Loop over orderTemplateItems to see if quantity has increased on one, if so, the item has been updated
		for(let item of newOT.orderTemplateItems){
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

}
