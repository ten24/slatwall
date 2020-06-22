<!---
	File: BarbecueService.cfc
	The Barbecue service component provides the services necessary to
	generate barcode images onto your web pages. It supports all the formats 
	supported by the Barbecue Barcode Java library, as well as the ability
	to scale and rotate the barcodes.
	
	The following types are supported (per the barbecue documentation):
		- code128
		- 2of7
		- 3of9
		- bookland
		- codabar
		- code128a
		- code128b
		- code128c
		- code39
		- ean128
		- ean13
		- globaltradeitemnumber
		- int2of5
		- monarch
		- nw7
		- pdf417
		- postnet
		- randomweightupca
		- scc14shippingcode
		- shipmentidentificationnumber
		- sscc18
		- std2of5
		- upca
		- usd3
		- usd4
		- usps
		
	Author:
		Adam Presley
		
	Email:
		adam@adampresley.com
		
	Package:
		com.adampresley.barbecue

	License:
		Copyright 2010 Adam Presley

		Licensed under the Apache License, Version 2.0 (the "License");
		you may not use this file except in compliance with the License.
		You may obtain a copy of the License at

		    http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
--->
<cfcomponent output="false">
	<cfsetting showdebugoutput="false" />
	
	<!---
		Constructor: init
		This is the constructor that initializes the component. Used when 
		instantiating directly.
		
		Author:
			Adam Presley
			
		Returns:
			An instance of the BarbecueService component
	--->
	<cffunction name="init" returntype="any" access="public" output="false">
		<cfset __prepareVariables() />
		<cfreturn this />
	</cffunction>


	<!---
		Function: getBarcode
		This is the function that does the bulk of the work. Use this method
		to generate a java.awt.image.BufferedImage object. This object stores
		the actual image data. This method will also rotate and scale the 
		image if requested.
		
		The bardcode generater supports three image output formats:
			- jpeg
			- png
			- gif
		
		To rotate the barcode image pass in a non-zero value. Rotation is 
		done by degrees from 0 to 360. The underlying implementation requires
		radians but this method converts degrees to radians for you. A value
		of 0 (zero) will perform no rotation.
		
		To scale the barcode pass in values to scaleMultiplierX and scaleMultiplierY.
		Having two scale variables allows for independant scaling on both
		axises. The scale variables are multipliers so if you were to pass 2.0 to
		scaleMultiplierX, for example, this would scale the current width of the barcode
		image times two (2). A value of 0.0 will perform no scaling.
		
		Author:
			Adam Presley
			
		Parameters:
			label - The barcode label and data. The barcode itself is generated from this data
			type - The type of barcode. See the list above. Defaults to "code128"
			imageFormat - The image format: jpeg, png, gif. Defaults to "jpeg"
			requiresChecksum - Several formats have an argument for checksum. See the barbecue documentation for more information. Defaults to false
			rotateDegrees - Number of degrees to rotate the barcode. 0-360. Defaults to 0
			scaleMultiplierX - Multiplier to scale the X axis. Defaults to 0.0 
			scaleMultiplierY - Multiplier to scale the Y axis. Defaults to 0.0
			showText - True/false to show the label under the barcode. Defaults to true
			barWidth - The width of the bars in the barcode. Defaults to 0
			barHeight - The height of the bars in the barcode (doesn't seem to make a difference...). Defaults to 0
			resolution - The DPI resolution of the barcode image. Defaults to 72
			
		Returns:
			A java.awt.image.BufferedImage object. This object can be manipulated
			and drawn using the Java 2D APIs.
	--->
	<cffunction name="getBarcode"	returntype="any" access="public" output="false">
		<cfargument name="label" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="code128" />
		<cfargument name="imageFormat" type="string" required="false" default="jpeg" />
		<cfargument name="requiresChecksum" type="boolean" required="false" default="false" />
		<cfargument name="rotateDegrees" type="numeric" required="false" default="0" />
		<cfargument name="scaleMultiplierX" type="numeric" required="false" default="0.0" />
		<cfargument name="scaleMultiplierY" type="numeric" required="false" default="0.0" />
		<cfargument name="showText" type="boolean" required="false" default="true" />
		<cfargument name="barWidth" type="numeric" required="false" default="0" />
		<cfargument name="barHeight" type="numeric" required="false" default="0" />
		<cfargument name="resolution" type="numeric" required="false" default="72" />
		
		<cfset var barcode = "" />
		<cfset var graphics = structNew() />
		<cfset var calcs = structNew() />
		<cfset var mimeInfo = structNew() />
		
		<cfsetting showdebugoutput="false" />
		
		<!---
			If this method is invoked remotely our variables scoped
			stuff isn't prepared. Do that.
		--->
		<cfif NOT structKeyExists(variables, "barcodeFactory")>
			<cfset __prepareVariables() />
		</cfif>
		
		<!---
			Get the barcode object and mime/image format information
		--->
		<cfset barcode = __getBarcodeObject(arguments.label, arguments.type, arguments.requiresChecksum) />
		<cfset mimeInfo = __getMimeInfo(arguments.imageFormat) />

		<!---
			Set the barcode options.
		--->
		<cfset barcode.setDrawingText(javaCast("boolean", arguments.showText)) />
		<cfset barcode.setResolution(javaCast("int", arguments.resolution)) />
		
		<cfif arguments.barWidth GT 0>
			<cfset barcode.setBarWidth(javaCast("int", arguments.barWidth)) />
		</cfif>
		
		<cfif arguments.barHeight GT 0>
			<cfset barcode.setBarHeight(javaCast("int", arguments.barHeight)) />
		</cfif>

		<!---
			Get the image object from the barcode.
		--->
		<cfset graphics.image = variables.imageHandler.getImage(barcode) />
		
		
		<!---
			Has the user requested to rotate the image?
		--->
		<cfif arguments.rotateDegrees NEQ 0>
			<cfset graphics.image = __rotateImage(graphics.image, arguments.rotateDegrees) />
		</cfif>
	
	
		<!---
			Has the user requested to scale the image? Thanks to Real's tutorials:
			http://www.rgagnon.com/javadetails/java-0243.html
		--->
		<cfif arguments.scaleMultiplierX NEQ 0.0 OR arguments.scaleMultiplierY NEQ 0.0>
			<cfset graphics.image = __scaleImage(graphics.image, arguments.scaleMultiplierX, arguments.scaleMultiplierY) />
		</cfif>
		
		<cfreturn graphics.image />
	</cffunction>

	
	<!---
		Function: barcodeToBrowser
		Draws a barcode to the browser's output with a MIME type determined by
		the chosen image format. This is meant to be used by an <img> HTML tag 
		to display the barcode in the browser.
		
		> <img src="BarbecueService.cfc?method=barcodeToBrowser&label=123" />
		
		See <getBarcode> for more information about the available arguments.
		
		Author:
			Adam Presley
	--->
	<cffunction name="barcodeToBrowser" returntype="void" access="remote" output="true">
		<cfargument name="label" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="code128" />
		<cfargument name="imageFormat" type="string" required="false" default="jpeg" />
		<cfargument name="requiresChecksum" type="boolean" required="false" default="false" />
		<cfargument name="rotateDegrees" type="numeric" required="false" default="0" />
		<cfargument name="scaleMultiplierX" type="numeric" required="false" default="0.0" />
		<cfargument name="scaleMultiplierY" type="numeric" required="false" default="0.0" />
		<cfargument name="showText" type="boolean" required="false" default="true" />
		<cfargument name="barWidth" type="numeric" required="false" default="0" />
		<cfargument name="barHeight" type="numeric" required="false" default="0" />
		<cfargument name="resolution" type="numeric" required="false" default="72" />

		<cfset var image = getBarcode(argumentCollection = arguments) />
		<cfset var out = createObject("java", "java.io.ByteArrayOutputStream").init() />
		<cfset var mimeInfo = __getMimeInfo(arguments.imageFormat) />
		
		<!---
			Write the final image out to a byte array. This is what is 
			sent to the output for the browser.
		--->
		<cfset createObject("java", "javax.imageio.ImageIO").write(image, mimeInfo.imageFormat, out) />
		<cfset getPageContext().getOut().clearBuffer() /><cfcontent type="#mimeInfo.mimeType#" variable="#out.toByteArray()#" /><cfreturn />				
	</cffunction>


	<!---
		Function: __getBarcodeObject
		This private method returns an instance of a Barcode object from the
		barbecue library. This is used by <getBarcode> and <barcodeToBrowser>.
		
		Author:
			Adam Presley
			
		Parameters:
			label - The barcode label and data. The barcode itself is generated from this data
			type - The type of barcode. See the list above. Defaults to "code128"
			requiresChecksum - Several formats have an argument for checksum. See the barbecue documentation for more information. Defaults to false
			
		Returns:
			A net.sourceforge.barbecue.Barcode object
	--->
	<cffunction name="__getBarcodeObject" returntype="any" access="private" output="false">
		<cfargument name="label" type="string" required="true" />
		<cfargument name="type" type="string" required="false" default="code128" />
		<cfargument name="requiresChecksum" type="boolean" required="false" default="false" />
		
		<cfset var barcode = "" />
		<cfset var image = "" />
		
		<cfswitch expression="#lCase(arguments.type)#">
			<cfcase value="code128">
				<cfset barcode = variables.barcodeFactory.createCode128(arguments.label) />
			</cfcase>
			<cfcase value="2of7">
				<cfset barcode = variables.barcodeFactory.create2of7(arguments.label) />
			</cfcase>
			<cfcase value="3of9">
				<cfset barcode = variables.barcodeFactory.create3of9(arguments.label, arguments.requiresChecksum) />
			</cfcase>
			<cfcase value="bookland">
				<cfset barcode = variables.barcodeFactory.createBookland(arguments.label) />
			</cfcase>
			<cfcase value="codabar">
				<cfset barcode = variables.barcodeFactory.createCodabar(arguments.label) />
			</cfcase>
			<cfcase value="code128a">
				<cfset barcode = variables.barcodeFactory.createCode128A(arguments.label) />
			</cfcase>
			<cfcase value="code128b">
				<cfset barcode = variables.barcodeFactory.createCode128B(arguments.label) />
			</cfcase>
			<cfcase value="code128c">
				<cfset barcode = variables.barcodeFactory.createCode128C(arguments.label) />
			</cfcase>
			<cfcase value="code39">
				<cfset barcode = variables.barcodeFactory.createCode39(arguments.label, arguments.requiresChecksum) />
			</cfcase>
			<cfcase value="ean128">
				<cfset barcode = variables.barcodeFactory.createEAN128(arguments.label) />
			</cfcase>
			<cfcase value="ean13">
				<cfset barcode = variables.barcodeFactory.createEAN13(arguments.label) />
			</cfcase>
			<cfcase value="globaltradeitemnumber">
				<cfset barcode = variables.barcodeFactory.createGlobalTradeItemNumber(arguments.label) />
			</cfcase>
			<cfcase value="int2of5">
				<cfset barcode = variables.barcodeFactory.createInt2of5(arguments.label, arguments.requiresChecksum) />
			</cfcase>
			<cfcase value="monarch">
				<cfset barcode = variables.barcodeFactory.createMonarch(arguments.label) />
			</cfcase>
			<cfcase value="nw7">
				<cfset barcod90e = variables.barcodeFactory.createNW7(arguments.label) />
			</cfcase>
			<cfcase value="pdf417">
				<cfset barcode = variables.barcodeFactory.createPDF417(arguments.label) />
			</cfcase>
			<cfcase value="postnet">
				<cfset barcode = variables.barcodeFactory.createPostNet(arguments.label) />
			</cfcase>
			<cfcase value="randomweightupca">
				<cfset barcode = variables.barcodeFactory.createRandomWeightUPCA(arguments.label) />
			</cfcase>
			<cfcase value="scc14shippingcode">
				<cfset barcode = variables.barcodeFactory.createSCC14ShippingCode(arguments.label) />
			</cfcase>
			<cfcase value="shipmentidentificationnumber">
				<cfset barcode = variables.barcodeFactory.createShipmentIdentificationNumber(arguments.label) />
			</cfcase>
			<cfcase value="sscc18">
				<cfset barcode = variables.barcodeFactory.createSSCC18(arguments.label) />
			</cfcase>
			<cfcase value="std2of5">
				<cfset barcode = variables.barcodeFactory.createStd2of5(arguments.label, arguments.requiresChecksum) />
			</cfcase>
			<cfcase value="upca">
				<cfset barcode = variables.barcodeFactory.createUPCA(arguments.label) />
			</cfcase>
			<cfcase value="usd3">
				<cfset barcode = variables.barcodeFactory.createUSD3(arguments.label, arguments.requiresChecksum) />
			</cfcase>
			<cfcase value="usd4">
				<cfset barcode = variables.barcodeFactory.createUSD4(arguments.label) />
			</cfcase>
			<cfcase value="usps">
				<cfset barcode = variables.barcodeFactory.createUSPS(arguments.label) />
			</cfcase>
		</cfswitch>
		
		<cfreturn barcode />
	</cffunction>


	<!---
		Function: __getMimeInfo
		This private method is used by the <getBarcode> and <barcodeToBrowser> method
		to get the correct MIME type and image format based on the input 
		image format requested.
		
		Author:
			Adam Presley
			
		Parameters:
			imageFormat - The image format: jpeg, png, gif. Defaults to "jpeg"
			
		Returns:
			A structure with the following keys:
				- mimeType - An image mime type
				- imageFormat - A normalized image format description. Used by the imageIO writer
	--->
	<cffunction name="__getMimeInfo" returntype="struct" access="private" output="false">
		<cfargument name="imageFormat" type="string" required="false" default="jpeg" />

		<cfset var result = structNew() />
	
		<cfswitch expression="#arguments.imageFormat#">
			<cfcase value="jpeg">
				<cfset result.mimeType = "image/jpeg" />
				<cfset result.imageFormat = "jpeg" />
			</cfcase>
			<cfcase value="jpg">
				<cfset result.mimeType = "image/jpeg" />
				<cfset result.imageFormat = "jpeg" />
			</cfcase>	
			<cfcase value="gif">
				<cfset result.mimeType = "image/gif" />
				<cfset result.imageFormat = "gif" />
			</cfcase>
			<cfcase value="png">
				<cfset result.mimeType = "image/png" />
				<cfset result.imageFormat = "png" />
			</cfcase>
		</cfswitch>
		
		<cfreturn result />
	</cffunction>


	<!---
		Function: __prepareVaraibles
		A private method for instantiating the necessary BarcodeFactory
		and BarcodeImageHandler objects that are used by this component. This
		is called by the constructor and potentially <getBarcode> if that
		method is called remotely.
		
		Author:
			Adam Presley
	--->
	<cffunction name="__prepareVariables" returntype="void" access="private" output="false">
		<cfset variables.barcodeFactory = createObject("java", "net.sourceforge.barbecue.BarcodeFactory") />
		<cfset variables.imageHandler = createObject("java", "net.sourceforge.barbecue.BarcodeImageHandler") />
	</cffunction>


	<!---
		Function: __rotateImage
		Rotates an image by a number of degrees specified. This is based off of
		the algorithm found at http://flyingdogz.wordpress.com/2008/02/09/image-rotate-in-java/.
		This is a private method.
		
		Author:
			Adam Presley
			
		Parameters:
			image - A java.awt.image.BufferedImage object containing a barcode image
			rotateDegrees - Number of degrees to rotate the barcode. 0-360. 
			
		Returns:
			A rotated java.awt.image.BufferedImage object
	--->
	<cffunction name="__rotateImage" returntype="any" access="private" output="false">
		<cfargument name="image" type="any" required="true" />
		<cfargument name="rotateDegrees" type="numeric" required="true" />
		
		<cfset var calcs = structNew() />
		<cfset var graphics = structNew() />
		
		<!---
			Calculate the following:
				- Convert degrees to radians
				- Get the sin and cos of the angle of rotation
				- Calculate the new width and height of the rotated image.
				  Thanks to flyingdogz @ http://flyingdogz.wordpress.com/2008/02/09/image-rotate-in-java/
		--->
		<cfset calcs.radians = arguments.rotateDegrees * 3.14159 / 180.0 />
		<cfset calcs.sin = abs(sin(calcs.radians)) />
		<cfset calcs.cos = abs(cos(calcs.radians)) />
	
		<cfset calcs.oldWidth = arguments.image.getWidth() />
		<cfset calcs.oldHeight = arguments.image.getHeight() />
		<cfset calcs.newWidth = int(calcs.oldWidth * calcs.cos + calcs.oldHeight * calcs.sin) />
		<cfset calcs.newHeight = int(calcs.oldHeight * calcs.cos + calcs.oldWidth * calcs.sin) />
	
		<!---
			Create a new image object to draw to. Once we get a new image buffer
			fill it with a white background, move the center of rotation,
			then rotate the "canvas". Once we've translated and rotated draw the
			barcode image onto the canvas.
		
			Thanks to Mark Graybill for the tutorial: http://beginwithjava.blogspot.com/2009/02/rotating-image-with-java.html
		--->
		<cfset graphics.rotatedImage = createObject("java", "java.awt.image.BufferedImage").init(
			calcs.newWidth,
			calcs.newHeight,
			1
		) />
	
		<cfset graphics.g = graphics.rotatedImage.getGraphics() />

		<cfset graphics.g.setColor(createObject("java", "java.awt.Color").init(javaCast("int", 255), javaCast("int", 255), javaCast("int", 255))) />
		<cfset graphics.g.fillRect(0, 0, graphics.rotatedImage.getWidth(), graphics.rotatedImage.getHeight()) />
	
		<cfset graphics.g.translate(javaCast("int", (calcs.newWidth - calcs.oldWidth) / 2), javaCast("int", (calcs.newHeight - calcs.oldHeight) / 2)) />
		<cfset graphics.g.rotate(calcs.radians, calcs.oldWidth / 2, calcs.oldHeight / 2) />
	
		<cfset graphics.g.drawImage(
			arguments.image, 
			javaCast("int", 0), 
			javaCast("int", 0), 
			javaCast("null", "")
		) />

		<cfreturn graphics.rotatedImage />
	</cffunction>
	

	<!---
		Function: __scaleImage
		Scales an image on the X and Y axises indepenently. The scale variables
		passed in are multipliers, so these values are multiplied by the
		image's existing width and height. Scaling is applied AFTER rotation.
		This is a private method.
		
		Author:
			Adam Presley
			
		Parameters:
			image - A java.awt.image.BufferedImage object containing a barcode image
			scaleMultiplierX - Multiplier to scale the X axis. Defaults to 0.0 
			scaleMultiplierY - Multiplier to scale the Y axis. Defaults to 0.0
			
		Returns:
			A scaled java.awt.image.BufferedImage object
	--->
	<cffunction name="__scaleImage" returntype="any" access="private" output="false">
		<cfargument name="image" type="any" required="true" />
		<cfargument name="scaleMultiplierX" type="numeric" required="false" default="0.0" />
		<cfargument name="scaleMultiplierY" type="numeric" required="false" default="0.0" />
		
		<cfset var calcs = structNew() />
		<cfset var graphics = structNew() />
		
		<cfset calcs.oldWidth = arguments.image.getWidth() />
		<cfset calcs.oldHeight = arguments.image.getHeight() />

		<cfif arguments.scaleMultiplierX NEQ 0.0>
			<cfset calcs.newWidth = calcs.oldWidth * arguments.scaleMultiplierX />
		<cfelse>
			<cfset calcs.newWidth = calcs.oldWidth />
		</cfif>
		
		<cfif arguments.scaleMultiplierY NEQ 0.0>
			<cfset calcs.newHeight = calcs.oldHeight * arguments.scaleMultiplierY />
		<cfelse>
			<cfset calcs.newHeight = calcs.oldHeight />
		</cfif>
		
		<cfset graphics.scaledImage = createObject("java", "java.awt.image.BufferedImage").init(
			calcs.newWidth,
			calcs.newHeight,
			1
		) />
		
		<cfset graphics.g = graphics.scaledImage.getGraphics() />
		<cfset graphics.scaler = createObject("java", "java.awt.geom.AffineTransform").getScaleInstance(
			javaCast("double", calcs.newWidth / calcs.oldWidth),
			javaCast("double", calcs.newHeight / calcs.oldHeight)
		) />
		
		<cfset graphics.g.drawRenderedImage(arguments.image, graphics.scaler) />
		<cfreturn graphics.scaledImage />
	</cffunction>
	
</cfcomponent>

