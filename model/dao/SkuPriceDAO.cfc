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
component extends="HibachiDAO" accessors="true" output="false" {

	public function getSkuPricesForSku (required string skuID){
		return ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.promotionReward is null", { skuID=arguments.skuID }, true );
	}

	public function getSkuPricesForSkuByCurrencyCode (required string skuID, required string currencyCode){
		return ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.currencyCode = :currencyCode AND sp.promotionReward is null", { skuID=arguments.skuID, currencyCode=arguments.currencyCode }, true );
	}
	
	public function getPromotionRewardSkuPriceForSkuByCurrencyCode( required string skuID, required string promotionRewardID, required string currencyCode, numeric quantity, array priceGroups=getHibachiScope().getAccount().getPriceGroups() ){

		var hql = "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.sku.skuID = :skuID AND currencyCode = :currencyCode AND sp.promotionReward.promotionRewardID = :promotionRewardID";
		var params = { 
			skuID=arguments.skuID, 
			currencyCode=arguments.currencyCode, 
			promotionRewardID=arguments.promotionRewardID 
		};
		
		if(structKeyExists(arguments,'quantity')){
			hql &= ' AND (sp.minQuantity <= :quantity OR sp.minQuantity is null) AND (sp.maxQuantity >= :quantity OR sp.maxQuantity is null)';
			params['quantity'] = arguments.quantity;
		}else{
			hql &= ' AND sp.minQuantity is null AND sp.maxQuantity is null';
		}
		if(arraylen(arguments.priceGroups)){
			var priceGroupIDs = "";
			for(var priceGroup in arguments.priceGroups){
				priceGroupIDs = listAppend(priceGroupIDs,priceGroup.getPriceGroupID());
			}
			//get the best price
			hql &= ' AND (sp.priceGroup.priceGroupID IN (:priceGroupIDs) OR sp.priceGroup.priceGroupID IS NULL)';
			params['priceGroupIDs'] = priceGroupIDs;
		}else{
			hql &= ' AND sp.priceGroup is NULL';
		}
		hql &= ' ORDER BY sp.price ASC';

		return ormExecuteQuery( hql, params, true, {maxresults=1});

	}

	public function getBaseSkuPricesForSku (required string skuID){
		return ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.minQuantity is null AND sp.maxQuantity is null AND sp.promotionReward is null", { skuID=arguments.skuID }, true );
	}

	public function getBaseSkuPriceForSkuByCurrencyCode (required string skuID, required string currencyCode){
		var hql = "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.minQuantity is null AND sp.maxQuantity is null AND currencyCode = :currencyCode AND sp.promotionReward is null AND sp.priceGroup is NULL";

		return ormExecuteQuery( hql, { skuID=arguments.skuID, currencyCode=arguments.currencyCode }, true, { maxresults=1 } );
		
	}

	public function getSkuPricesForSkuAndQuantity(required string skuID, required numeric quantity){
		return  ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.minQuantity <= :quantity AND sp.maxQuantity >= :quantity AND sp.promotionReward is null", { skuID=arguments.skuID, quantity=arguments.quantity }, true );
	}

	public function getSkuPricesForSkuCurrencyCodeAndQuantity(required string skuID, required string currencyCode, required numeric quantity, array priceGroups=getHibachiScope().getAccount().getPriceGroups()){
		var priceGroupString = "";
		
		if(arraylen(arguments.priceGroups)){
			priceGroupString = "OR _priceGroup.priceGroupID IN (:priceGroupIDs)";
		}
		
		var hql = "
			SELECT NEW MAP(_skuPrice.price as price, _skuPrice.skuPriceID as skuPriceID)
			FROM SlatwallSkuPrice _skuPrice 
			left join _skuPrice.sku as _sku
			left join _skuPrice.priceGroup as _priceGroup
			WHERE _skuPrice.activeFlag = 1
			AND _sku.skuID = :skuID 
			AND (_skuPrice.minQuantity <= :quantity OR _skuPrice.minQuantity IS NULL)
			AND (_skuPrice.maxQuantity >= :quantity  OR _skuPrice.maxQuantity IS NULL)
			AND _skuPrice.currencyCode = :currencyCode
			AND (
				_skuPrice.priceGroup IS NULL
				#priceGroupString#
			)
			AND (
				_skuPrice.promotionReward IS NULL
			)
			GROUP BY _skuPrice.price,_skuPrice.skuPriceID
			";
			
		var params = { 
			skuID=arguments.skuID, 
			currencyCode=arguments.currencyCode, 
			quantity=arguments.quantity
			
		};
		if(len(priceGroupString)){
			var priceGroupIDs = [];
			for(var priceGroup in arguments.priceGroups){
				if(structKeyExists(priceGroup, 'getPriceGroupID')){
					arrayAppend(priceGroupIDs,priceGroup.getPriceGroupID());
				} else {
					arrayAppend(priceGroupIDs,priceGroup['priceGroupID']);
				}
			}
			params.priceGroupIDs= priceGroupIDs;
		}
		return  ormExecuteQuery( hql,
			params
		);
	}

	public function getSkuPricesForSkuAndQuantityRange (required string skuID, required numeric minQuantity, required numeric maxQuantity ){
		return ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.minQuantity = :minQuantity AND sp.maxQuantity = :maxQuantity  AND sp.promotionReward is null", { skuID=arguments.skuID, minQuantity=arguments.minQuantity, maxQuantity=arguments.maxQuantity }, true );
	}

	public function getSkuPricesForSkuAndQuantityRangeByCurrencyCode (required string skuID, required numeric minQuantity, required numeric maxQuantity, required string currencyCode){
		return ormExecuteQuery( "SELECT sp FROM SlatwallSkuPrice sp WHERE sp.activeFlag = 1 AND sp.sku.skuID = :skuID AND sp.minQuantity = :minQuantity AND sp.maxQuantity = :maxQuantity AND sp.currencyCode = :currencyCode AND sp.promotionReward is null", { skuID=arguments.skuID, minQuantity=arguments.minQuantity, maxQuantity=arguments.maxQuantity, currencyCode=arguments.currencyCode }, true );
	}

}
