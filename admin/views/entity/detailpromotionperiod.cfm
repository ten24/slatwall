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


<cfparam name="rc.promotionperiod" type="any">
<cfparam name="rc.promotion" type="any" default="#rc.promotionPeriod.getPromotion()#">
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion period if it is past the startDateTime for this promotion or the startTime is forever then this can not be edited. --->
<cfif rc.edit and rc.promotionPeriod.getCurrentFlag() and rc.promotion.getPromotionAppliedOrdersCount() gt 0>
	<cfset rc.edit = false>
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod_inprogress.editdisabled_info') />
</cfif>
<!--- prevent editing promotion period if it has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.editdisabled_info') />
</cfif>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.promotionperiod#" edit="#rc.edit#" saveActionQueryString="promotionID=#rc.promotion.getPromotionID()#">
						   	   
		<hb:HibachiEntityActionBar type="detail" object="#rc.promotionPeriod#" edit="#rc.edit#"
							backAction="admin:entity.detailpromotion"
							backQueryString="promotionID=#rc.promotion.getPromotionID()#"
							cancelAction="admin:entity.detailpromotion"
							cancelQueryString="promotionID=#rc.promotion.getPromotionID()#"								   
							deleteQueryString="promotionID=#rc.promotion.getPromotionID()#&redirectAction=admin:entity.detailpromotion">
			<!--- Duplicate --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessPromotionPeriod" entity="#rc.promotionperiod#" processContext="duplicatePromotionPeriod" type="list" modal="true" />
			
			<!--- End Promotion Period --->
			<hb:HibachiProcessCaller action="admin:entity.preProcessPromotionPeriod" entity="#rc.promotionperiod#" processContext="endPromotionPeriod" type="list" modal="true" />
 		
		</hb:HibachiEntityActionBar>
							    			  	  
		<input type="hidden" name="promotion.promotionID" value="#rc.promotion.getPromotionID()#" />
		
		<hb:HibachiEntityDetailGroup object="#rc.promotionperiod#">
				<hb:HibachiEntityDetailItem view="admin:entity/promotionperiodtabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionperiodtabs/promotionrewards" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionperiodtabs/promotionqualifiers" />
		</hb:HibachiEntityDetailGroup>
	</hb:HibachiEntityDetailForm>
	
</cfoutput>

