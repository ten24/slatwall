<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.importerMapping" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.importerMapping#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.importerMapping#" edit="#rc.edit#" />
		<div class="s-top-spacer">
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList>
					<hb:HibachiPropertyDisplay object="#rc.importerMapping#" property="name" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.importerMapping#" property="mappingCode" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.importerMapping#" property="description" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.importerMapping#" property="baseObject" edit="#rc.edit#">
                    <hb:HibachiPropertyDisplay object="#rc.importerMapping#" property="mapping" edit="#rc.edit#" fieldType="json" fieldAttributes="rows='20'">
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>
		</div>
	</hb:HibachiEntityDetailForm>
	</span>
</cfoutput>