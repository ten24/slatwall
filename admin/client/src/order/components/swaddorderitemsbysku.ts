/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddOrderItemsBySkuController{

    public addSkuCollection;
    
    public edit:boolean;
    
    public order;
    
    public orderFulfillmentId:string;
    
    public skuColumns; 
    
    public skuPropertiesToDisplay:string;
	
	constructor(public $hibachi,
	            public collectionConfigService, 
				public observerService,
	            public orderTemplateService,
				public rbkeyService){
		if(this.edit == null){
			this.edit = false;
		}
	}
	
	public $onInit = () =>{
			    
	    this.observerService.attach(this.setEdit,'swEntityActionBar')
	    
		//var orderTemplateDisplayProperties = "sku.skuCode,sku.skuDefinition,sku.product.productName,sku.price,total";
		var skuDisplayProperties = "skuCode,skuDefinition,product.productName,price";
		
		if(this.skuPropertiesToDisplay != null){
			var properties = this.skuPropertiesToDisplay.split(',');
			
			for(var i=0; i<properties.length; i++){
				skuDisplayProperties += ',' + properties[i];
			}
			
		}
	    
        this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
        this.addSkuCollection.setDisplayProperties(skuDisplayProperties,'',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});
        this.addSkuCollection.addDisplayProperty('skuID','',{isVisible:false,isSearchable:false,isDeletable:false,isEditable:false});
        this.addSkuCollection.addDisplayProperty('imageFile',this.rbkeyService.rbKey('entity.sku.imageFile'),{isVisible:false,isSearchable:true,isDeletable:false})
        this.addSkuCollection.addFilter('activeFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('publishedFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('product.activeFlag', true,'=',undefined,true);
        this.addSkuCollection.addFilter('product.publishedFlag', true,'=',undefined,true);

	    this.skuColumns = angular.copy(this.addSkuCollection.getCollectionConfig().columns);
	    
	    this.skuColumns.push(
	        {
	            'title': this.rbkeyService.rbKey('define.quantity'),
            	'propertyIdentifier':'quantity',
            	'type':'number',
            	'defaultValue':1,
            	'isCollectionColumn':false,
            	'isEditable':true,
            	'isVisible':true
	        },
	        {
	            'title': this.rbkeyService.rbKey('define.price'),
            	'propertyIdentifier':'price',
            	'type':'number',
            	'isCollectionColumn':true,
            	'isEditable':true,
            	'isVisible':true
	        }
	    );
	    
	    this.observerService.attach(this.addOrderItemListener, "addOrderItem");
        
	}
	
	public postData(url = '', data = {}) {
		console.log("Posting data");
	    return fetch(url, {
	        method: 'post',
	        mode: 'cors', // no-cors, cors, *same-origin
	        cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
	        credentials: 'same-origin', // include, *same-origin, omit
	        headers: {
	            'Content-Type': 'X-Hibachi-AJAX',
	            // 'Content-Type': 'application/x-www-form-urlencoded',
	        },
	        redirect: 'follow', // manual, *follow, error
	        referrer: 'no-referrer', // no-referrer, *client
	        body: JSON.stringify(data), // body data type must match "Content-Type" header
	    })
    	.then(response => response.json()); // parses JSON response into native JavaScript objects 
	};
	
	public addOrderItemListener = (payload)=> {
		//figure out if we need to show this modal or not.
		console.log( "Add Order Item Listener Called", this.order, payload, this.orderFulfillmentId );
		
		//need to display a modal with the add order item preprocess method.
		var typeSystemCode = 'oitSale';
		var orderFulfilmentID = this.orderFulfillmentId;
		var url = `/Slatwall/?slatAction=entity.processOrder&skuID=${payload.skuID}&orderID=${this.order}&orderItemTypeSystemCode=${typeSystemCode}&processContext=addorderitem&ajaxRequest=1`;
		
		if (orderFulfilmentID && orderFulfilmentID != "new"){
			url = url+"&preProcessDisplayedFlag=1";
		}
		
		var data = { orderFulfillmentID: orderFulfilmentID, quantity:payload.quantity, price: payload.price };
		
		this.postData(url, data)
		.then(data => {
			console.log(data);
			if (data.preProcessView){
				//populate a modal with the template data...
	        	var parsedHtml:any = $.parseHTML( data.preProcessView );
				$('#adminModal').modal();
				// show modal
				(window as any).renderModal(parsedHtml);
			}
		}) // JSON-string from `response.json()` call
		.catch(error => console.error(error));
	
	}
	
	public setEdit = (payload)=>{
	    this.edit = payload.edit;
	}
	
}

class SWAddOrderItemsBySku implements ng.IDirective {

	public restrict:string = "EA";
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        order: '<?', 
        orderFulfillmentId: '<?',
        skuPropertiesToDisplay: '@?',
        edit:"=?"
	};
	public controller=SWAddOrderItemsBySkuController;
	public controllerAs="swAddOrderItemsBySku";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWAddOrderItemsBySku(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/addorderitemsbysku.html";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWAddOrderItemsBySku
};

