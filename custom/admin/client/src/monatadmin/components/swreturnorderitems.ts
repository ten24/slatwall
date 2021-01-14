import * as bigDecimal from '../inc/bigdecimal.js';

function getDecimalRep(input,scale?){
    
    if(isNaN(input)) return;
    
    if('undefined' == typeof scale){
        scale = 2;
    }
    
    return bigDecimal.BigDecimal(input.toString()).setScale(scale,bigDecimal.RoundingMode.HALF_UP()).longValue();
}

class ReturnOrderItem{
    public orderItemID:string;
    public daysSinceOrderClose:number;
    public orderRefundMultiplier:number=1;
    public allowableRefundPercent:number;
    public quantity:number;
    public sku_calculatedSkuDefinition:string;
    public calculatedDiscountAmount:number;
    public calculatedExtendedPriceAfterDiscount:number;
    public calculatedExtendedPersonalVolumeAfterDiscount:number;
    public calculatedExtendedCommissionableVolumeAfterDiscount:number;
    public calculatedExtendedUnitPriceAfterDiscount:number;
    public calculatedTaxAmount:number;
    public calculatedTaxAmountNotRefunded:number;
    public allocatedOrderDiscountAmount;
    public allocatedOrderPersonalVolumeDiscountAmount:number;
    public allocatedOrderCommissionableVolumeDiscountAmount:number;
    public sku_skuCode:string;
    public sku_product_calculatedTitle:string;
    public calculatedQuantityDeliveredMinusReturns:number;
    public refundTotal:number;
    public refundPVTotal:number;
    public refundCVTotal:number;
    public returnQuantityMaximum:number;
    public total:number;
    public pvTotal:number;
    public cvTotal:number;
    public refundUnitPrice:number;
    public taxTotal:number;
    public taxRefundAmount:number;
    public returnQuantity=0;
    public maxRefund:number;
    public penaltyFreeMaxRefund:number;
    public orderType:string;

    constructor(obj,orderDiscountRatio, orderType){
        obj && Object.assign(this,obj);
        this.refundTotal=0;
        this.orderType = orderType;
        this.returnQuantityMaximum = this.calculatedQuantityDeliveredMinusReturns;
        this.total = this.calculatedExtendedPriceAfterDiscount;
        this.pvTotal = this.calculatedExtendedPersonalVolumeAfterDiscount;
        this.cvTotal = this.calculatedExtendedCommissionableVolumeAfterDiscount;
        this.refundUnitPrice =  this.applyRefundPercentage(this.calculatedExtendedUnitPriceAfterDiscount);
        this.taxTotal = this.applyRefundPercentage(this.calculatedTaxAmount);
        this.taxRefundAmount = 0;
        
        if(this.allocatedOrderDiscountAmount === " "){
            this.allocatedOrderDiscountAmount = null;
        }
        
        if(!this.allocatedOrderDiscountAmount && this.allocatedOrderDiscountAmount !== 0){
            this.allocatedOrderDiscountAmount = this.calculatedExtendedPriceAfterDiscount * orderDiscountRatio;
        }
        
        if(this.refundUnitPrice){
            this.maxRefund = this.refundUnitPrice * this.returnQuantityMaximum;
        }else{
            this.maxRefund =  this.applyRefundPercentage(this.total);
        }
        if(this.calculatedExtendedUnitPriceAfterDiscount){
            this.penaltyFreeMaxRefund = this.calculatedExtendedUnitPriceAfterDiscount * this.returnQuantityMaximum;
        }else{
            this.penaltyFreeMaxRefund = this.total;
        }
        return this;
    }
    
    
    //  Following equations have a (this.maxRefund / this.total) term included in order to get the remaining values
    
    public getAllocatedRefundOrderDiscountAmount = ()=>{
        if(this.returnQuantity >= 0){
            
            return getDecimalRep( (this.allocatedOrderDiscountAmount * this.refundTotal * this.penaltyFreeMaxRefund / Math.pow(this.total,2)) );
        }
        return 0;
    }
    
    public getAllocatedRefundOrderPVDiscountAmount = ()=>{
        if(this.returnQuantity >= 0){
            return getDecimalRep( (this.allocatedOrderPersonalVolumeDiscountAmount * this.refundPVTotal * this.penaltyFreeMaxRefund / (this.pvTotal * this.total)) );
        }
        return 0;
    }
    
    public getAllocatedRefundOrderCVDiscountAmount = ()=>{
        if(this.returnQuantity >= 0){
            return getDecimalRep( (this.allocatedOrderCommissionableVolumeDiscountAmount * this.refundCVTotal * this.penaltyFreeMaxRefund / (this.cvTotal * this.total) ) );
        }
        return 0;
    }

    public applyRefundPercentage = (value) =>{
        if(this.orderType == 'otReturnOrder'){
            return getDecimalRep(value * (this.allowableRefundPercent /100))
        }
        return value
    }
}

class SWReturnOrderItemsController{
    private orderId:string;
    private displayPropertiesList:string;
    private currencyCode:string;
    private orderTotal:number;
    private originalOrderSubtotal:number;
    public orderType:string;
    public orderItemCollectionList;
    private refundOrderItems;
    public orderItems:Array<ReturnOrderItem>;
    public orderPayments:Array<any> = [];
    public refundSubtotal:number=0;
    public refundTotal:number=0;
    public refundPVTotal:number=0;
    public refundCVTotal:number=0;
    public initialFulfillmentRefundAmount:string;
    public fulfillmentRefundAmount:number;
    public maxFulfillmentRefundAmount:number;
    public allocatedOrderDiscountAmountTotal;
    public allocatedOrderPVDiscountAmountTotal;
    public allocatedOrderCVDiscountAmountTotal;
    public currencySymbol:string;
    public fulfillmentTaxAmount:number;
    public fulfillmentRefundTaxAmount:number=0;
    public fulfillmentRefundTotal:number;
    public orderDiscountAmount:number;
    public maxRefundAmount:number;
    
    public setupOrderItemCollectionList = ( orderDiscountRatio ) =>{
        this.orderItemCollectionList = this.collectionConfigService.newCollectionConfig("OrderItem");
        for(let displayProperty of this.displayPropertiesList.split(',')){
            this.orderItemCollectionList.addDisplayProperty(displayProperty);
        }
        this.orderItemCollectionList.addFilter("order.orderID", this.orderId, "=");
        this.orderItemCollectionList.setAllRecords(true);
        this.orderItemCollectionList.getEntity().then(result=>{
            for(let i = 0; i < result.records.length; i++){
                result.records[i] = new ReturnOrderItem( result.records[i], orderDiscountRatio, this.orderType );
                this.orderTotal += result.records[i].allocatedOrderDiscountAmount;
            }
            this.orderItems = result.records;
        })
    
    }
    
    public getDisplayPropertiesList = () =>{

        return `orderItemID,
                quantity,
                sku.calculatedSkuDefinition,
                calculatedDiscountAmount,
                allowableRefundPercent,
                calculatedExtendedPriceAfterDiscount,
                calculatedExtendedUnitPriceAfterDiscount,
                calculatedTaxAmount,
                calculatedTaxAmountNotRefunded,
                allocatedOrderDiscountAmount,
                allocatedOrderPersonalVolumeDiscountAmount,
                allocatedOrderCommissionableVolumeDiscountAmount,
                sku.skuCode,
                sku.product.calculatedTitle,
                calculatedQuantityDeliveredMinusReturns,
                calculatedExtendedPersonalVolumeAfterDiscount,
                calculatedExtendedCommissionableVolumeAfterDiscount`.replace(/\s+/gi,'');
    }
    
    constructor(
        public $hibachi,
        public publicService,
        private collectionConfigService
    ){
        this.maxFulfillmentRefundAmount = getDecimalRep(this.initialFulfillmentRefundAmount);
        this.fulfillmentRefundAmount = 0;
        if(this.fulfillmentTaxAmount == undefined){
            this.fulfillmentTaxAmount = 0;
        }
        let orderDiscountRatio;
        if(this.originalOrderSubtotal){
            orderDiscountRatio = this.orderDiscountAmount / this.originalOrderSubtotal;
        }
        
        if(this.refundOrderItems == undefined){
            this.displayPropertiesList = this.getDisplayPropertiesList();
            this.setupOrderItemCollectionList(orderDiscountRatio);
        }else{
            this.orderItems = this.refundOrderItems.map(item=>{
                item.calculatedExtendedPriceAfterDiscount = this.orderTotal;
                return new ReturnOrderItem( item, orderDiscountRatio, this.orderType)
            });
        }
        
        $hibachi.getCurrencies().then(result=>{
            this.currencySymbol = result.data[this.currencyCode]['currencySymbol'];
        })
    }
    public applyRefundPercentage = (orderItem, value) =>{
        if(this.orderType == 'otReturnOrder'){
            return getDecimalRep(value * (orderItem.allowableRefundPercent / 100))
        }
        return value
    }
    
    public updateOrderItem = (orderItem,maxRefund,attemptNum) => {

       let orderMaxRefund:number;
       if(!attemptNum){
           attemptNum = 0;
       }
       attemptNum++;
       orderItem = this.setValuesWithinConstraints(orderItem);

       orderItem.refundTotal = orderItem.returnQuantity * orderItem.refundUnitPrice;

       if(orderItem.returnQuantity > 0 && orderItem.total > 0){

           orderItem.refundUnitPV = orderItem.refundTotal * orderItem.pvTotal / ( this.applyRefundPercentage(orderItem, orderItem.total) * orderItem.returnQuantity);
           orderItem.refundPVTotal = getDecimalRep( orderItem.refundUnitPV * orderItem.returnQuantity );
           orderItem.refundUnitCV = orderItem.refundTotal * orderItem.cvTotal / (this.applyRefundPercentage(orderItem, orderItem.total) * orderItem.returnQuantity);
           orderItem.refundCVTotal = getDecimalRep( orderItem.refundUnitCV * orderItem.returnQuantity );

       }else{
           orderItem.refundUnitPV = 0;
           orderItem.refundPVTotal = 0;
           orderItem.refundUnitCV = 0;
           orderItem.refundCVTotal = 0;
       }

       orderItem.taxRefundAmount = getDecimalRep(  orderItem.taxTotal * orderItem.returnQuantity / orderItem.quantity );

       if('undefined' != typeof orderItem.calculatedTaxAmountNotRefunded){
            orderItem.taxRefundAmount = Math.min(orderItem.taxRefundAmount,orderItem.calculatedTaxAmountNotRefunded);

       }
       if(maxRefund == undefined){
           let refundTotal = this.orderItems.reduce((total:number,item:any)=>{
               return (item == orderItem) ?  total : total += item.refundTotal;
           },0);

            orderMaxRefund = this.orderTotal - refundTotal;
            maxRefund = Math.min(orderMaxRefund,orderItem.maxRefund);

        }
       
       if((orderItem.refundTotal > maxRefund)){
           orderItem.refundUnitPrice = (Math.max(maxRefund,0) / orderItem.returnQuantity);
           orderItem.refundTotal = getDecimalRep( orderItem.refundUnitPrice * orderItem.quantity);
           orderItem.refundUnitPrice = getDecimalRep( orderItem.refundUnitPrice);
           if(attemptNum > 2){
               maxRefund += 0.01;
           }
           this.updateOrderItem(orderItem,maxRefund,attemptNum);
       }else{
            this.updateTotals();
       }
    }
   
    private setValuesWithinConstraints = (orderItem)=>{
        var returnQuantityMaximum = orderItem.returnQuantityMaximum;
        
        if (orderItem.returnQuantity == null || orderItem.returnQuantity == undefined || orderItem.returnQuantity < 0) {
            orderItem.returnQuantity = 0;
        }
        
        
        if(orderItem.returnQuantity > returnQuantityMaximum){
            orderItem.returnQuantity = returnQuantityMaximum;
        }
        
        if (orderItem.refundUnitPrice == null || orderItem.refundUnitPrice == undefined || orderItem.refundUnitPrice < 0) {
            orderItem.refundUnitPrice = 0;
        }
        if(this.orderType == 'otRefundOrder'){
            if(orderItem.refundUnitPrice != 0){
                orderItem.returnQuantity = 1;
            }else{
                orderItem.returnQuantity = 0;
            }
        }
        return orderItem;
    } 
   
    private updateTotals = () =>{
        
        if(!this.maxRefundAmount){
            let maxRefundAmount = 0;
            for(let i=0; i<this.orderPayments.length; i++){
                maxRefundAmount += this.orderPayments[i].amountToRefund;
            }
            this.maxRefundAmount = maxRefundAmount;
        }
        
        this.updateRefundTotals();
        this.updatePaymentTotals();
    }
   
    private updateRefundTotals = () =>{
        
        if(!this.orderItems) return;
        
        let refundSubtotal = 0;
        let refundPVTotal = 0;
        let refundCVTotal = 0;
        let allocatedOrderDiscountAmountTotal = 0;
        let allocatedOrderPVDiscountAmountTotal = 0;
        let allocatedOrderCVDiscountAmountTotal = 0;
        let modifiedUnitPriceFlag = false;
        
        this.orderItems.forEach((item:any)=>{
            refundSubtotal += item.refundTotal + ( item.taxRefundAmount || 0 );
            refundPVTotal += item.refundPVTotal;
            refundCVTotal += item.refundCVTotal;
            allocatedOrderDiscountAmountTotal += item.getAllocatedRefundOrderDiscountAmount() || 0;
            allocatedOrderPVDiscountAmountTotal += item.getAllocatedRefundOrderPVDiscountAmount() || 0;
            allocatedOrderCVDiscountAmountTotal += item.getAllocatedRefundOrderCVDiscountAmount() || 0;
            
            if(item.refundUnitPrice != item.calculatedExtendedUnitPriceAfterDiscount){
                modifiedUnitPriceFlag = true;
            }
        })
        
        this.publicService.modifiedUnitPrices = modifiedUnitPriceFlag;
        
        this.allocatedOrderDiscountAmountTotal = allocatedOrderDiscountAmountTotal;
        if(this.orderDiscountAmount){
            this.allocatedOrderDiscountAmountTotal = Math.min(this.orderDiscountAmount,this.allocatedOrderDiscountAmountTotal);
        }
        this.allocatedOrderPVDiscountAmountTotal = allocatedOrderPVDiscountAmountTotal;
        this.allocatedOrderCVDiscountAmountTotal = allocatedOrderCVDiscountAmountTotal;

        this.refundSubtotal = refundSubtotal;

        this.fulfillmentRefundTotal = this.fulfillmentRefundAmount + this.fulfillmentRefundTaxAmount;
        this.refundTotal = getDecimalRep((refundSubtotal + this.fulfillmentRefundTotal - this.allocatedOrderDiscountAmountTotal));
        this.refundTotal = Math.min(this.maxRefundAmount,this.refundTotal);
        this.refundPVTotal = getDecimalRep(refundPVTotal);
        this.refundCVTotal = getDecimalRep(refundCVTotal);
    }
   
   private updatePaymentTotals = ()=>{
       for(let i = this.orderPayments.length - 1; i >= 0; i--){
            this.validateAmount(this.orderPayments[i]);
       }
   }
   
   public validateFulfillmentRefundAmount = ()=>{
       if(this.fulfillmentRefundAmount > this.maxFulfillmentRefundAmount){
           this.fulfillmentRefundAmount = this.maxFulfillmentRefundAmount;
       }
       if(this.fulfillmentRefundAmount < 0){
           this.fulfillmentRefundAmount = 0;
       }
       if(this.fulfillmentRefundAmount > 0){
            this.fulfillmentRefundTaxAmount = this.fulfillmentTaxAmount * this.fulfillmentRefundAmount / this.maxFulfillmentRefundAmount;
       }else{
           this.fulfillmentRefundTaxAmount = 0;
       }
       this.updateTotals();
   }
   
   public validateAmount = (orderPayment)=>{
        let nonGiftCardPaymentCount = orderPayment.paymentMethodType == 'giftCard' ? 0 : 1;
        if(orderPayment.amount < 0){
            orderPayment.amount = 0;
        }
        const paymentTotal = this.orderPayments.reduce((total:number,payment:any)=>{
           if(payment != orderPayment){
               if(payment.paymentMethodType == 'giftCard'){
                   payment.amount = Math.min(payment.amountToRefund,this.refundTotal);
               }else{
                   nonGiftCardPaymentCount++;
               }
               return total += payment.amount;
           }
           return total;
        },0);
        
        const maxRefund = Math.min(orderPayment.amountToRefund,this.refundTotal - paymentTotal);
        
        const assignMaxRefundFlag = (nonGiftCardPaymentCount == 1 && orderPayment.paymentMethodType != 'giftCard');
        
        if(assignMaxRefundFlag || orderPayment.amount > maxRefund){
            orderPayment.amount = getDecimalRep(Math.max(maxRefund,0));
        }
        
        if(orderPayment.amount == undefined){
           orderPayment.amount = 0;
        }
   }

}

class SWReturnOrderItems {

	public restrict:string;
	public templateUrl:string;
	public scope=true;
	public bindToController = {
	    orderId:'@',
	    currencyCode:'@',
	    initialFulfillmentRefundAmount:'@',
	    orderPayments:'<',
	    refundOrderItems:'<?',
	    orderType:'@',
	    orderTotal:'<?',
	    fulfillmentTaxAmount:'@',
	    orderDiscountAmount:'<?',
	    originalOrderSubtotal:'<?'
	};
	public controller=SWReturnOrderItemsController;
	public controllerAs="swReturnOrderItems";

	public static Factory(){
        var directive:any = (
			$hibachi,
			monatBasePath
        ) => new SWReturnOrderItems(
			$hibachi,
			monatBasePath
        );
        directive.$inject = [
			'$hibachi',
			'monatBasePath'
        ];
        return directive;
    }

	constructor(private $hibachi, private monatBasePath){
		this.restrict = "E";
		this.templateUrl = monatBasePath + "/monatadmin/components/returnorderitems.html";
	}

	public link = (scope, element, attrs) =>{
	}

}

export {
	SWReturnOrderItems
};