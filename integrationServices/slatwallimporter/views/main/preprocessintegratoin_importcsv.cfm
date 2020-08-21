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
</hb:HibachiEntityProcessForm>
   
  
   
   
