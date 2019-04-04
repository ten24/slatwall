<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />


<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiListingDisplay
				recordDetailAction="admin:entity.detailordertemplate"
				collectionList="#rc.account.getOrderTemplatesCollectionList()#"
				usingPersonalCollection="false"
			>
			</hb:HibachiListingDisplay>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>	

