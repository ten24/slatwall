<cfparam name="rc.attributeSet" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetObject" edit="#rc.attributeSet.isNew()#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#">
			<cfif rc.attributeSet.isNew()>
				<cf_HibachiDisplayToggle selector="select[name='attributeSetObject']" showValues="OrderItem,Product,ProductType,Sku" loadVisable="#listFindNoCase('OrderItem,Product,ProductType,Sku', rc.attributeSet.getAttributeSetObject())#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cfif>
		</cf_HibachiPropertyList>
		
		<cfif !rc.attributeSet.isNew()>
			<cf_HibachiPropertyList divclass="col-md-6">
				<cfset local.canEditGlobal = listFindNoCase( "OrderItem,Product", rc.attributeSet.getAttributeSetObject() ) && rc.edit />
				<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#local.canEditGlobal#">
				<cfif listFind( "OrderItem", rc.attributeSet.getAttributeSetObject() )>
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="requiredFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="accountSaveFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="additionalCharge" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
		</cfif>
	</cf_HibachiPropertyRow>
</cfoutput>