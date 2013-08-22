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
<cfparam name="rc.promotionQualifier" type="any">
<cfparam name="rc.promotionPeriod" type="any" default="#rc.promotionQualifier.getPromotionPeriod()#" />
<cfparam name="rc.qualifierType" type="string" default="#rc.promotionQualifier.getQualifierType()#" />
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion qualifier if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset arrayAppend(rc.messages,{message=rc.$.slatwall.rbKey('admin.pricing.promotionqualifier.edit_disabled'),messageType="info"}) />
</cfif>

<cfset local.qualifierType = rc.promotionQualifier.getQualifierType() />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.promotionQualifier#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.promotionQualifier#" edit="#rc.edit#" 
							  cancelAction="admin:entity.detailpromotionqualifier"
							  cancelQueryString="promotionQualifierID=#rc.promotionQualifier.getPromotionQualifierID()#" 
							  backAction="admin:entity.detailpromotionperiod" 
							  backQueryString="promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabpromotionqualifiers" 
							  deleteQueryString="promotionQualifierID=#rc.promotionQualifier.getPromotionQualifierID()#&redirectAction=admin:entity.detailpromotionperiod&promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabpromotionqualifiers" />
		
		<input type="hidden" name="qualifierType" value="#rc.qualifierType#" />
		
		<input type="hidden" name="promotionPeriod.promotionPeriodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
		<input type="hidden" name="promotionPeriodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemQuantity" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemQuantity" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumItemPrice" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumItemPrice" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="rewardMatchingType" edit="#rc.edit#" />
				<cfelseif rc.qualifierType eq "fulfillment">
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumFulfillmentWeight" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumFulfillmentWeight" edit="#rc.edit#" />
				<cfelseif rc.qualifierType eq "order">
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderQuantity" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderQuantity" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="minimumOrderSubtotal" edit="#rc.edit#" />
					<cf_HibachiPropertyDisplay object="#rc.promotionQualifier#" property="maximumOrderSubtotal" edit="#rc.edit#" />
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.promotionQualifier#">
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/producttypes" />
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/products" />
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/skus" />
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/brands" />
				<cfif rc.qualifierType eq "merchandise">
					<cf_HibachiTab view="admin:entity/promotionqualifiertabs/options" />
				</cfif>
			<cfelseif rc.qualifierType eq "fulfillment">
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/fulfillmentMethods" />
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/shippingMethods" />
				<cf_HibachiTab view="admin:entity/promotionqualifiertabs/shippingAddressZones" />
			</cfif>
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
