<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfoutput>
<div class="col-md-6">
		<h1>CSV Importer</h1>

		<form name="csvimport" action="?s=1" method="post" enctype="multipart/form-data">
		   <div class="form-group">
				<label for="importFile">Import File</label> 
				<input id="csvUpload" type="file" name="importFile" class="form-control" required />
			</div> 

			<div class="form-group">
			   <label for="importNowFlag">Select Entity</label>
				<select name="slatAction">
				<option value="entity1">entity1</option>
				<option value="entity2">entity2</option>
				<option value="entity3">entity3</option>
				<option value="entity4">entity4</option>
				<option value="entity5">entity5</option>
    			</select>  
			</div> 

			<div class="form-group">
			 <input type="submit" name="Submit" /> 
			</div>
		</form>
	</div>
	<div class="col-md-6">
		   <div class="form-group">
				<label for="importFile">Download sample  File</label> 
				
			</div> 
			<div class="form-group">
			   <label for="importNowFlag">Import Type</label>
				<select name="slatAction">
				<option value="entity1">entity1</option>
				<option value="entity2">entity2</option>
				<option value="entity3">entity3</option>
				<option value="entity4">entity4</option>
				<option value="entity5">entity5</option>
    			</select>  
			</div> 
	</div>
</cfoutput>