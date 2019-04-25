<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionreward" type="any">
<cfparam name="rc.promotionperiod" type="any" default="#rc.promotionreward.getPromotionPeriod()#" />
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.edit" type="boolean">


    <sw-add-sku-price-modal-launcher>
        <a href="#" title="Add Price" class="pull-right btn btn-primary" data-target="#">
            <i class="fa fa-plus"></i> Add Sku Price
        </a>
    </sw-add-sku-price-modal-launcher>

    <cfoutput>

        <cfset local.includedSkuPricesCollection = $.slatwall.getService('HibachiService').getSkuPriceCollectionList() />
        <cfset local.includedSkuPricesCollection.setDisplayProperties('sku.skuCode,currencyCode,price',{'isVisible': true, 'isSearchable': true, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('personalVolume','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('taxableAmount','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('commissionableVolume','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('sponsorVolume','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('productPackVolume','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('retailValueVolume','',{'isVisible': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('skuPriceID', 'Sku Price ID', {'isVisible': false, 'isSearchable': false}, true) />

        <hb:HibachiListingDisplay 
            collectionList="#local.includedSkuPricesCollection#" 
            collectionConfigFieldName="includedSkuPricesCollectionConfig" 
            edit="#rc.edit#" 
            recordDeleteEvent="REMOVE_PROMOTIONSKUPRICE"
            displaytype="plainTitle"/>
    </cfoutput> 