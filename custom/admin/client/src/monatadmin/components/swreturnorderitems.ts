class ReturnOrderItem{
    public orderItemID:string;
    public quantity:number;
    public sku_calculatedSkuDefinition:string;
    public calculatedDiscountAmount:number;
    public calculatedExtendedPriceAfterDiscount:number;
    public calculatedExtendedUnitPriceAfterDiscount:number;
    public calculatedTaxAmount:number;
    public allocatedOrderDiscountAmount:number;
    public sku_skuCode:string;
    public sku_product_calculatedTitle:string;
    public calculatedQuantityDeliveredMinusReturns:number;
    public refundTotal:number;
    public returnQuantityMaximum:number;
    public total:number;
    public refundUnitPrice:number;
    public taxTotal:number;
    public taxRefundAmount:number;
    public returnQuantity=0;
    
    constructor(obj){
        obj && Object.assign(this,obj);
        this.refundTotal=0;
        this.returnQuantityMaximum = this.calculatedQuantityDeliveredMinusReturns;
        this.total = this.calculatedExtendedPriceAfterDiscount;
        this.refundUnitPrice = this.calculatedExtendedUnitPriceAfterDiscount;
        this.taxTotal = this.calculatedTaxAmount;
        this.taxRefundAmount = 0;

        return this;
    }
    
    public getAllocatedRefundOrderDiscountAmount = ()=>{
        if(this.returnQuantity >= 0){
            return Math.round(this.allocatedOrderDiscountAmount * this.refundTotal * 100 / this.total) / 100;
        }
        return 0;
    }
}

class SWReturnOrderItemsController{
    private orderId:string;
    private displayPropertiesList:string;
    private currencyCode:string;
    private orderTotal:number;
    
    public orderType:string;
    public orderItemCollectionList;
    private refundOrderItems;
    public orderItems:Array<ReturnOrderItem>;
    public orderPayments:Array<Object> = [];
    public refundSubtotal:number=0;
    public refundTotal:number=0;
    public initialFulfillmentRefundAmount:string;
    public fulfillmentRefundAmount:number;
    public maxFulfillmentRefundAmount:number;
    public allocatedOrderDiscountAmountTotal;
    public currencySymbol:string;

    public setupOrderItemCollectionList = () =>{
        this.orderItemCollectionList = this.collectionConfigService.newCollectionConfig("OrderItem");
        for(let displayProperty of this.displayPropertiesList.split(',')){
            this.orderItemCollectionList.addDisplayProperty(displayProperty);
        }
        this.orderItemCollectionList.addFilter("order.orderID", this.orderId, "=");
        this.orderItemCollectionList.setAllRecords(true);
        this.orderItemCollectionList.getEntity().then(result=>{
            for(let i = 0; i < result.records.length; i++){
                result.records[i] = new ReturnOrderItem(result.records[i]);
            }
            this.orderItems = result.records;
        })
    
    }
    
    public getDisplayPropertiesList = () =>{

        return `orderItemID,
                quantity,
                sku.calculatedSkuDefinition,
                calculatedDiscountAmount,
                calculatedExtendedPriceAfterDiscount,
                calculatedExtendedUnitPriceAfterDiscount,
                calculatedTaxAmount,
                allocatedOrderDiscountAmount,
                sku.skuCode,
                sku.product.calculatedTitle,
                calculatedQuantityDeliveredMinusReturns`.replace(/\s+/gi,'');
                
                // calculatedExtendedPersonalVolumeAfterDiscount,
                // calculatedExtendedCommissionableVolumeAfterDiscount,
                
    }
    
    constructor(
        public $hibachi,
        private collectionConfigService
    ){
        this.fulfillmentRefundAmount = Number(this.initialFulfillmentRefundAmount);
        this.maxFulfillmentRefundAmount = this.fulfillmentRefundAmount;
        
        if(this.refundOrderItems == undefined){
            this.displayPropertiesList = this.getDisplayPropertiesList();
            this.setupOrderItemCollectionList();
        }else{
            this.orderItems = this.refundOrderItems.map(item=>{return new ReturnOrderItem(item)});
        }
        
        $hibachi.getCurrencies().then(result=>{
            this.currencySymbol = result.data[this.currencyCode];
        })
    }

    public updateOrderItem = (orderItem) => {
       
       orderItem = this.setValuesWithinConstraints(orderItem);

       orderItem.refundTotal = orderItem.returnQuantity * orderItem.refundUnitPrice;
        
       this.validateRefundItemAmount(orderItem);
       
       orderItem.taxRefundAmount = orderItem.taxTotal / orderItem.quantity * orderItem.returnQuantity;
       
       if((orderItem.refundTotal > orderItem.total) && this.orderType != 'otRefundOrder'){
           orderItem.refundUnitPrice = orderItem.total / orderItem.returnQuantity;
           this.updateOrderItem(orderItem);
       }else{
            this.updateTotals();
       }
    }
   
    private setValuesWithinConstraints = (orderItem)=>{
        var returnQuantityMaximum = orderItem.returnQuantityMaximum;
        
        if (orderItem.returnQuantity == null || orderItem.returnQuantity == undefined) {
            orderItem.returnQuantity = 0;
        }
        
        
        if(orderItem.returnQuantity > returnQuantityMaximum){
            orderItem.returnQuantity = returnQuantityMaximum;
        }
        
        if (orderItem.refundUnitPrice == null || orderItem.refundUnitPrice == undefined) {
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
        this.updateRefundTotals();
        this.updatePaymentTotals();
    }
   
    private updateRefundTotals = () =>{
       let refundSubtotal = 0;
       let allocatedOrderDiscountAmountTotal = 0;
        
        this.orderItems.forEach((item:any)=>{
            refundSubtotal += item.refundTotal + item.taxRefundAmount;
            allocatedOrderDiscountAmountTotal += item.getAllocatedRefundOrderDiscountAmount();
        })
        this.allocatedOrderDiscountAmountTotal = allocatedOrderDiscountAmountTotal;

        this.refundSubtotal = refundSubtotal;

        this.refundTotal = Number((refundSubtotal + this.fulfillmentRefundAmount - this.allocatedOrderDiscountAmountTotal).toFixed(2));
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
       this.updateRefundTotals();
   }
   
   public validateAmount = (orderPayment)=>{

       const paymentTotal = this.orderPayments.reduce((total:number,payment:any)=>{
           return (payment == orderPayment) ?  total : total += payment.amount;
       },0);
       
       const maxRefund = Math.min(orderPayment.amountToRefund,this.refundTotal - paymentTotal);

       if(orderPayment.amount == undefined){
           orderPayment.amount = 0;
       }
       if(orderPayment.amount > maxRefund){
           orderPayment.amount = Number((Math.max(maxRefund,0)).toFixed(2));
       }
   }
   
   public validateRefundItemAmount = (orderItem)=>{

       const refundTotal = this.orderItems.reduce((total:number,item:any)=>{
           return (item == orderItem) ?  total : total += item.refundTotal;
       },0);
       
       const maxRefund = this.orderTotal - refundTotal;

       if(orderItem.refundTotal > maxRefund){
           orderItem.refundUnitPrice = Number((Math.max(maxRefund,0)).toFixed(2));
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
	    orderTotal:'<?'
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