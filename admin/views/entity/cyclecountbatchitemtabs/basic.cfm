<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.cyclecountbatchitem" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiFieldDisplay title="Sku" value="#rc.cyclecountbatchitem.getStock().getSku().getSkuCode()#">
			<hb:HibachiFieldDisplay title="Location" value="#rc.cyclecountbatchitem.getStock().getLocation().getLocationName()#">
			<hb:HibachiPropertyDisplay object="#rc.cyclecountbatchitem#" property="quantity" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
