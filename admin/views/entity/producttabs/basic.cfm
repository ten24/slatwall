<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
				<cfif rc.product.getBaseProductType() EQ "event">
				<cf_HibachiPropertyDisplay object="#rc.product#" property="purchaseStartDateTime" hb_rbKey="entity.product.purchaseStartDateTime" edit="#rc.edit#"/>
				<cf_HibachiPropertyDisplay object="#rc.product#" property="purchaseEndDateTime" hb_rbKey="entity.product.purchaseEndDateTime" edit="#rc.edit#"/>
			</cfif>
		</cf_HibachiPropertyList>
		<cf_HibachiPropertyList divClass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
			<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
			<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>