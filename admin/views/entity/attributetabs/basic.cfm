<cfparam name="rc.attribute" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="activeFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="requiredFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeCode" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeHint" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="defaultValue" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeType" valueDefault="text" edit="#rc.edit and rc.attribute.isNew()#">
			<cf_HibachiDisplayToggle selector="select[name='attributeType']" showValues="relatedObjectSelect,relatedObjectMultiselect" loadVisable="#(!isNull(rc.attribute.getAttributeType()) && listFindNoCase('relatedObjectSelect,releatedObjectMultiselect', rc.attribute.getAttributeType()))#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="relatedObject" edit="#rc.edit and rc.attribute.isNew()#">
			</cf_HibachiDisplayToggle>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>