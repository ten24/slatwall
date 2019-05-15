<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.edit" type="boolean" />
<cfoutput>
    <cfset indexoptions = $.slatwall.getService('algoliaService').getIndexOptions()/>
    <form name="rebuildIndex" action="/?s=1" method="POST">
        <input name="slatAction" value="algolia:main.rebuildindex" type="hidden"/>
        <div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<a class="close" data-dismiss="modal">&times;</a>
							<h3>Re-Build Index</h3>
						</div>
						<div class="modal-body">
							<hb:HibachiPropertyRow>
								<hb:HibachiPropertyList>
		                            <hb:HibachiFieldDisplay title="Index" edit="true" fieldName="dataResourceID" fieldtype="select" valueOptions="#indexoptions#">
		                            <hb:HibachiFieldDisplay title="Start Time" edit="true" fieldName="startTime" fieldtype="datetime" >
								</hb:HibachiPropertyList>
                            </hb:HibachiPropertyRow>
                            
						</div>
					<div class="modal-footer">
						<hb:HibachiActionCaller type="button" class="btn btn-success" icon="ok icon-white" text="Re-Build">
					</div>
				</div>
			</div>
    </form>
</cfoutput>