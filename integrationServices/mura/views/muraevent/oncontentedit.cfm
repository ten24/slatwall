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
<!--- Setup Setting Details --->
<cfsilent>

	<!--- contentIncludeChildContentProductsFlag --->
	<cfset local.contentIncludeChildContentProductsFlagDetails = $.slatwall.getContent().getSettingDetails('contentIncludeChildContentProductsFlag') />
	<cfset local.contentIncludeChildContentProductsFlagDetails.parentValue = $.slatwall.setting('contentIncludeChildContentProductsFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentIncludeChildContentProductsFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentIncludeChildContentProductsFlag') />
	</cfif>

	<cfset local.contentIncludeChildContentProductsFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentIncludeChildContentProductsFlagDetails.parentValue, "yesno") />

	<!--- contentRestrictAccessFlagDetails --->
	<cfset local.contentRestrictAccessFlagDetails = $.slatwall.getContent().getSettingDetails('contentRestrictAccessFlag') />
	<cfset local.contentRestrictAccessFlagDetails.parentValue = $.slatwall.setting('contentRestrictAccessFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRestrictAccessFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRestrictAccessFlag') />
	</cfif>
	<cfset local.contentRestrictAccessFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRestrictAccessFlagDetails.parentValue, "yesno") />

	<!--- contentRestrictedContentDisplayTemplate --->
	<cfset local.contentRestrictedContentDisplayTemplateDetails = $.slatwall.getContent().getSettingDetails('contentRestrictedContentDisplayTemplate') />
	<cfset local.contentRestrictedContentDisplayTemplateDetails.parentValue = $.slatwall.setting('contentRestrictedContentDisplayTemplate') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRestrictedContentDisplayTemplateDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRestrictedContentDisplayTemplate') />
	</cfif>
	<cfset local.contentRestrictedContentDisplayTemplateDetails.valueOptions = $.slatwall.getService("contentService").getDisplayTemplateOptions( "BarrierPage", $.slatwall.getContent().getSite().getSiteID() ) />
	<cfset local.contentRestrictedContentDisplayTemplateDetails.parentValueFormatted = $.slatwall.rbKey('define.none') />
	<cfloop array="#local.contentRestrictedContentDisplayTemplateDetails.valueOptions#" index="local.thisOption">
		<cfif local.thisOption['value'] eq local.contentRestrictedContentDisplayTemplateDetails.parentValue>
			<cfset local.contentRestrictedContentDisplayTemplateDetails.parentValueFormatted = local.thisOption['name'] />
		</cfif>
	</cfloop>

	<!--- contentRequirePurchaseFlagDetails --->
	<cfset local.contentRequirePurchaseFlagDetails = $.slatwall.getContent().getSettingDetails('contentRequirePurchaseFlag') />
	<cfset local.contentRequirePurchaseFlagDetails.parentValue = $.slatwall.setting('contentRequirePurchaseFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRequirePurchaseFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRequirePurchaseFlag') />
	</cfif>
	<cfset local.contentRequirePurchaseFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRequirePurchaseFlagDetails.parentValue, "yesno") />

	<!--- contentRequireSubscriptionFlagDetails --->
	<cfset local.contentRequireSubscriptionFlagDetails = $.slatwall.getContent().getSettingDetails('contentRequireSubscriptionFlag') />
	<cfset local.contentRequireSubscriptionFlagDetails.parentValue = $.slatwall.setting('contentRequireSubscriptionFlag') />
	<cfif !isNull($.slatwall.getContent().getParentContent())>
		<cfset local.contentRequireSubscriptionFlagDetails.parentValue = $.slatwall.getContent().getParentContent().setting('contentRequireSubscriptionFlag') />
	</cfif>
	<cfset local.contentRequireSubscriptionFlagDetails.parentValueFormatted = $.slatwall.formatValue(local.contentRequireSubscriptionFlagDetails.parentValue, "yesno") />

	<!--- Setup the local product for this object --->
	<cfset local.product = $.slatwall.getService( "productService" ).newProduct() />
	<cfset local.productTypeOptions = local.product.getProductTypeOptions('contentAccess') />
</cfsilent>

<span id="extendset-container-tabslatwalltop" class="extendset-container"></span>
<cfoutput>
	<div class="fieldset">
		<!--- Content Template Type --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('entity.content.contentTemplateType_hint')#">#$.slatwall.rbKey('entity.content.contentTemplateType')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<select name="slatwallData.content.contentTemplateType.typeID">
					<cfloop array="#$.slatwall.getContent().getContentTemplateTypeOptions()#" index="typeOption">
						<option value="#typeOption['value']#" <cfif (isNull($.slatwall.getContent().getContentTemplateType()) and typeOption['value'] eq "") or (not isNull($.slatwall.getContent().getContentTemplateType()) and typeOption['value'] eq $.slatwall.getContent().getContentTemplateType().getTypeID())>selected="selected"</cfif>>#typeOption['name']#</option>
					</cfloop>
				</select>
			</div>
		</div>
		<!--- Product Listing Page Flag --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('entity.content.productListingPageFlag_hint')#">#$.slatwall.rbKey('entity.content.productListingPageFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<div class="controls">
					<label class="radio inline span3"><input type="radio" name="slatwallData.content.productListingPageFlag" value="1" data-checked-show="listingPageDetails" <cfif !isNull($.slatwall.getContent().getProductListingPageFlag()) and $.slatwall.getContent().getProductListingPageFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
					<label class="radio inline span2"><input type="radio" name="slatwallData.content.productListingPageFlag" value="0" data-checked-hide="listingPageDetails" <cfif isNull($.slatwall.getContent().getProductListingPageFlag()) or !$.slatwall.getContent().getProductListingPageFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				</div>
			</div>
		</div>
		<!--- Listing Page Details --->
		<div id="listingPageDetails">
			<!--- Include sub products --->
			<div class="control-group">
				<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentIncludeChildContentProductsFlag_hint')#">#$.slatwall.rbKey('setting.contentIncludeChildContentProductsFlag')# <i class="icon-question-sign"></i></a></label>
				<div class="controls">
					<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentIncludeChildContentProductsFlag" value="1" <cfif !local.contentIncludeChildContentProductsFlagDetails.settinginherited and local.contentIncludeChildContentProductsFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
					<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentIncludeChildContentProductsFlag" value="0" <cfif !local.contentIncludeChildContentProductsFlagDetails.settinginherited and !local.contentIncludeChildContentProductsFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
					<label class="radio inline span3"><input type="radio" name="slatwallData.content.contentIncludeChildContentProductsFlag" value="" <cfif local.contentIncludeChildContentProductsFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherit')# ( #local.contentIncludeChildContentProductsFlagDetails.parentValueFormatted# )</label>
				</div>
			</div>
		</div>
		<!--- Setting: Restrict Access --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRestrictAccessFlag_hint')#">#$.slatwall.rbKey('setting.contentRestrictAccessFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<cfset inheritedAttribute = "hide" />
				<cfif local.contentRestrictAccessFlagDetails.parentValue>
					<cfset inheritedAttribute = "show" />
				</cfif>
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRestrictAccessFlag" value="1" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRestrictAccessFlag" value="0" <cfif !local.contentRestrictAccessFlagDetails.settinginherited and !local.contentRestrictAccessFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				<label class="radio inline span3"><input type="radio" name="slatwallData.content.contentRestrictAccessFlag" value="" <cfif local.contentRestrictAccessFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherit')# ( #local.contentRestrictAccessFlagDetails.parentValueFormatted# )</label>
			</div>
		</div>
		<!--- Setting: Barrier Page --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRestrictedContentDisplayTemplate_hint')#">#$.slatwall.rbKey('setting.contentRestrictedContentDisplayTemplate')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<select name="slatwallData.content.contentRestrictedContentDisplayTemplate">
					<option value="" <cfif local.contentRestrictedContentDisplayTemplateDetails.settinginherited>selected="selected"</cfif>>#$.slatwall.rbKey('define.inherit')# ( #local.contentRestrictedContentDisplayTemplateDetails.parentValueFormatted# )</option>
					<cfloop array="#local.contentRestrictedContentDisplayTemplateDetails.valueOptions#" index="option">
						<option value="#option['value']#" <cfif !local.contentRestrictedContentDisplayTemplateDetails.settinginherited and option['value'] eq local.contentRestrictedContentDisplayTemplateDetails.settingValue>selected="selected"</cfif>>#option['name']#</option>
					</cfloop>
				</select>
			</div>
		</div>
		<!--- Setting: Require Purchase Flag --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRequirePurchaseFlag_hint')#">#$.slatwall.rbKey('setting.contentRequirePurchaseFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRequirePurchaseFlag" value="1" <cfif !local.contentRequirePurchaseFlagDetails.settinginherited and local.contentRequirePurchaseFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRequirePurchaseFlag" value="0" <cfif !local.contentRequirePurchaseFlagDetails.settinginherited and !local.contentRequirePurchaseFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				<label class="radio inline span3"><input type="radio" name="slatwallData.content.contentRequirePurchaseFlag" value="" <cfif local.contentRequirePurchaseFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherit')# ( #local.contentRequirePurchaseFlagDetails.parentValueFormatted# )</label>
			</div>
		</div>
		<!--- Setting: Require Subscription Flag --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('setting.contentRequireSubscriptionFlag_hint')#">#$.slatwall.rbKey('setting.contentRequireSubscriptionFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRequireSubscriptionFlag" value="1" <cfif !local.contentRequireSubscriptionFlagDetails.settinginherited and local.contentRequireSubscriptionFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.contentRequireSubscriptionFlag" value="0" <cfif !local.contentRequireSubscriptionFlagDetails.settinginherited and !local.contentRequireSubscriptionFlagDetails.settingValue>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
				<label class="radio inline span3"><input type="radio" name="slatwallData.content.contentRequireSubscriptionFlag" value="" <cfif local.contentRequireSubscriptionFlagDetails.settinginherited>checked="checked"</cfif>>#$.slatwall.rbKey('define.inherit')# ( #local.contentRequireSubscriptionFlagDetails.parentValueFormatted# )</label>
			</div>
		</div>
		<!--- Sell This Page --->
		<div class="control-group">
			<label class="control-label"><a href="##" rel="tooltip" data-original-title="#$.slatwall.rbKey('entity.content.allowPurchaseFlag_hint')#">#$.slatwall.rbKey('entity.content.allowPurchaseFlag')# <i class="icon-question-sign"></i></a></label>
			<div class="controls">
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.allowPurchaseFlag" value="1" data-checked-show="allowPurchaseDetails" <cfif !isNull($.slatwall.getContent().getAllowPurchaseFlag()) and $.slatwall.getContent().getAllowPurchaseFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.yes')#</label>
				<label class="radio inline span2"><input type="radio" name="slatwallData.content.allowPurchaseFlag" value="0" data-checked-hide="allowPurchaseDetails" <cfif isNull($.slatwall.getContent().getAllowPurchaseFlag()) or !$.slatwall.getContent().getAllowPurchaseFlag()>checked="checked"</cfif>>#$.slatwall.rbKey('define.no')#</label>
			</div>
		</div>
		<div id="allowPurchaseDetails">
			<div class="control-group">
				<table class="table table-striped table-condensed table-bordered mura-table-grid">
					<thead>
						<tr>
							<th class="var-width">#$.slatwall.rbKey('entity.product.title')#</th>
							<th class="var-width">#$.slatwall.rbKey('entity.sku.skuCode')#</th>
							<th class="var-width">#$.slatwall.rbKey('entity.define.price')#</th>
						</tr>
					</thead>
					<tbody>
						<cfif arrayLen($.slatwall.getContent().getSkus())>
							<cfloop array="#$.slatwall.getContent().getSkus()#" index="sku">
								<tr>
									<td class="var-width">#sku.getProduct().getTitle()#</td>
									<td>#sku.getSkuCode()#</td>
									<td>#sku.getProduct().getPrice()#</td>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<td id="noFilters" colspan="3" class="noResults">#$.slatwall.rbKey('mura.muraevent.oncontentedit.contentSkus.norecords')#</td>
							</tr>
						</cfif>
					</tbody>
				</table>
				<label class="control-label">#$.slatwall.rbKey('mura.muraevent.oncontentedit.createSkuHeader')#</label>
				<hr />
				<label class="control-label">#$.slatwall.rbKey('entity.productType')#</label>
				<div class="controls">
					<select name="slatwallData.content.addskudetails.productTypeID">
						<cfloop array="#local.productTypeOptions#" index="option">
							<option value="#option['value']#">#option['name']#</option>
						</cfloop>
					</select>
				</div>
				<label class="control-label">#$.slatwall.rbKey('entity.product')#</label>
				<div class="controls">
					<select name="slatwallData.content.addskudetails.productID">
						<option value="">#$.slatwall.rbKey('define.new')# #$.slatwall.rbKey('entity.product')#</option>
					</select>
				</div>
				<label class="control-label">#$.slatwall.rbKey('entity.sku')#</label>
				<div class="controls">
					<select name="slatwallData.content.addskudetails.skuID">
						<option value="">#$.slatwall.rbKey('define.new')# #$.slatwall.rbKey('entity.sku')#</option>
					</select>
				</div>
				<div id="newSkuDetails">
					<label class="control-label">#$.slatwall.rbKey('define.price')#</label>
					<div class="controls">
						<input type="text" name="slatwallData.content.addskudetails.price" value="" />
					</div>
				</div>
				<br />
				<br />
				<div class="form-actions" style="text-align:left;">
					<input type="hidden" name="slatwallData.content.addSku" value="0" />
					<button type="button" class="btn" id="addSkuBtn" onclick="addSku();document.contentForm.approved.value=1;if(siteManager.ckContent(draftremovalnotice)){submitForm(document.contentForm,'add');}"><i class="icon-check"></i> Add SKU & Publish</button>
				</div>
			</div>
		</div>
	</div>
	#request.slatwallScope.renderJSObject()#
</cfoutput>
<script type="text/javascript">
	<cfoutput>
		var rbNewProduct = '#$.slatwall.rbKey('define.new')# #$.slatwall.rbKey('entity.product')#';
		var	rbNewSku = '#$.slatwall.rbKey('define.new')# #$.slatwall.rbKey('entity.sku')#';
	</cfoutput>
	$(document).ready(function(e){
		updateSlatwallShowHide();
		$('selectshowhide').on('change', function(e) {
			updateSlatwallShowHide();
		});
		$('input[data-checked-show]').on('change', function(e) {
			updateSlatwallShowHide();
		});
		$('input[data-checked-hide]').on('change', function(e) {
			updateSlatwallShowHide();
		});
		$('select[name="slatwallData.content.addskudetails.productTypeID"]').on('change', function(e) {
			updateProductOptions();
		});
		$('select[name="slatwallData.content.addskudetails.productID"]').on('change', function(e) {
			updateSkuOptions();
		});
		$('select[name="slatwallData.content.addskudetails.skuID"]').on('change', function(e){
			if($(this).val().length) {
				$('#newSkuDetails').addClass('hide');
			} else {
				$('#newSkuDetails').removeClass('hide');
			}
		});
	});

	function addSku() {
		$('input[name="slatwallData.content.addSku"]').val(1);
	}

	function updateSlatwallShowHide() {
		$.each($('input[data-checked-show]:checked'), function(index, value) {
			$('#' + $(this).data('checked-show') ).removeClass('hide');
		});
		$.each($('input[data-checked-hide]:checked'), function(index, value) {
			$('#' + $(this).data('checked-hide') ).addClass('hide');
		});
		if( ! jQuery('#allowPurchaseDetails').hasClass('hide') ) {
			updateProductOptions();
		}
	}

	function updateProductOptions() {

		var ptid = jQuery('select[name="slatwallData.content.addskudetails.productTypeID"]').val() || '444df313ec53a08c32d8ae434af5819a';
		jQuery('select[name="slatwallData.content.addskudetails.productID"]').html('<option value="">' + rbNewProduct + '</option>');

		var productSmartList = $.slatwall.getSmartList('Product', {
			'fk:productType.productTypeIDPath':ptid,
			'p:show':'all',
			'propertyIdentifiers':'productID,calculatedTitle'
		});

		jQuery.each(productSmartList.pageRecords, function(i,v){
			jQuery('select[name="slatwallData.content.addskudetails.productID"]').append('<option value="' + v['productID'] + '">' + v['calculatedTitle'] + '</option>');
		});

	}

	function updateSkuOptions() {

		var pid = jQuery('select[name="slatwallData.content.addskudetails.productID"]').val() || '';
		jQuery('select[name="slatwallData.content.addskudetails.skuID"]').html('<option value="">' + rbNewSku + '</option>');

		if(pid.length) {
			var skuSmartList = $.slatwall.getSmartList('Sku', {
				'f:product.productID':pid,
				'p:show':'all',
				'propertyIdentifiers':'skuID,skuCode,price'
			});

			$.each(skuSmartList.pageRecords, function(i,v){
				$('select[name="slatwallData.content.addskudetails.skuID"]').append('<option value="' + v['skuID'] + '">' + v['skuCode'] + ' - ' + v['price'] + '</option>');
			});
		}
	}
</script>
<span id="extendset-container-slatwall" class="extendset-container"></span>
<span id="extendset-container-tabslatwallbottom" class="extendset-container"></span>
