component extends="Slatwall.model.dao.SkuPriceDAO"{
    
    public function getSkuPricesForSkuCurrencyCodeAndQuantity(required string skuID, required string currencyCode, required numeric quantity, array priceGroups=getHibachiScope().getAccount().getPriceGroups()){
		var priceGroupString = "";
		
		if(arraylen(arguments.priceGroups)){
			priceGroupString = "OR _priceGroup.priceGroupID IN (:priceGroupIDs)";
		}
		
		var hql = "
			SELECT NEW MAP(
			    _skuPrice.price as price,
			    _skuPrice.personalVolume as personalVolume,
			    _skuPrice.taxableAmount as taxableAmount,
			    _skuPrice.commissionableVolume as commissionableVolume,
			    _skuPrice.retailCommission as retailCommission,
			    _skuPrice.productPackVolume as productPackVolume,
			    _skuPrice.retailValueVolume as retailValueVolume,
			    _skuPrice.skuPriceID as skuPriceID
		    )
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
				arrayAppend(priceGroupIDs,priceGroup.getPriceGroupID());
			}
			params.priceGroupIDs= priceGroupIDs;
		}
		return  ormExecuteQuery( hql,
			params
		);
	}
    
}