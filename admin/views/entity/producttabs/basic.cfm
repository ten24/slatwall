<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
				<cfif rc.product.getBaseProductType() EQ "event">
				<hb:HibachiPropertyDisplay object="#rc.product#" property="purchaseStartDateTime" hb_rbKey="entity.product.purchaseStartDateTime" edit="#rc.edit#"/>
				<hb:HibachiPropertyDisplay object="#rc.product#" property="purchaseEndDateTime" hb_rbKey="entity.product.purchaseEndDateTime" edit="#rc.edit#"/>
			</cfif>
		</hb:HibachiPropertyList>
		<hb:HibachiPropertyList divClass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
			<hb:HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>