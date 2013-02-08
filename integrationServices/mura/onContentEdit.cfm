<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfset request.slatwallScope.getService("settingService").clearAllSettingsQuery() />
<cfset slatwallContent = request.slatwallScope.getService("contentService").getContentByCmsContentID($.content("contentID"), true) />

<cfset slatwallProductSmartList = request.slatwallScope.getService("productService").getSmartList(entityName="SlatwallProduct") />
<cfset slatwallProductSmartList.addLikeFilter(propertyIdentifier="productType_productTypeIDPath", value="%444df313ec53a08c32d8ae434af5819a%") />
<cfset slatwallProducts = slatwallProductSmartList.getRecords() />

<cfset restrictedContentTemplates = request.slatwallScope.getService("contentService").listContentFilterByTemplateFlag(1) />

<cfset contentRestrictAccessFlag = slatwallContent.getSettingDetails('contentRestrictAccessFlag') />
<cfset contentRequirePurchaseFlag = slatwallContent.getSettingDetails('contentRequirePurchaseFlag') />
<cfset contentRequireSubscriptionFlag = slatwallContent.getSettingDetails('contentRequireSubscriptionFlag') />
<cfoutput>
	<dl class="oneColumn">
		<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.templateFlag_hint")#" fieldName="slatwallData.templateFlag" fieldType="yesno" value="#slatwallContent.getTemplateFlag()#" edit="true">
		<cf_SlatwallSetting settingName="contentProductListingFlag" settingObject="#slatwallContent#" />
		<div class="productListingFlagRelated">
			<cf_SlatwallSetting settingName="contentIncludeChildContentProductsFlag" settingObject="#slatwallContent#" />
			<cf_SlatwallSetting settingName="contentDefaultProductsPerPage" settingObject="#slatwallContent#" />
			<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.disableProductAssignmentFlag_hint")#" fieldName="slatwallData.disableProductAssignmentFlag" fieldType="yesno" value="#slatwallContent.getDisableProductAssignmentFlag()#" edit="true">
		</div>
		<cf_SlatwallSetting settingName="contentRestrictedContentDisplayTemplate" settingObject="#slatwallContent#" />
		<cf_SlatwallSetting settingName="contentRestrictAccessFlag" settingObject="#slatwallContent#" />
		<div class="restrictAccessFlagRelated">
			<cf_SlatwallFieldDisplay title="#request.slatwallScope.rbKey("entity.content.allowPurchaseFlag_hint")#" fieldName="slatwallData.allowPurchaseFlag" fieldType="yesno" value="#slatwallContent.getAllowPurchaseFlag()#" edit="true">
			<div class="requirePurchaseFlag">
				<cf_SlatwallSetting settingName="contentRequirePurchaseFlag" settingObject="#slatwallContent#" />
			</div>
			<div class="requireSubscriptionFlag">
				<cf_SlatwallSetting settingName="contentRequireSubscriptionFlag" settingObject="#slatwallContent#" />
			</div>
					
			<div class="allowPurchaseFlagRelated" id="allowPurchaseFlagRelated">
				<!--- show all the skus for this content --->
				<cfif arrayLen(slatwallContent.getSkus())>
					<dt>
						<label>This Content is currently assigned to these skus:</label>
					</dt>
					<dd>
						<table>
							<tr>
								<th>Product</th>
								<th>Sku Code</th>
								<th>Price</th>
								<th></th>
							</tr>
							<cfloop array="#slatwallContent.getSkus()#" index="local.sku">
								<tr>
									<td><a href="#request.slatwallScope.getSlatwallRootPath()#/?slatAction=product.edit&productID=#sku.getProduct().getProductID()#">#sku.getProduct().getProductName()#</a></td>
									<td>#sku.getSkuCode()#</td>
									<td>#sku.getPrice()#</td>
									<td><a href="" class="delete" /></td>
								</tr>					
							</cfloop>
						</table>
					</dd>
					<input type="hidden" name="slatwallData.addSku" value="0" />
					<dt>Add Another Sku <a href="##" id="addSkuRelatedLink" onclick="toggleDisplay('addSkuRelated','Expand','Close');return setupAddSku();return false;">[Expand]</a></dt>
				<cfelse>
					<input type="hidden" name="slatwallData.addSku" value="1" />
				</cfif>
				
				<!--- add new sku --->
				<div class="addSkuRelated" id="addSkuRelated">
					<dt>
						<label for="slatwallData.product.productID">Sell Access through an existing or new Product </label>
					</dt>
					<dd>
						<div>
							Product: 
							<div>
								<select name="slatwallData.product.productID">
									<option value="">New Product</option>
									<cfloop array="#slatwallProducts#" index="local.product">
										<option value="#product.getProductID()#">#product.getProductName()#</option>
									</cfloop>
								</select>
							</div>
						</div>
						</br>
						<div>
							Sku:
							<div>
								<select name="slatwallData.product.sku.skuID">
									<option value="">New Sku</option>
								</select>
							</div>	
						</div>
					</dd>
					<div class="skuRelated">
						<dt>
							<label for="slatwallData.product.price">Price</label>
						</dt>
						<dd>
							<input name="slatwallData.product.price" value="" />
						</dd>
					</div>
				</div>
			</div>
		</div>
	</dl>
</cfoutput>

<cfoutput>
<script type="text/javascript">
var $ = jQuery;
function setupTemplateFlagDisplay() {
	if ($('input[name="slatwallData.templateFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.templateFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.templateFlag"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.setting.contentProductListingFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').filter('[value=0]').prop('checked', true).change();
	}
}

function setupProductListingFlagDisplay() {
	if($('input[name="slatwallData.setting.contentProductListingFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.setting.contentProductListingFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.setting.contentProductListingFlag"]').val();
	}
	// check inherited value
	if(selectedValue == '') {
		var selectedValue = $('input[name="contentProductListingFlagInherited"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.templateFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.productListingFlagRelated').show();
	} else {
		$('input[name="slatwallData.setting.contentIncludeChildContentProductsFlag"]').filter('[value=""]').prop('checked', true).change();
		$('input[name="slatwallData.disableProductAssignmentFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentDefaultProductsPerPage"]').val('');
		$('.productListingFlagRelated').hide();
	}
}

function setupRestrictAccessFlagDisplay() {
	if ($('input[name="slatwallData.setting.contentRestrictAccessFlag"]:checked').length > 0) {
		var selectedValue = $('input[name="slatwallData.setting.contentRestrictAccessFlag"]:checked').val();
	} else {
		var selectedValue = $('input[name="slatwallData.setting.contentRestrictAccessFlag"]').val();
	}
	// check inherited value
	if(selectedValue == '') {
		var selectedValue = $('input[name="contentRestrictAccessFlagInherited"]').val();
	}
	if(selectedValue == 1){
		$('input[name="slatwallData.templateFlag"]').filter('[value=0]').prop('checked', true).change();
		$('input[name="slatwallData.setting.contentProductListingFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.restrictAccessFlagRelated').show();
		setupAllowPurchaseFlagDisplay();
	} else {
		$('input[name="slatwallData.allowPurchaseFlag"]').filter('[value=0]').prop('checked', true).change();
		$('.restrictAccessFlagRelated').hide();
	}
}

function setupAllowPurchaseFlagDisplay() {
	var selectedValue = $('input[name="slatwallData.allowPurchaseFlag"]:checked').val();
	if(selectedValue == 1){
		$('.allowPurchaseFlagRelated').show();
	} else {
		$('.allowPurchaseFlagRelated').hide();
	}
	if($('input[name="slatwallData.addSku"]').val() == 1) {
		$('.addSkuRelated').show();
	} else {
		$('.addSkuRelated').hide();
	}
	setupRequirePurchaseFlagDisplay();
}

function setupRequirePurchaseFlagDisplay() {
	var selectedValue = $('input[name="slatwallData.allowPurchaseFlag"]:checked').val();
	if(selectedValue == undefined || selectedValue == "0"){
		$('.requirePurchaseFlag').hide();
	} else {
		$('.requirePurchaseFlag').show();
	}
}

function setupAddSku() {
	if ($('.addSkuRelated').is(':visible')) {
		$('input[name="slatwallData.addSku"]').val(1);
	} else {
		$('input[name="slatwallData.addSku"]').val(0);
	}
}
	
$(document).ready(function(){
	
	$('input[name="slatwallData.templateFlag"]').change(function(){
		setupTemplateFlagDisplay();
	});
	
	$('input[name="slatwallData.setting.contentProductListingFlag"]').change(function(){
		setupProductListingFlagDisplay();
	});
	
	$('input[name="slatwallData.setting.contentRestrictAccessFlag"]').change(function(){
		setupRestrictAccessFlagDisplay();
	});
	
	$('input[name="slatwallData.addSku"]').change(function(){
		$('.allowPurchaseFlagRelated').show();
	});
	
	$('input[name="slatwallData.allowPurchaseFlag"]').change(function(){
		setupAllowPurchaseFlagDisplay();
	});
	
	$('select[name="slatwallData.product.sku.skuID"]').change(function() {
		if($(this).val() != ""){
			$('.skuRelated').hide();
		} else {
			$('.skuRelated').show();
		}
	});
	
	$('select[name="slatwallData.product.productID"]').change(function() {
		
		var postData = {};
		postData['slatAction'] = 'admin:ajax.updateListingDisplay';
		postData['entityName'] = 'Sku';
		postData['F:product.productID'] = $('select[name="slatwallData.product.productID"]').val();
		postData['P:Show'] = 'all';
		postData['propertyIdentifiers'] = 'skuID,skuCode,price';
		

		$.ajax({
			type: 'get',
			url: '#request.slatwallScope.getSlatwallRootURL()#',
			data: postData,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
			success: function(r) {
				$('select[name="slatwallData.product.sku.skuID"]').html('');
				$('select[name="slatwallData.product.sku.skuID"]').append('<option value="">New Sku</option>');
				if(r["pageRecords"].length > 0){
					$.each(r["pageRecords"],function(index,value){
						var option = '<option value="'+value['skuID']+'">'+value['price']+' - '+value['skuCode']+'</option>';
						$('select[name="slatwallData.product.sku.skuID"]').append(option);
					});
				}
			}, error: function(r) {
				alert("Error Loading Skus");
			}
		});
		
	});
	
	setupTemplateFlagDisplay();
	setupProductListingFlagDisplay();
	setupRestrictAccessFlagDisplay();
	setupAllowPurchaseFlagDisplay();
});
</script>
</cfoutput>
