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

<!--- Many to Many Index Creation Function --->
<cffunction name="verifyManyToManyIndex">
	<cfargument name="tableName" type="string" required="true" />
	
	<cfset var qrs = "" />
	<cfset var infoColumns = "" />
	<cfset var infoIndexes = "" />

	
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Columns" table="#arguments.tableName#" name="infoColumns" />
	<cfdbinfo datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" type="Index" table="#arguments.tableName#" name="infoIndexes" />
	
	<cfloop query="infoColumns">
		<cfif infoColumns.column_size eq 32>
			<cfquery name="qrs" dbtype="query">
				SELECT
					infoIndexes.column_name
				FROM
					infoIndexes
				WHERE
					LOWER(infoIndexes.column_name) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCASE(infoColumns.column_name)#">
			</cfquery>
			<cfif not qrs.recordCount>
				<cfquery name="createIndex">
					CREATE INDEX MTMSA#UCASE(infoColumns.column_name)# ON #arguments.tableName# ( #infoColumns.column_name# )
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cffunction>


<!--- Lost of Many-To-Many tables to ensure that indexes exist --->
<cfset verifyManyToManyIndex("SlatwallProductCategory") />
<cfset verifyManyToManyIndex("SlatwallAccountContentAccessContent") />
<cfset verifyManyToManyIndex("SlatwallAccountPermissionGroup") />
<cfset verifyManyToManyIndex("SlatwallAccountPriceGroup") />
<cfset verifyManyToManyIndex("SlatwallAddressZoneLocation") />
<cfset verifyManyToManyIndex("SlatwallAttributeSetProductType") />
<cfset verifyManyToManyIndex("SlatwallOrderPromotionCode") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateExcludedProduct") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateExcludedProductType") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateExcludedSku") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateProduct") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateProductType") />
<cfset verifyManyToManyIndex("SlatwallPriceGroupRateSku") />
<cfset verifyManyToManyIndex("SlatwallProductCategory") />
<cfset verifyManyToManyIndex("SlatwallProductListingPage") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierBrand") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierExcludedBrand") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierExcludedOption") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierExcludedProduct") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierExcludedProductType") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierExcludedSku") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierFulfillmentMethod") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierOption") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierProduct") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierProductType") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierShippingAddressZone") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierShippingMethod") />
<cfset verifyManyToManyIndex("SlatwallPromotionQualifierSku") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardBrand") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardEligiblePriceGroup") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardExcludedBrand") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardExcludedOption") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardExcludedProduct") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardExcludedProductType") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardExcludedSku") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardFulfillmentMethod") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardOption") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardProduct") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardProductType") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardShippingAddressZone") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardShippingMethod") />
<cfset verifyManyToManyIndex("SlatwallPromotionRewardSku") />
<cfset verifyManyToManyIndex("SlatwallRelatedProduct") />
<cfset verifyManyToManyIndex("SlatwallSkuAccessContent") />
<cfset verifyManyToManyIndex("SlatwallSkuOption") />
<cfset verifyManyToManyIndex("SlatwallSkuRenewalSubscriptionBenefit") />
<cfset verifyManyToManyIndex("SlatwallSkuSubscriptionBenefit") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitCategory") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitContent") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitExcludedCategory") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitExcludedContent") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitPriceGroup") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionBenefitPromotion") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitCategory") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitContent") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitExcludedCategory") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitExcludedContent") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitPriceGroup") />
<cfset verifyManyToManyIndex("SlatwallSubscriptionUsageBenefitPromotion") />
<cfset verifyManyToManyIndex("SlatwallVendorBrand") />
<cfset verifyManyToManyIndex("SlatwallVendorProduct") />


<!--- INDEX to inforce SlatwallStock has unique Sku & Location combo --->
<cfdbinfo type="Index" name="dbiSkuLocation" table="SlatwallStock">
<cfquery name="indexExists" dbtype="query">
	SELECT
		*
	FROM
		dbiSkuLocation
	WHERE
		INDEX_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SkuLocation">
</cfquery>

<cfif not indexExists.recordcount>
	<cfquery name="createIndex">
		CREATE UNIQUE INDEX SkuLocation ON SlatwallStock (locationID,skuID)
	</cfquery>
</cfif>




