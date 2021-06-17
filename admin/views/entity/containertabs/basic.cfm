<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.container" type="any">

<cfoutput>
	<div class="col-md-6">
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<cfif !isNull(rc.container.getContainerPreset()) >
			    	<hb:HibachiPropertyDisplay object="#rc.container.getContainerPreset()#" property="containerName" edit="false">
	    		</cfif>
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="height" edit="false">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="width" edit="false">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="depth" edit="false">
            	<hb:HibachiPropertyDisplay object="#rc.container#" property="weight" edit="false">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
	</div>
</cfoutput>


