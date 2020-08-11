<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfoutput>
	<div class="row">
	<div class="col-md-12">
		<cfif len(getHibachiScope().getAllErrorsHTML()) >
			<div class="alert alert-danger">
				#getHibachiScope().getAllErrorsHTML()#
			</div> 
		</cfif> 
	
		<cfif len(getHibachiScope().getAllMessagesHTML()) >
			<div class="alert alert-success">
				#getHibachiScope().getAllMessagesHTML()# 
			</div>
		</cfif> 
	</div>
	</div>
	<div class="row">
<div class="col-md-6">
 <div class="panel panel-default">
	  <div class="panel-heading">CSV Upload</div>
			<div class="panel-body">
				<form name="csvimport" action="?s=1" method="post" enctype="multipart/form-data">
						<input type="hidden" name="slatAction" value="slatwallimporter:main.uploadCSV" />
			<div class="form-group">
			<label for="importNowFlag">Select Entity</label>
			<select id="entity" name="allenttity" class="form-control">
				<option value="entity1">entity1</option>
				<option value="entity2">entity2</option>
				<option value="entity3">entity3</option>
				<option value="entity4">entity4</option>
				<option value="entity5">entity5</option>
    		</select>  
			</div> 
		   <div class="form-group">
				<label for="importFile">Import File</label> 
				<input id="csvUpload" type="file" name="importFile" class="form-control" required />
			</div> 
			<div class="form-group">
			 <input type="submit" name="Submit"  class="btn btn-primary" /> 
			</div>
		</form>
		    </div>
</div>
	</div>
	<div class="col-md-6">
		<div class="panel panel-default">
	  <div class="panel-heading">Download</div>
			<div class="panel-body">
			<div class="form-group">
				<label for="importFile">Download sample  File</label> 
			</div> 
	    </div>
		 <cfdirectory action="list" directory="#ExpandPath('/integrationServices/slatwallimporter/assets/downloadsample/')#" name="listRoot">
		<ul class="list-group">
		<cfloop query="listRoot">
				<li class="list-group-item"><a id="downloadfile" href="#ExpandPath('/integrationServices/slatwallimporter/assets/downloadsample/#name#')#" download>#name# Sample</a></br></li>
        </cfloop>
	   </ul>
		</div>
	</div>
</cfoutput>
<!-- test code-->
	<!--<script type="text/javascript">
		$(function(){
			$("#entity").on("change",function(){
	
				$("#downloadfile").html($(this).val()+ "  CSV Sample");
			});
			
		});
	</script>-->