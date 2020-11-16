component extends="Slatwall.model.entity.HibachiEntity" displayname="OrderImportBatchItem" entityname="SlatwallOrderImportBatchItem" table="SwOrderImportBatchItem" persistent="true" output="false" accessors="true" cacheuse="transactional" hb_serviceName="orderImportBatchService" hb_permission="this"{

    property name="orderImportBatchItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    
    property name="skuCode" ormtype="string";
    property name="quantity" ormtype="integer";
    property name="accountNumber" ormtype="integer";
    property name="originalOrderNumber" ormtype="integer";
	property name="processingErrors" ormtype="string" length="1500";
	
    property name="replacementNumber" ormtype="integer";
    property name="name" ormtype="string";
    property name="streetAddress" ormtype="string";
    property name="street2Address" ormtype="string";
    property name="city" ormtype="string";
    property name="stateCode" ormtype="string";
    property name="locality" ormtype="string";
    property name="postalCode" ormtype="string";
    property name="countryCode" ormtype="string";
    property name="phoneNumber" ormtype="string";

    // Related Object Properties (many-to-one)
    property name="order" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
    property name="account" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
    property name="orderItem" hb_populateEnabled="false" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
    property name="originalOrder" hb_populateEnabled="false" cfc="Order" fieldtype="many-to-one" fkcolumn="originalOrderID";
    property name="shippingAddress" hb_populateEnabled="false" cfc="Address" fieldtype="many-to-one" fkcolumn="shippingAddressID";
    property name="sku"  hb_populateEnabled="false" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
    property name="orderImportBatch" cfc="OrderImportBatch" fieldtype="many-to-one" fkcolumn="orderImportBatchID";
    property name="orderImportBatchItemStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderImportBatchItemStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=orderImportBatchItemStatusType";

    // Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	public void function setOrderImportBatch(required any orderImportBatch){
	    variables.orderImportBatch = arguments.orderImportBatch;
	    orderImportBatch.addOrderImportBatchItem(this);
	}
	
	public void function populateShippingFieldsFromShippingAddress(required any shippingAddress){
	    
	    if(!isNull(arguments.shippingAddress.getName())){
	        setName(arguments.shippingAddress.getName());
	    }
	    if(!isNull(arguments.shippingAddress.getStreetAddress())){
	        setStreetAddress(arguments.shippingAddress.getStreetAddress());
	    }
	    if(!isNull(arguments.shippingAddress.getStreet2Address())){
	        setStreet2Address(arguments.shippingAddress.getStreet2Address());
	    }
	    if(!isNull(arguments.shippingAddress.getCity())){
	        setCity(arguments.shippingAddress.getCity());
	    }
	    if(!isNull(arguments.shippingAddress.getStateCode())){
	        setStateCode(arguments.shippingAddress.getStateCode());
	    }
	    if(!isNull(arguments.shippingAddress.getLocality())){
	        setLocality(arguments.shippingAddress.getLocality());
	    }
	    if(!isNull(arguments.shippingAddress.getPostalCode())){
	        setPostalCode(arguments.shippingAddress.getPostalCode());
	    }
	    if(!isNull(arguments.shippingAddress.getCountryCode())){
	        setCountryCode(arguments.shippingAddress.getCountryCode());
	    }
	    if(!isNull(arguments.shippingAddress.getPhoneNumber())){
	        setPhoneNumber(arguments.shippingAddress.getPhoneNumber());
	    }
	    
	}
} 