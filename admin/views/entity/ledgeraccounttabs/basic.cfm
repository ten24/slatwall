<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.ledgeraccount" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.ledgeraccount#" property="ledgerAccountName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.ledgeraccount.getLedgerAccountType()#" property="typeName" edit="false">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>