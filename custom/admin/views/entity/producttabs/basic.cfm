<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
			<cfset local.formattedStartDate="#dateFormat(rc.product.getPublishedStartDateTime(), 'mm/dd/YYYY')#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="publishedStartDateTime" edit="#rc.edit#" fieldType="text" fieldAttributes="sw-date-picker 
														ng-model=""publishedStartDateTime""
														ng-init=""publishedStartDateTime='#local.formattedStartDate#'""
														autocomplete=""off"" ng-cloak">
			
			<cfset local.formattedEndDate="#dateFormat(rc.product.getPublishedEndDateTime(), 'mm/dd/YYYY')#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="publishedEndDateTime" edit="#rc.edit#" fieldType="text" fieldAttributes="sw-date-picker 
														ng-model=""publishedEndDateTime""
														ng-init=""publishedEndDateTime='#local.formattedEndDate#'""
														autocomplete=""off"" ng-cloak">
			
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
			<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="purchaseStartDateTime" hb_rbKey="entity.product.purchaseStartDateTime" edit="#rc.edit#"/>
				<hb:HibachiPropertyDisplay object="#rc.product#" property="purchaseEndDateTime" hb_rbKey="entity.product.purchaseEndDateTime" edit="#rc.edit#"/>
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.product#" property="deferredRevenueFlag" edit="#rc.edit#">
			<hb:HibachiDisplayToggle 
				selector="input[name='deferredRevenueFlag']"  
				loadVisable="#rc.product.getDeferredRevenueFlag()#" showValues="1"
			>
				<cfif !isNull(rc.product.getNextDeliveryScheduleDate())>
					<hb:HibachiPropertyDisplay object="#rc.product.getNextDeliveryScheduleDate()#" property="deliveryScheduleDateValue" edit="false">
				</cfif>
			</hb:HibachiDisplayToggle>
			
			
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
			<cfif rc.product.getBaseProductType() eq "productBundle" && !isNull(rc.product.getDefaultSku())>
				<hb:HibachiPropertyDisplay object="#rc.product.getDefaultSku()#" fieldname="defaultSku.price" property="price" edit="#rc.edit#">
				<input type="hidden" name="defaultSku.skuID" value="#rc.product.getDefaultSku().getSkuID()#" />            
			</cfif>
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
			<cfif rc.product.getBaseProductType() eq "subscription" && !isNull(rc.product.getRenewalSku()) && !rc.edit>
				<hb:HibachiPropertyDisplay object="#rc.product.getRenewalSku()#" fieldname="renewalSku.skuCode" property="skuCode" edit="#rc.edit#" title="#$.slatwall.getRBKey('define.renewalSku')#" valuelink="#$.slatwall.buildURL(action='admin:entity.detailsku',querystring='skuID=#rc.product.getRenewalSku().getSkuID()#')#"/>
			<cfelseif rc.product.getBaseProductType() eq "subscription" && !isNull(rc.product.getRenewalSku()) && rc.edit>
				<swa:SlatwallErrorDisplay object="#rc.product#" errorName="renewalSku" />
				<hb:HibachiListingDisplay smartList="#rc.product.getSubscriptionSkuSmartList()#"
										  selectValue="#rc.product.getRenewalSku().getSkuID()#"
										  selectFieldName="renewalSku.skuID" 
										  title="#$.slatwall.rbKey('define.renewalSku')#" 
										  edit="#rc.edit#">
					<hb:HibachiListingColumn propertyIdentifier="skuCode" />
					<hb:HibachiListingColumn propertyIdentifier="skuName" />
					<hb:HibachiListingColumn propertyIdentifier="skuDescription" />
					<hb:HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
					<hb:HibachiListingColumn propertyIdentifier="price" />
				</hb:HibachiListingDisplay>
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
