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
	
	//CUSTOM PROPERTIES BEGIN
property name="calculatedCommissionableVolumeTotal" ormtype="integer";
	property name="calculatedPersonalVolumeTotal" ormtype="integer";
	property name="calculatedProductPackVolumeTotal" ormtype="integer"; 
	property name="calculatedRetailCommissionTotal" ormtype="integer"; 
	property name="calculatedListPrice" ormtype="big_decimal" hb_formatType="currency";
	
	//non-persistent properties
	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false";
	property name="productPackVolumeTotal" persistent="false"; 
	property name="retailComissionTotal" persistent="false"; 
	property name="skuProductURL" persistent="false";
	property name="skuImagePath" persistent="false";
	property name="skuAdjustedPricing" persistent="false";
	property name="kitFlagCode" ormtype="string";
	property name="skuPriceByCurrencyCode" persistent="false" hb_formatType="currency";
	property name="listPrice" persistent="false";
	
//CUSTOM PROPERTIES END
	

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
	//CUSTOM FUNCTIONS BEGIN

public any function getSkuProductURL(){
		var skuProductURL = this.getSku().getProduct().getProductURL();
		return skuProductURL;
	}
	
	public any function getSkuImagePath(){
		var skuImagePath = this.getSku().getImagePath();
		return skuImagePath;
	}

	public numeric function getSkuPriceByCurrencyCode(){
		var priceGroups = !isNull(this.getOrderTemplate().getAccount()) ? this.getOrderTemplate().getAccount().getPriceGroups() : [this.getOrderTemplate().getPriceGroup()];
		return sku.getPriceByCurrencyCode(currencyCode=this.getOrderTemplate().getCurrencyCode(), priceGroups=priceGroups);   
	} 
	
	public any function getSkuAdjustedPricing(){
			
			var priceGroups = !isNull(this.getOrderTemplate().getAccount()) ? this.getOrderTemplate().getAccount().getPriceGroups() : [this.getOrderTemplate().getPriceGroup()];
			var priceGroupCode = arrayLen(priceGroups) ? priceGroups[1].getPriceGroupCode() : "";
			var priceGroupService = getHibachiScope().getService('priceGroupService');
			var hibachiUtilityService = getHibachiScope().getService('hibachiUtilityService');
			var currencyCode = this.getOrderTemplate().getCurrencyCode() ?: 'USD';
			var vipPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(3);
			var retailPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(2);
			var mpPriceGroup = priceGroupService.getPriceGroupByPriceGroupCode(1);
			var sku = this.getSku();
			var adjustedAccountPrice = sku.getPriceByCurrencyCode(currencyCode) ?: 0;
			var adjustedVipPrice = sku.getPriceByCurrencyCode(currencyCode,1,[vipPriceGroup]) ?: 0;
			var adjustedRetailPrice = sku.getPriceByCurrencyCode(currencyCode,1,[retailPriceGroup]) ?: 0;
			var adjustedMPPrice = sku.getPriceByCurrencyCode(currencyCode,1,[MPPriceGroup]) ?: 0;
			var mpPersonalVolume = sku.getPersonalVolumeByCurrencyCode(currencyCode)?:0;
			
			// var formattedAccountPricing = hibachiUtilityService.formatValue_currency(adjustedAccountPrice, {currencyCode:currencyCode});
			// var formattedVipPricing = hibachiUtilityService.formatValue_currency(adjustedVipPrice, {currencyCode:currencyCode});
			// var formattedRetailPricing = hibachiUtilityService.formatValue_currency(adjustedRetailPrice, {currencyCode:currencyCode});
			// var formattedMPPricing = hibachiUtilityService.formatValue_currency(adjustedMPPrice, {currencyCode:currencyCode});
			
			var skuAdjustedPricing = {
				adjustedPriceForAccount = adjustedAccountPrice,
				vipPrice = adjustedVipPrice,
				retailPrice = adjustedRetailPrice,
				MPPrice = adjustedMPPrice,
				personalVolume = mpPersonalVolume,
				accountPriceGroup = priceGroupCode
			};
	
			return skuAdjustedPricing;
	}

	public numeric function getProductPackVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'productPackVolumeTotal')){
			variables.productPackVolumeTotal = 0;
				
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.productPackVolumeTotal += (this.getSku().getProductPackVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}
		}
		return variables.productPackVolumeTotal; 	
	}	

	public numeric function getRetailCommissionTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'retailComissionTotal')){
			variables.retailComissionTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.retailComissionTotal += (this.getSku().getRetailCommissionByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}
		}
		return variables.retailComissionTotal; 	

	} 

	
	public numeric function getCommissionVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'commissionVolumeTotal')){
			variables.commissionVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.commissionVolumeTotal += (this.getSku().getCommissionableVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}	
		}
		return variables.commissionVolumeTotal; 	
	}	

	public numeric function getPersonalVolumeTotal(string currencyCode, string accountID){
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getQuantity())
			){
				variables.personalVolumeTotal += (this.getSku().getPersonalVolumeByCurrencyCode(argumentCollection=arguments) * this.getQuantity()); 
			}	
		}
		return variables.personalVolumeTotal; 	
	} 
	
	public numeric function getListPrice(){

		if(!structKeyExists(variables, 'listPrice')){
			if(!isNull(this.getOrderTemplate().getPriceGroup() )){
				var priceGroup = [this.getOrderTemplate().getPriceGroup()];
			}else if( !isNull(this.getOrderTemplate().getAccount()) && !isNull(this.getOrderTemplate().getAccount()) && arrayLen(this.getOrderTemplate().getAccount().getPriceGroups()) ){
				var priceGroup = [this.getOrderTemplate().getAccount().getPriceGroups()[1]];
			}else{
				var priceGroup = [getService('priceGroupService').getPriceGroupByPriceGroupCode(2)] // default to retail
			}
			variables.listPrice = this.getSku().getCustomPriceByCurrencyCode(customPriceField='listPrice', currencyCode=this.getOrderTemplate().getCurrencyCode(), quantity=this.getQuantity(), priceGroups=priceGroup) ?: 0;
		}
		return variables.listPrice
	}
//CUSTOM FUNCTIONS END
}
