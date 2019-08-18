/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddOrderItemsBySkuController{

    public addSkuCollection;
    
    public edit:boolean;
    
    public exchangeOrderFlag:boolean;
    
    public order;
    
    public orderFulfillmentId:string;
    
    public accountId:string;
    
    public currencyCode:string;
    
    public simpleRepresentation:string;
    
    public returnOrderId:string;
    
    public skuColumns; 
    
    public skuPropertiesToDisplay:string;
    
    public skuPropertiesToDisplayWithConfig: string;
	
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
	    
		var skuDisplayProperties = "skuCode,skuDefinition,product.productName,price";
		
		if(this.skuPropertiesToDisplay != null){
			// join the two lists.
			skuDisplayProperties = skuDisplayProperties + "," + this.skuPropertiesToDisplay;
			console.log("New joined list", skuDisplayProperties);
		}
	    
        this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
        this.addSkuCollection.setDisplayProperties(skuDisplayProperties,'',{isVisible:true,isSearchable:true,isDeletable:true,isEditable:false});
        this.addSkuCollection.addDisplayProperty('product.productType.productTypeName','Product Type',{isVisible:true,isSearchable:false,isDeletable:false,isEditable:false});
        this.addSkuCollection.addDisplayProperty('skuID','',{isVisible:false,isSearchable:false,isDeletable:false,isEditable:false});
        this.addSkuCollection.addDisplayProperty('imageFile',this.rbkeyService.rbKey('entity.sku.imageFile'),{isVisible:false,isSearchable:true,isDeletable:false})
        this.addSkuCollection.addDisplayProperty('qats','QATS',{isVisible:true,isSearchable:false,isDeletable:false,isEditable:false});
        
        if (this.skuPropertiesToDisplayWithConfig){
        	// this allows passing in display property information. skuPropertiesToDisplayWithConfig is an array of objects
        	var skuPropertiesToDisplayWithConfig = this.skuPropertiesToDisplayWithConfig.replace(/'/g, '"');
        		
        	//now we can parse into a json array
        	var skuPropertiesToDisplayWithConfigObject:any = JSON.parse(skuPropertiesToDisplayWithConfig);
        	
        	//now we can iterate and add the display properties defined on this attribute..
        	for (let property of skuPropertiesToDisplayWithConfigObject){
        		console.log(property);
        		this.addSkuCollection.addDisplayProperty(property.name, property.rbkey, property.config);
        	}
        }
        
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
	    
	    //if this is an exchange order, add a dropdown...
	    if (this.exchangeOrderFlag){
	    	this.skuColumns.push(
	    		{
	            'title': this.rbkeyService.rbKey('define.orderItemType'),
            	'propertyIdentifier':'orderItemTypeSystemCode',
            	'type':'select',
            	'defaultValue':1,
            	'options': [
            		{"name": "Sale Item", "value": "oitSale", "selected": "selected"},
            		{"name": "Return Item", "value":"oitReturn"}
            	],
            	'isCollectionColumn':false,
            	'isEditable':true,
            	'isVisible':true
	        	});
	    }
	    
	    //if we have an order fulfillment, then display the dropdown
	    if (this.orderFulfillmentId != 'new' && this.orderFulfillmentId != ''){
	    	this.skuColumns.push(
	    		{
	            'title': this.rbkeyService.rbKey('define.orderFulfillment'),
            	'propertyIdentifier':'orderFulfillmentID',
            	'type':'select',
            	'defaultValue':1,
            	'options': [
            		{"name": this.simpleRepresentation||"Order Fulfillment", "value": this.orderFulfillmentId, "selected": "selected"},
            		{"name": "New", "value":"new"}
            	],
            	'isCollectionColumn':false,
            	'isEditable':true,
            	'isVisible':true
	        	});
	    }
	    
	    
	    this.observerService.attach(this.addOrderItemListener, "addOrderItem");
        
	}
	
	public postData(url = '', data = {}) {
		
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
		var orderItemTypeSystemCode = payload.orderItemTypeSystemCode ? payload.orderItemTypeSystemCode.value : "oitSale";
		var orderFulfilmentID = (payload.orderFulfillmentID && payload.orderFulfillmentID.value) ? payload.orderFulfillmentID.value : (this.orderFulfillmentId?this.orderFulfillmentId :"new");
		var url = `/Slatwall/?slatAction=entity.processOrder&skuID=${payload.skuID}&price=${payload.price}&quantity=${payload.quantity}&orderID=${this.order}&orderItemTypeSystemCode=${orderItemTypeSystemCode}&processContext=addorderitem&ajaxRequest=1`;
		
		if (orderFulfilmentID && orderFulfilmentID != "new"){
			url = url+"&preProcessDisplayedFlag=1";
		}
		
		var data = { orderFulfillmentID: orderFulfilmentID, quantity:payload.quantity, price: payload.price };
		
		this.postData(url, data)
		.then(data => {
			
			if (data.preProcessView){
				//populate a modal with the template data...
	        	var parsedHtml:any = $.parseHTML( data.preProcessView );
				$('#adminModal').modal();
				// show modal
				(window as any).renderModal(parsedHtml);
			}else{
				//notify the orderitem listing that it needs to refresh itself...
				//get the new persisted values...
				this.observerService.notify("refreshOrderItemListing", {});
				
				//now get the order values because we updated them and pass along to anything listening...
				this.$hibachi.getEntity("Order", this.order).then((data)=>{
		    		this.observerService.notify(`refreshOrder${this.order}`, data);
		        });
			
				//(window as any).location.reload();
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
        accountId: '<?',
        currencyCode: '<?',
        simpleRepresentation: '<?',
        returnOrderId: '<?',
        skuPropertiesToDisplay: '@?',
        skuPropertiesToDisplayWithConfig: '@?',
        edit:"=?",
        exchangeOrderFlag:"=?"
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

