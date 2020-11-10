<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.attributeOption" type="any">
<cfparam name="rc.attribute" type="any" default="#rc.attributeOption.getAttribute()#">
<cfparam name="rc.edit" type="boolean">
<cfoutput>
	<hb:HibachiListingDisplay smartList="#rc.attributeOption.getEntityWithOptionSmartList()#">
        <cfswitch expression="#rc.attribute.getAttributeSet().getAttributeSetObject()#">
			<cfcase value="Sku">
                <hb:HibachiListingColumn propertyIdentifier="SkuCode" />
                <hb:HibachiListingColumn propertyIdentifier="product.productName" />
            </cfcase>
			<cfdefaultcase>
				<hb:HibachiListingColumn propertyIdentifier="simpleRepresentation" title="#$.slatwall.rbKey('entity.' & rc.attribute.getAttributeSet().getAttributeSetObject())#"/>
			</cfdefaultcase>
        </cfswitch>
    </hb:HibachiListingDisplay>
</cfoutput>