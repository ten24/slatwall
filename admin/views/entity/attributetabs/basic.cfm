<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

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
			<cf_HibachiPropertyDisplay object="#rc.attribute#" property="attributeInputType" valueDefault="text" edit="#rc.edit and rc.attribute.isNew()#">
			<cf_HibachiDisplayToggle selector="select[name='attributeInputType']" showValues="relatedObjectSelect,relatedObjectMultiselect" loadVisable="#(!isNull(rc.attribute.getAttributeInputType()) && listFindNoCase('relatedObjectSelect,releatedObjectMultiselect', rc.attribute.getAttributeInputType()))#">
				<cf_HibachiPropertyDisplay object="#rc.attribute#" property="relatedObject" edit="#rc.edit and rc.attribute.isNew()#">
			</cf_HibachiDisplayToggle>
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
</cfoutput>