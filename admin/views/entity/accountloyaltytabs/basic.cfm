<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.accountLoyalty" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>	
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.accountLoyalty#" property="loyalty" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.accountLoyalty#" property="lifetimeBalance" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>