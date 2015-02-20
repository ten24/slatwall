<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.collection" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionName" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionObject" edit="false">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionDescription" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.collection#" property="collectionCode" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>
