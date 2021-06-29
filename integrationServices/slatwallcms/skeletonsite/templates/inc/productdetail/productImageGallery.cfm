<cfimport prefix="sw" taglib="../../../tags" />
<cfoutput>
<!--- Start: Image Gallery Example --->
	<div class="row">
		<div class="span12">
			<h5>Image Gallery Example</h5>

			<cfset galleryDetails = local.product.getImageGalleryArray() />
			<!---[ DEVELOPER NOTES ]

				The primary method that makes images galleries possible is:

				$.slatwall.getImageGalleryArray( array resizedSizes )

				This is a very unique method to give you all the data you need to create an image gallery
				with whatever sizes.  The ImageGalleryArray will take whatever sizes you pass in, and pass
				back the details and resized image paths for all of the skus default images as well as any
				alternative images that were assigned to the product.

				For example, if you wanted to get 2 sizes back 100x100 and 500x500 so that you could
				display thumbnails ect.  You would just do:

				$.slatwall.getImageGalleryArray( [ {width=100, height=100}, {width=500, height=500} ] )


				By default if you don't pass in your own resizing array, it will just ask for the 3 sizes
				of Small, Medium, and Large which will get the actually sizes from the product settings.
				The logic it runs by default is the same as if you did this:

				$.slatwall.getImageGalleryArray( [ {size='small'},{size='medium'},{size='large'} ] )


				Basically every structure in the array, will just call the getResizedImagePath() method
				so you can pass in whatever resizing and cropping arguments you like based on the specs
				that you read more about here:

				http://docs.getslatwall.com/reference/product-images-and-cropping/

			--->

			<!--- If the product has more than the default image assigned, let's display all images --->
			<cfif arraylen(galleryDetails) GT "1">
				<ul class="thumbnails">
					<cfloop array="#galleryDetails#" index="image">
						<!---[ DEVELOPER NOTES ]
							Now that we are inside of the loop of images being returned, you have access to the
							following detials insilde of the image struct that came back in the array
						--->
						<li class="span3">
    						<img class="clickToOpenModal" src="#image.resizedimagepaths[1]#" alt="#image.name#">
    						<i class="icon-zoom-in"></i>
    						<span class="pull-right">
    							#image.name#
    						</span>
						</li>
					</cfloop>
				</ul>
			<cfelse>
				<p>There are no additional images.</p>
			</cfif>

		</div>
	</div>
	<!--- End: Image Gallery Example --->
</cfoutput>