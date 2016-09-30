<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.attribute" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="activeFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="requiredFlag" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="attributeName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="attributeCode" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="attributeHint" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="defaultValue" edit="#rc.edit#">
			<cfif !isNull(rc.attributeSet) AND !isNull(rc.attributeSet.getAttributeSetObject()) AND rc.attributeSet.getAttributeSetObject() EQ "OrderItem">
				<hb:HibachiPropertyDisplay object="#rc.attribute#" property="displayOnOrderDetailFlag" edit="#rc.edit#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.attribute#" property="attributeInputType" valueDefault="text" edit="#rc.edit and rc.attribute.isNew()#">
			<hb:HibachiDisplayToggle selector="select[name='attributeInputType']" showValues="relatedObjectSelect,relatedObjectMultiselect" loadVisable="#(!isNull(rc.attribute.getAttributeInputType()) && listFindNoCase('relatedObjectSelect,releatedObjectMultiselect', rc.attribute.getAttributeInputType()))#">
				<hb:HibachiPropertyDisplay object="#rc.attribute#" property="relatedObject" edit="#rc.edit#">
			</hb:HibachiDisplayToggle>
			<hb:HibachiDisplayToggle selector="select[name='attributeInputType']" showValues="typeSelect" loadVisable="#(!isNull(rc.attribute.getAttributeInputType()) && listFindNoCase('typeSelect', rc.attribute.getAttributeInputType()))#">
				<hb:HibachiPropertyDisplay object="#rc.attribute#" property="typeSet" edit="#rc.edit#">
			</hb:HibachiDisplayToggle>
			<cfif !isNull(rc.attribute.getForm())>
 				<hb:HibachiPropertyDisplay object="#rc.attribute#" property="formEmailConfirmationFlag" edit="#rc.edit#">
 			</cfif> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
