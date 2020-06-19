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
component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="product";

	// Data Properties
	property name="baseProductType";
	property name="brandID";
	property name="bundleContentAccessFlag" hb_formFieldType="yesno";
	property name="contents";
	property name="options";
	property name="price";
	property name="listPrice"; 
	property name="renewalSubscriptionBenefits";
	property name="renewalSku";
	property name="renewalPrice";
	property name="subscriptionBenefits";
	property name="subscriptionTerms";
	property name="generateSkusFlag" hb_formFieldType="yesno" default="0" hint="If set to 0 skus will not be create when product is.";
	property name="redemptionAmountType" hb_formFieldType="select";
	property name="redemptionAmount";
	property name="redemptionAmountTypeOptions";
	property name="renewalMethod" hb_formFieldType="select";
	property name="renewalMethodOptions";
	property name="giftCardExpirationTermID" hb_rbkey="entity.sku.giftCardExpirationTerm" hb_formFieldType="select";
	property name="giftCardExpirationTermIDOptions";

	property name="brand" cfc="Brand" fieldtype="many-to-one";
	
	public any function getBrand(){
		if(!structKeyExists(variables,'brand')){
			if(!isNull(getBrandID())){
				variables.brand = getService('productService').getBrand(getBrandID());	
			}else{
				return;
			}
		}
		return variables.brand;
	}
	
	
	public any function setupDefaults() {
		variables.generateSkusFlag = true;
	}

	public array function getRenewalMethodOptions(){
		return this.getProduct().getRenewalMethodOptions();
	}

	public array function getGiftCardExpirationTermIDOptions(){
		if(!structKeyExists(variables,'giftCardExpirationTermIDOptions')){
			variables.giftCardExpirationTermIDOptions = [];
			var termSmartList = getService('hibachiService').getTermSmartList();
			termSmartList.addSelect('termID','value');
			termSmartList.addSelect('termName','name');
			variables.giftCardExpirationTermIDOptions = termSmartList.getRecords();
			var option = {};
			option['name'] = 'None';
			option['value'] = '';
			arrayPrepend(variables.giftCardExpirationTermIDOptions,option);
		}
		return variables.giftCardExpirationTermIDOptions;
	}

	public array function getRedemptionAmountTypeOptions(){
		if(!structKeyExists(variables,'redemptionAmountTypeOptions')){

			variables.redemptionAmountTypeOptions = [];
			var optionValues = 'sameAsPrice,fixedAmount,percentage';
			var optionValuesArray = listToArray(optionValues);

			var option = {};
			option['name'] = rbKey('entity.Product.redemptionAmountType.select');
			option['value'] = "";
			arrayAppend(variables.redemptionAmountTypeOptions,option);

			for(var optionValue in optionValuesArray){
				var option = {};
				option['name'] = rbKey('define.#optionValue#');
				option['value'] = optionValue;
				arrayAppend(variables.redemptionAmountTypeOptions,option);
			}
		}

		return variables.redemptionAmountTypeOptions;
	}

	public any function getRenewalPrice(){
		if(!isNull(getRenewalSku())){
			return this.getRenewalSku().getRenewalPrice();
		} else if(!isNull(variables.renewalPrice)) {
			return variables.renewalPrice;
		} else {
			return;
		}
	}

	public any function getRenewalSku(){
		if(!isNull(variables.renewalSku)){
			return this.getService("SkuService").getSku(variables.renewalSku);
		}
		return;
	}


}