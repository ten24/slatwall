<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.sku" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
    <hb:HibachiPropertyRow>
        <hb:HibachiPropertyList>
            <hb:HibachiPropertyDisplay object="#rc.sku#" property="vipFlag" edit="#rc.edit#">
            <hb:HibachiPropertyDisplay object="#rc.sku#" property="mpFlag" edit="#rc.edit#">
            <hb:HibachiPropertyDisplay object="#rc.sku#" property="retailFlag" edit="#rc.edit#">
        </hb:HibachiPropertyList>
    </hb:HibachiPropertyRow>
</cfoutput>