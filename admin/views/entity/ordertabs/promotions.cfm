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

<cfparam name="rc.order" type="any" />

<cfoutput>
	<cfif arrayLen(rc.order.getAllAppliedPromotions())>
		<table class="table table-bordered table-hover">
			<tr>
				<th>#$.slatwall.rbKey('entity.promotionCode')#</th>
				<th>#$.slatwall.rbKey('entity.promotion')#</th>
				<th>#$.slatwall.rbKey('define.qualified')#</th>
				<th></th>
			</tr>
			<cfloop array="#rc.order.getAllAppliedPromotions()#" index="appliedPromotion">
				<tr>
					<td class="primary">#appliedPromotion.promotionCode#</td>
					<td class="primary">#appliedPromotion.promotion_promotionName#</td>
					<td>#appliedPromotion.qualified#</td>
					<td class="admin admin2">
						<hb:HibachiActionCaller action="admin:entity.detailPromotion" queryString="promotionID=#appliedPromotion.promotion_promotionID#" class="btn btn-default btn-xs" icon="eye-open" iconOnly="true"  />
						<cfif len(appliedPromotion.promotionCodeID)>
							<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="removePromotionCode" queryString="promotionCodeID=#appliedPromotion.promotionCodeID#" confirm="true" confirmText="#$.slatwall.rbKey('admin.entity.processorder.removePromotionCode_confirm')#" class="btn btn-default btn-xs" iconOnly="true" icon="trash">
						<cfelse>
							<hb:HibachiProcessCaller action="admin:entity.processOrder" entity="#rc.order#" processContext="removePromotionCode" queryString="promotionCodeID=#appliedPromotion.promotionCodeID#" confirm="true" confirmText="#$.slatwall.rbKey('admin.entity.processorder.removePromotionCode_confirm')#" class="btn btn-default btn-xs disabled" iconOnly="true" icon="trash">
						</cfif>
					</td>
				</tr>
			</cfloop>
		</table>
	</cfif>
	
	<hb:HibachiProcessCaller action="admin:entity.preProcessOrder" entity="#rc.order#" processContext="addPromotionCode" class="btn btn-default" icon="plus" modal="true" />
</cfoutput>
