<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
    <div class="span4">
    	<div class="well">
    		<!--- Display primary product image if it exists or the product image placeholder  --->
    		<cfif local.product.getImageExistsFlag()>
    			<!--- If the image exists, display image with link to full version --->
    			<img src="#local.product.getImagePath()#" class="clickToOpenModal" />
    		<cfelse>
    			<!--- If the image doesn't exists, display image with link to full version --->
    			#local.product.getImage(size="m")#
    		</cfif>
    	</div>
    </div>
</cfoutput>