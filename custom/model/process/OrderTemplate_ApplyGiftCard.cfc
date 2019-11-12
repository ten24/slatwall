component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

	property name="orderTemplate"; 

	property name="amountToApply";
	property name="giftCardID";

	property name="giftCard"; 
	
	property name="siteMaximumGiftCardAmount" persistent="false"; 

	public any function getGiftCard(){
		if(structKeyExists(variables, 'giftCardID')){ 
			return getService('GiftCardService').getGiftCard(variables.giftCardID); 
		} 
	} 

	public numeric function getSiteMaximumGiftCardAmount(){
		if(!isNull(getOrderTemplate()) && 
			!isNull(getOrderTemplate().getSite()) 
		){
			return getOrderTemplate().getSite().setting('integrationmonatSiteMaximumFlexshipGiftCardAmount');  
		}
	} 	
}

