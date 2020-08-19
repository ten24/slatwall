<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.integration" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.fileslist" type="any">

<hb:HibachiEntityProcessForm entity="#rc.integration#" edit="#rc.edit#" enctype="multipart/form-data">
    <hb:HibachiEntityActionBar type="preprocess" object="#rc.integration#">
    </hb:HibachiEntityActionBar>
        <hb:HibachiPropertyRow>
            <hb:HibachiPropertyList>
                <hb:HibachiPropertyDisplay object="#rc.processObject#" property="entityName" edit="#rc.edit#">
                </hb:HibachiPropertyDisplay>
                <hb:HibachiPropertyDisplay object="#rc.processObject#" property="uploadFile" edit="#rc.edit#">
                </hb:HibachiPropertyDisplay>
            </hb:HibachiPropertyList>
        </hb:HibachiPropertyRow>
    <cfoutput>
     <hb:HibachiPropertyRow>
    	<hb:HibachiPropertyList>
		    <cfloop array="#rc.fileslist#" item="filename">
		    <a href="#request.slatwallScope.getBaseUrl()#/integrationServices/#rc.integration.getIntegrationPackage()#/assets/downloadsample/#filename#">Download the #filename# Sample CSV</a></br>
		   </cfloop> 
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	</cfoutput>
</hb:HibachiEntityProcessForm>
   
  
   
   
