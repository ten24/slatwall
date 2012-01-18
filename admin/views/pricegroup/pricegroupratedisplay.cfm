<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->


<cfoutput>
	<div class="priceGroupRateDisplay">
		<cfif rc.edit>
			<dl class="twoColumn">
				<div id="globalRateControls">
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="priceGroupRates[1].globalFlag" property="globalFlag" edit="true"  fieldType="yesno" />
				</div>
					
				<!--- If there is another Rate in this Group that is set to global, output this warning --->
				<cfset globalRate = rc.priceGroup.getGlobalPriceGroupRate()>
				<cfif !isNull(globalRate) AND globalRate.getPriceGroupRateId() NEQ rc.priceGroupRate.getPriceGroupRateId()>
					<p id="priceGroupRate_globalWarning" class="messagebox warning_message ui-helper-hidden">
						<!--- Do token replacement on RB string --->
						<cfset str = rc.$.Slatwall.rbKey("admin.pricegroup.detail.globalwarning")>
						<cfset str = ReplaceNoCase(str, "{ratevalue}", globalRate.getAmountRepresentation())>
						#str#
					</p><br>
				</cfif>
				
				<div>
					<dt class="title">
						<label for="priceGroupRateType">#rc.$.Slatwall.rbKey("admin.pricegroup.detail.ratetype")#</label>
					</dt>
					<dd class="value">
						<!--- The dynamic percentageOff,AmountOff,Amount inputs --->
						<select name="priceGroupRateType" id="priceGroupRateType">
							<option value="percentageOff" <cfif rc.priceGroupRate.getType() EQ "percentageOff"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.percentageOff')#</option>
							<option value="amountOff" <cfif rc.priceGroupRate.getType() EQ "amountOff"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.amountOff')#</option>						
							<option value="amount" <cfif rc.priceGroupRate.getType() EQ "amount"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.amount')#</option>
						</select>
	
						<!--- The name of this hidden input is changed dynamically based on the value of priceGroupRateType --->
						
						<!---<cf_SlatwallErrorDisplay object="#rc.priceGroupRate#" errorName="percentageOff" displayType="label" for="priceGroupRates[1].percentageOff" />--->
		
						<div id="percentageOffDiv" <cfif rc.priceGroupRate.getType() NEQ "percentageOff">class="ui-helper-hidden"</cfif> ><cf_SlatwallPropertyDisplay displayType="plain" title="" object="#rc.PriceGroupRate#" property="percentageOff" edit="#rc.edit#" fieldName="priceGroupRates[1].percentageOff"></div>
						<div id="amountOffDiv" <cfif rc.priceGroupRate.getType() NEQ "amountOff">class="ui-helper-hidden"</cfif>  ><cf_SlatwallPropertyDisplay displayType="plain" title="" object="#rc.PriceGroupRate#" property="amountOff" edit="#rc.edit#" fieldName="priceGroupRates[1].amountOff"></div>
						<div id="amountDiv" <cfif rc.priceGroupRate.getType() NEQ "amount">class="ui-helper-hidden"</cfif>  ><cf_SlatwallPropertyDisplay displayType="plain" title="" object="#rc.PriceGroupRate#" property="amount" edit="#rc.edit#" fieldName="priceGroupRates[1].amount"></div>
					</dd>
				</div>
					
				<!---<input type="text" id="priceGroupRateValue" 
				<cfif rc.priceGroupRate.isNew() OR rc.priceGroupRate.getType() EQ "percentageOff">
					name="priceGroupRates[1].percentageOff" class=""
				<cfelseif rc.priceGroupRate.getType() EQ "amountOff">	
					name="priceGroupRates[1].amountOff" class="field amountofffield"
				<cfelseif rc.priceGroupRate.getType() EQ "amount">
					name="priceGroupRates[1].amount" class="field amountfield" 
				</cfif>	
					value="<cfif !isNull(rc.priceGroupRate.getValue())>#rc.priceGroupRate.getValue()#</cfif>" />\
					--->
				
				<div id="roundingRuleDiv" <cfif rc.priceGroupRate.getType() NEQ "percentageOff" AND rc.priceGroupRate.getType() NEQ "">class="ui-helper-hidden"</cfif> >
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" property="roundingRule" fieldName="priceGroupRates[1].roundingRule.roundingRuleID" edit="true" valueDefault="#request.context.$.Slatwall.rbKey('admin.none')#">
				</div>
	
				<!--- If PriceGroupRate.getGlobalFlag() is 1, then we must be in edit mode, and the Rate being populated was set to global. Hide the inputs  --->
				<div id="priceGroupRate_globalOffInputs" <cfif rc.priceGroupRate.getGlobalFlag() EQ 1>class="ui-helper-hidden"</cfif> >
					
					<!--- ---------------- Includes --------------- --->
					<!--- Build a list of ids for the "selected" product types --->
					<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getProductTypes()#" index="productType">
						<cfset idsList = ListAppend(idsList, productType.getProductTypeId())>
					</cfloop>
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="priceGroupRates[1].ProductTypes" property="productTypes" edit="true"  fieldType="multiselect" value="#idsList#"  />
					
					<!--- Build a list of ids for the "selected" products --->
					<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getProducts()#" index="product">
						<cfset idsList = ListAppend(idsList, product.getProductId())>
					</cfloop>
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" property="products" fieldName="priceGroupRates[1].Products"  edit="true"  fieldType="multiselect" value="#idsList#"  />
					
					<!--- Build a list of ids for the "selected" SKUs --->
					<!---<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getSKUs()#" index="SKU">
						<cfset idsList = ListAppend(idsList, SKU.getSKUId())>
					</cfloop>
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="SkuIds" property="Skus" edit="true"  fieldType="multiselect" value="#idsList#"  />
					
					<br>--->
					
					<!--- ---------------- Excludes --------------- --->
					<!--- Build a list of ids for the "selected" product types --->
					<!---<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getExcludedProductTypes()#" index="productType">
						<cfset idsList = ListAppend(idsList, productType.getProductTypeId())>
					</cfloop>
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="excludedProductTypeIds" property="excludedProductTypes" edit="true"  fieldType="multiselect" value="#idsList#"  />
					
					<br>
					
					<!--- Build a list of ids for the "selected" products --->
					<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getExcludedProducts()#" index="product">
						<cfset idsList = ListAppend(idsList, product.getProductId())>
					</cfloop>
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="excludedProductIds" property="excludedProducts" edit="true"  fieldType="multiselect" value="#idsList#"  />	
					
					<br>--->
					
					<!--- Build a list of ids for the "selected" SKUs --->
					<!---<cfset idsList = "">
					<cfloop array="#rc.priceGroupRate.getExcludedSKUs()#" index="SKU">
						<cfset idsList = ListAppend(idsList, SKU.getSKUId())>
					</cfloop>
					
					<cf_SlatwallPropertyDisplay object="#rc.priceGroupRate#" fieldName="excludedSkuIds" property="excludedSkus" edit="true"  fieldType="multiselect" value="#idsList#"  />
					--->
				</div>
			</dl>
		</cfif>
</div>
</cfoutput>
