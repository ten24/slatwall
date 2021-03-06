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
component entityname="SlatwallSkuPrice" table="SwSkuPrice" persistent=true accessors=true output=false extends="HibachiEntity" hb_serviceName="SkuPriceService" hb_permission="this" {

	// Persistent Properties
	property name="skuPriceID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="minQuantity" ormtype="integer" hb_nullrbkey="entity.SkuPrice.minQuantity.null";
	property name="maxQuantity" ormtype="integer" hb_nullrbkey="entity.SkuPrice.maxQuantity.null";
	property name="currencyCode" ormtype="string" length="3" hb_formfieldType="select" index="PI_CURRENCY_CODE";
	property name="price" ormtype="big_decimal" hb_formatType="currency";
	property name="listPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="renewalPrice" ormtype="big_decimal" hb_formatType="currency";
	property name="expiresDateTime" ormtype="timestamp";
	property name="activeFlag" ormtype="boolean" default=1;

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID" hb_cascadeCalculate="true";
	//temporarily omitted
	//property name="priceRule" cfc="PriceRule" fieldtype="many-to-one" fkcolumn="priceRuleID";
	property name="priceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="priceGroupID";
	property name="promotionReward" cfc="PromotionReward" fieldtype="many-to-one" fkcolumn="promotionRewardID";

	// Remote properties
	property name="remoteID" ormtype="string" hb_populateEnabled="private";
	property name="importRemoteID" hb_populateEnabled="private" ormtype="string" hint="Used via data-importer as a unique-key to find records for upsert";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="hasValidQuantityConfiguration" persistent="false"; 
 	

	public boolean function hasValidQuantityConfiguration(){
 		if(!(isNull(this.getMinQuantity()) && isNull(this.getMaxQuantity()))){ 
			if(isNull(this.getMinQuantity()) || isNull(this.getMaxQuantity())){ 
				return false; 
			} else if(this.getMinQuantity() > this.getMaxQuantity()){
				return false;
			} 
		}
 		return true; 
 	} 
 	
 	public boolean function isDefaultSkuPrice(){
 		return isNull(getMinQuantity()) 
 			&& isNull(getMaxQuantity()) 
 			&& isNull(getPriceGroup())
 			&& isNull(getPromotionReward())
 			&& (getSku().getCurrencyCode() == getCurrencyCode())
 		;
 	}
 	
 	public boolean function isNotDefaultSkuPrice(){
 		return !isDefaultSkuPrice();
 	}
 	
 	public any function getPriceGroupOptions(){
		var options = getPropertyOptions("priceGroup");
		arrayAppend(options, {"name"=rbKey('define.none'), "value"=''});
		return options;
 	}
 	
 	public string function getSimpleRepresentation() {
		if(
			!isNull(getSku()) 
			&& !isNull(getSku().getSkuCode())
		){
			return getSku().getSkuCode() & " - " & getCurrencyCode(); 
		} else {
			return '';
		}
	}
	
	// ================== START: Overridden Methods ========================
	
	public any function getDefaultCollectionProperties(){
		var includesList = getService("SkuPriceService").getDefaultCollectionPropertiesList();
		return super.getDefaultCollectionProperties(includesList,"");
	}
	
	// ================== END: Overridden Methods ==========================
	
	// =================== START: ORM Event Hooks  =========================	
	public void function preUpdate(struct oldData) {
		
		if (arguments.oldData.price NEQ getPrice() && getSku().hasStock()){
			for (var stock in getSku().getStocks()){
				getHibachiScope().addModifiedEntity(stock);
			}
		}
		
		if( this.isDefaultSkuPrice() ) {
			var sku = this.getSku();
			sku.setPrice(this.getPrice());
			sku = getService("SkuService").saveSku(sku);
		}
		
		super.preUpdate(arguments.oldData);
	}
    
	// ===================  END:  ORM Event Hooks  =========================	
}