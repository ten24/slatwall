/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component displayname="OrderTemplateItem" entityname="SlatwallOrderTemplateItem" table="SwOrderTemplateItem" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="this" hb_processContexts="" {

	property name="orderTemplateItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="orderTemplate" hb_populateEnabled="false" cfc="OrderTemplate" fieldtype="many-to-one" fkcolumn="orderTemplateID" hb_cascadeCalculate="true" fetch="join";
	property name="temporaryFlag" ormtype="boolean" default="false";

	property name="calculatedTotal" ormtype="big_decimal" hb_formatType="currency"; 
	property name="calculatedTaxableAmountTotal" ormtype="big_decimal" hb_formatType="currency";  

	// Remote properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";	

	//non-persistents	
	property name="total" persistent="false" hb_formatType="currency"; 
	property name="taxableAmountTotal" persistent="false";  
	

	public numeric function getTotal(){
		
		if(!structKeyExists(variables, 'total')){
			variables.total = 0; 
			
			if(!isNull(getSku()) && !isNull(getQuantity())){
				
				var rewardSkuSalePriceDetails = getService('PromotionService').getOrderTemplateItemSalePricesByPromoRewardSkuCollection(this); 
				if( !isNull(rewardSkuSalePriceDetails) ) {
					variables.total += rewardSkuSalePriceDetails[this.getOrderTemplateItemID()]['salePrice'] * getQuantity();
				}
			} 	
		}
		
		return variables.total;
	} 
	
	public numeric function getTaxableAmountTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'taxableAmountTotal')){
			variables.taxableAmountTotal = 0; 	
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.taxableAmountTotal += (this.getSku().getTaxableAmountByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}
		}
		return variables.taxableAmountTotal; 	

	} 

	public void function setOrderTemplate(required any orderTemplate) {
		variables.orderTemplate = arguments.orderTemplate;
		if(isNew() or !arguments.orderTemplate.hasOrderTemplateItem( this )) {
			arrayAppend(arguments.orderTemplate.getOrderTemplateItems(), this);
		}
	}
	public void function removeOrderTemplate(any orderTemplate) {
		if(!structKeyExists(arguments, "orderTemplate")) {
			arguments.orderTemplate = variables.orderTemplate;
		}
		var index = arrayFind(arguments.orderTemplate.getOrderTemplateItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderTemplate.getOrderTemplateItems(), index);
		}
		structDelete(variables, "orderTemplate");
	}		
}
