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


<cfparam name="rc.product" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.product#" edit="#rc.edit#">

		<hb:HibachiEntityActionBar type="preprocess" object="#rc.product#">
		</hb:HibachiEntityActionBar>

		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="price" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="subscriptionTermID" fieldType="select" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

		<div class="row">
			<div class="col-md-12">
				<h4 class="s-table-alternate-title">#$.slatwall.rbKey('admin.entity.sku.subscriptionBenefits')#</h4>
				<swa:SlatwallErrorDisplay object="#rc.processObject#" errorName="subscriptionBenefits" />
				<hb:HibachiListingDisplay object="#rc.processObject#" smartList="SubscriptionBenefit" multiselectFieldName="subscriptionBenefits" edit="#rc.edit#">
					<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" />
				</hb:HibachiListingDisplay>
			</div>

			<hb:HibachiPropertyList divClass="col-md-12">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="renewalMethod" valueDefault="#rc.processObject.getRenewalMethodOptions()[2].value#" valueOptions="#rc.processObject.getRenewalMethodOptions()#" edit=true>
			</hb:HibachiPropertyList>

			<hb:HibachiPropertyList divClass="col-md-12">

				<hb:HibachiDisplayToggle selector="select[name='renewalMethod']" showvalues="custom" loadVisable="true">
						<hb:HibachiPropertyDisplay object="#rc.processObject#" property="renewalPrice" fieldName="renewalPrice" edit="#rc.edit#" />
						<swa:SlatwallErrorDisplay object="#rc.processObject#" errorName="renewalsubscriptionBenefits" />
						<hb:HibachiListingDisplay smartList="SubscriptionBenefit" multiselectFieldName="renewalSubscriptionBenefits" title="#$.slatwall.rbKey('admin.entity.createProduct.selectRenewalSubscriptionBenefits')#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="subscriptionBenefitName" tdclass="primary" />
						</hb:HibachiListingDisplay>
				</hb:hibachiDisplayToggle>

				<hb:HibachiDisplayToggle selector="select[name='renewalMethod']" showvalues="renewalsku" loadVisable="false">
						<swa:SlatwallErrorDisplay object="#rc.processObject#" errorName="renewalSku" />
						<hb:HibachiListingDisplay object="#rc.processObject#" smartList="#rc.product.getSubscriptionSkuSmartList()#" selectFieldName="renewalSku" title="#$.slatwall.rbKey('define.renewalSku')#" edit="true">
							<hb:HibachiListingColumn propertyIdentifier="skuCode" />
							<hb:HibachiListingColumn propertyIdentifier="skuName" />
							<hb:HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
							<hb:HibachiListingColumn propertyIdentifier="renewalPrice" />
						</hb:HibachiListingDisplay>
				</hb:hibachiDisplayToggle>

			</hb:HibachiPropertyList>
		</div>

	</hb:HibachiEntityProcessForm>
</cfoutput>
