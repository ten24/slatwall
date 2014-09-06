<cfparam name="rc.attributeSet" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="col-md-6">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetType" edit="#rc.attributeSet.isNew()#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="attributeSetCode" edit="#rc.edit#">
			<cfif rc.attributeSet.isNew()>
				<cf_HibachiDisplayToggle selector="select[name='attributeSetType.typeID']" showValues="444df292eea355ddad72f5614726bc75,444df293fcc530434949d63e408cac2b,444df328fa718364a389a4495f386a27,5accbf52063a5b4e2a73f19f4151cc40" loadVisable="#rc.attributeSet.getNewFlag() or listFindNoCase('444df292eea355ddad72f5614726bc75,444df293fcc530434949d63e408cac2b,444df328fa718364a389a4495f386a27,5accbf52063a5b4e2a73f19f4151cc40', rc.attributeSet.getAttributeSetType().getTypeID())#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#rc.edit#">
				</cf_HibachiDisplayToggle>
			</cfif>
		</cf_HibachiPropertyList>
		
		<cfif !rc.attributeSet.isNew()>
			<cf_HibachiPropertyList divclass="col-md-6">
				<cfset local.canEditGlobal = listFind( "astProduct,astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() ) && rc.edit />
				<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="globalFlag" edit="#local.canEditGlobal#">
				<cfif listFind( "astOrderItem", rc.attributeSet.getAttributeSetType().getSystemCode() )>
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="requiredFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="accountSaveFlag" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.attributeSet#" property="additionalCharge" edit="#rc.edit#">
				</cfif>
			</cf_HibachiPropertyList>
		</cfif>
	</cf_HibachiPropertyRow>
</cfoutput>