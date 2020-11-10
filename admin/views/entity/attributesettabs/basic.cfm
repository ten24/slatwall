<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.attributeSet" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<cfif rc.slatAction neq "admin:entity.createattributeset">
			<cfset detailPageDivClass = "col-md-6" />
		<cfelse>
			<cfset detailPageDivClass = "" />
		</cfif>
		
		<hb:HibachiPropertyList divclass="#detailPageDivClass#">
			<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetObject" edit="#rc.attributeSet.isNew()#">
			<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#">
			<cfif rc.attributeSet.isNew()>
				<hb:HibachiDisplayToggle selector="select[name='attributeSetObject']" showValues="Content,OrderItem,Product,ProductType,Sku,Type" loadVisable="#listFindNoCase('OrderItem,Product,ProductType,Sku', rc.attributeSet.getAttributeSetObject())#">
					<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#rc.edit#">
				</hb:HibachiDisplayToggle>
			</cfif>
		</hb:HibachiPropertyList>

		<cfif !rc.attributeSet.isNew()>
			<hb:HibachiPropertyList divclass="col-md-6">
				<cfset local.canEditGlobal = listFindNoCase( "OrderItem,Product", rc.attributeSet.getAttributeSetObject() ) && rc.edit />
				<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#local.canEditGlobal#">
				<cfif listFind( "OrderItem", rc.attributeSet.getAttributeSetObject() )>
					<hb:HibachiPropertyDisplay object="#rc.attributeSet#" property="accountSaveFlag" edit="#rc.edit#">
				</cfif>
			</hb:HibachiPropertyList>
		</cfif>
	</hb:HibachiPropertyRow>
</cfoutput>