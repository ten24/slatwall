<script type="text/javascript">
	var jsEntities = {
		'boot':true
	};
	
	var loadJSEntity = function( entityName ) {
		
		var entityName = entityName || 'Product';
		
		if(jsEntities[entityName] === undefined) {
			
			var entityScript = document.createElement('script');
			entityScript.type = 'text/javascript';
			entityScript.async = true;
			entityScript.src = '?slatAction=api:meta.jsentity&entityName=' + entityName;
			
			var scripts = document.getElementsByTagName('script')[0];
			scripts.parentNode.insertBefore(entityScript, scripts);
			
		} else {
			var newProduct = new jsEntities[entityName]; 
			console.log(newProduct);
			console.log(newProduct.getactiveFlag());
		}
		
	}
	
	
</script>

<button type="button" onclick="loadJSEntity()">
	Load Product JS
</button>