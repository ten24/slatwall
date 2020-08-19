<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.integration" type="any" />
<cfparam name="rc.edit" type="boolean" />

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
     <hb:HibachiPropertyRow>
     <cfdirectory action="list" directory="#ExpandPath('/integrationServices/slatwallimporter/assets/downloadsample/')#" name="listRoot">
       <ul class="list-group">
            <cfloop query="listRoot">
               <li class="list-group-item">
                <a target="_blank"  href="#$.slatwall.getApplicationValue('baseURL')#/integrationServices/slatwallimporter/assets/downloadsample/#name#" download="#name#">#name# Sample</a>
                </br>
              </li>
            </cfloop>
       </ul>
      </hb:HibachiPropertyRow>
</hb:HibachiEntityProcessForm>
   
  
   
   
