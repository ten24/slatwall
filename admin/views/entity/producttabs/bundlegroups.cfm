 <span ng-controller="edit-bundle-controller">
		
	  <section class="col-xs-12" >
	
	    
	    <span 	sw-product-bundle-groups
	    		data-product-bundle-groups="processObject.productBundleGroups.value"
	    >
	    </span>
	    <button class="btn btn-xs s-btn-grey s-create-bundle-btn"
	    		data-toggle="collapse" 
	    		ng-click="addProductBundleGroup()"
	    >
	    	<i class="fa fa-plus"></i> Bundle Group
	    </button>
	  </section>
</span>