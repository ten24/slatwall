<!---

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

--->
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionreward" type="any">
<cfparam name="rc.promotionperiod" type="any" default="#rc.promotionreward.getPromotionPeriod()#" />
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.edit" type="boolean">

    <cfoutput>

        <cfset local.includedSkuPricesCollection = $.slatwall.getService('HibachiService').getSkuPriceCollectionList() />
        <cfset local.includedSkuPricesCollection.setDisplayProperties('sku.skuCode,currencyCode,price',{'isVisible': true, 'isSearchable': true, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('priceGroup.priceGroupName','Price Group',{'isVisible': true, 'isEditable': false, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('personalVolume','Personal Volume',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('taxableAmount','Taxable Amount',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('commissionableVolume','Commissionable Volume',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('retailCommission','Retail Commission',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('productPackVolume','Product Pack Volume',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('retailValueVolume','Retail Value Volume',{'isVisible': true, 'isEditable': true, 'isSearchable': false, 'isExportable': true}) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('skuPriceID', 'Sku Price ID', {'isVisible': false, 'isSearchable': false}, true) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('sku.skuID', '', {'isVisible': false, 'isSearchable': false}, true) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('promotionReward.promotionRewardID', '', {'isVisible': false, 'isSearchable': false}, true) />
        <cfset local.includedSkuPricesCollection.addDisplayProperty('activeFlag', '', {'isVisible': false, 'isSearchable': false}, true) />
        <cfset local.includedSkuPricesCollection.addFilter('promotionReward.promotionRewardID', rc.promotionReward.getPromotionRewardID()) />
       
        <cfset local.collectionConfig = getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(local.includedSkuPricesCollection.getCollectionConfig()) />
        <cfset local.includedSkusCollectionConfig = getHibachiScope().getService('HibachiUtilityService').hibachiHTMLEditFormat(rc.promotionReward.getIncludedSkusCollection().getCollectionConfig()) />
        
        <div class="pull-right">
            <sw-action-caller
                    data-event="EDIT_SKUPRICE"
                    data-payload="undefined"
                    data-class="btn btn-primary btn-md"
                    data-icon="plus"
                    data-text="Add Sku Price"
                    data-iconOnly="false">
                
            </sw-action-caller>
        </div>
        
        <hb:HibachiListingDisplay collectionList="#local.includedSkuPricesCollection#"
                                  recordEditEvent="EDIT_SKUPRICE"
                                  recordDeleteEvent="DELETE_SKUPRICE"
                                  recordActions="[{
                                                    'event' : 'SAVE_SKUPRICE',
                                                    'icon' : 'floppy-disk',
                                                    'iconOnly' : true
                                                }]"
                                  listingID="pricingListing" />
        
        <sw-delete-sku-price-modal-launcher></sw-delete-sku-price-modal-launcher>
        <sw-sku-price-modal data-promotion-reward-id="#rc.promotionreward.getPromotionRewardID()#"
                            data-sku-collection-config="#local.includedSkusCollectionConfig#">
        </sw-sku-price-modal>
    </cfoutput>
