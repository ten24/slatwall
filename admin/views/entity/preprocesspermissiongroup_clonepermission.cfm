<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.permissiongroup" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfset rc.edit = true />
<hb:HibachiEntityProcessForm entity="#rc.permissiongroup#" edit="#rc.edit#">

    <hb:HibachiEntityActionBar type="preprocess" object="#rc.permissiongroup#"></hb:HibachiEntityActionBar>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="fromPermissionGroupID" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="actionPermissionFlag" edit="#rc.edit#" />
			<hb:HibachiPropertyDisplay object="#rc.processObject#" property="dataPermissionFlag" edit="#rc.edit#" />
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>

</hb:HibachiEntityProcessForm>