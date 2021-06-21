<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<hb:HibachiEntityProcessForm entity="#rc.product#" edit="#rc.edit#" enctype="multipart/form-data">
		
		<hb:HibachiEntityActionBar type="preprocess" object="#rc.processObject#">
		</hb:HibachiEntityActionBar>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.processObject#" property="uploadFile" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.processObject#" 
										property="imageNameProductProperty" 
										fieldName="imageNameProductProperty" 
										fieldType="select" 
										edit="#rc.edit#"/>

			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
	</hb:HibachiEntityProcessForm>
</cfoutput>