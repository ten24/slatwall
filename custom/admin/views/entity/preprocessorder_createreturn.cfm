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
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.orderTypeCode" type="string" />

<cfif rc.orderTypeCode EQ 'otReturnOrder'>
	<cfset local.createReturnText = 'Create Return Order'>
<cfelseif rc.orderTypeCode EQ 'otRefundOrder'>
	<cfset local.createReturnText = 'Create Refund Order'>
<cfelseif rc.orderTypeCode EQ 'otExchangeOrder'>
	<cfset local.createReturnText = 'Create Exchange Order'>
<cfelseif rc.orderTypeCode EQ 'otReplacementOrder'>
	<cfset local.createReturnText = 'Create Replacement Order'>
</cfif>

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.order#" edit="#rc.edit#">
		
		<div class="row s-body-nav">
			<nav class="navbar navbar-default" role="navigation">
				<div class="col-md-6 s-header-info">
					<h1 class="actionbar-title">#local.createReturnText#</h1>
				</div>
				<div class="col-md-6">
					<div class="btn-toolbar">
						<div class="btn-group btn-group-sm">
							<a title="Orders" class="adminentitylistorder btn btn-default" target="_self" href="/Slatwall/?slatAction=entity.listorder">
								<i class="glyphicon glyphicon-arrow-left"></i> Orders
							</a>
						</div>
						<div class="btn-group btn-group-sm">
							<button ng-if="!slatwall.modifiedUnitPrices || #rc.orderTypeCode == 'otRefundOrder'#" type="submit" class="btn btn-primary">#local.createReturnText#</button>
							<a ng-cloak ng-if="slatwall.modifiedUnitPrices && #rc.orderTypeCode != 'otRefundOrder'#" title="#local.createReturnText#" class="adminentitypreprocessorder btn btn-primary modalload" target="_self" data-toggle="modal" data-target="##warningModal">
								#local.createReturnText#
							</a>
						</div>
						<div class="modal" id="warningModal" tabindex="-1" role="dialog" aria-hidden="true">
							<div class="modal-dialog">
							   <div class="modal-content">
							      <div class="modal-header">
							         <a class="close" data-dismiss="modal">&times;</a>
							         <h3>#local.createReturnText#</h3>
							      </div>
							      <div class="modal-body">
							         <p>The unit prices entered do not match the original order prices; please make sure all prices entered are correct before continuing.
							      </div>
							      <div class="modal-footer">
							         <a class="btn btn-default s-remove" data-dismiss="modal"><span class="glyphicon glyphicon-remove icon-white"></span> Cancel</a>
							         <button class="btn btn-success" 
							            title="#local.createReturnText#"
							            type="submit"
							            >
							        	<i class="glyphicon glyphicon-ok icon-white"></i> #local.createReturnText#
							         </button>
							      </div>
							   </div>
							</div>
						</div>
					</div>
				</div>
			</nav>
		</div>
		<hb:HibachiMessageDisplay />
		<div class="panel p-20">
			<hb:HibachiPropertyRow>
			
				<hb:HibachiPropertyList divclass="col-md-6">
					<!--- Order Type --->
					<input type="hidden" name="orderTypeCode" value="#rc.processObject.getOrderTypeCode()#">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="orderTypeName"  edit="false">
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="locationID" edit="true" />
					<hb:HibachiPropertyDisplay object="#rc.processObject#" property="returnReasonType" edit="true" />
					<cfif rc.processObject.getOrderTypeCode() eq 'otReturnOrder'>
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="secondaryReturnReasonType" edit="true" />
					</cfif>
				</hb:HibachiPropertyList>
				
				<hb:HibachiPropertyList divclass="col-md-6">
					<h4 class="panel-title mb-20">Customer Information</h4>
					<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" edit="false" valuelink="#getHibachiScope().buildURL(action='entity.detailAccount', queryString='accountID=#rc.order.getAccount().getAccountID()#')#" title="#$.slatwall.rbKey('entity.account')#">
					<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="company" edit="true" fieldAttributes="disabled">
				</hb:HibachiPropertyList>
				
			</hb:HibachiPropertyRow>
		</div>

		<hb:HibachiEntityDetailGroup>
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/originalorderreview" open="true" text="Original Order Overview" />
			<hb:HibachiEntityDetailItem view="admin:entity/ordertabs/returnorderitems" open="true" text="Order Items" />
		</hb:HibachiEntityDetailGroup>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>
