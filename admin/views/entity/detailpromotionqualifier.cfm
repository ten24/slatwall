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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


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
	<hb:HibachiEntityDetailForm object="#rc.promotionQualifier#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.promotionQualifier#" edit="#rc.edit#" 
							  cancelAction="admin:entity.detailpromotionqualifier"
							  cancelQueryString="promotionQualifierID=#rc.promotionQualifier.getPromotionQualifierID()#" 
							  backAction="admin:entity.detailpromotionperiod" 
							  backQueryString="promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabpromotionqualifiers" 
							  deleteQueryString="promotionQualifierID=#rc.promotionQualifier.getPromotionQualifierID()#&redirectAction=admin:entity.detailpromotionperiod&promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabpromotionqualifiers" />
		
		<input type="hidden" name="qualifierType" value="#rc.qualifierType#" />
		
		<input type="hidden" name="promotionPeriod.promotionPeriodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
		<input type="hidden" name="promotionPeriodID" value="#rc.promotionperiod.getPromotionperiodID()#" />
		
		<hb:HibachiEntityDetailGroup object="#rc.promotionQualifier#">
			<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.qualifierType)>
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/producttypes" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/products" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/skus" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/brands" />
				<cfif rc.qualifierType eq "merchandise">
					<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/options" />
				</cfif>
			<cfelseif rc.qualifierType eq "fulfillment">
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/fulfillmentMethods" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/shippingMethods" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionqualifiertabs/shippingAddressZones" />
			</cfif>
		</hb:HibachiEntityDetailGroup>
		
	</hb:HibachiEntityDetailForm>
</cfoutput>
