<!---
	File: barcode.cfm
	This is a custom tag to make generating barcodes in your web page
	easier. This tag will generate an <img> tag for you. For example:
	
	> <cfimport prefix="barbecue" taglib="com/adampresley/barbecue" />
	> 
	> <barbecue:barcode root="/com/adampresley/barbecue" type="usps">
	>    123
	> </barbecue:barcode>

	The following attributes are supported:
		root - The root path to find the BarbecueService.cfc component
		type - The type of barcode. See the list in <BarbecueService.cfc>
		imageFormat - The image format: jpeg, png, gif. Defaults to "jpeg"
		requiresChecksum - Several formats have an argument for checksum. See the barbecue documentation for more information. Defaults to false
		rotateDegrees - Number of degrees to rotate the barcode. 0-360. Defaults to 0
		scaleMultiplierX - Multiplier to scale the X axis. Defaults to 0.0 
		scaleMultiplierY - Multiplier to scale the Y axis. Defaults to 0.0
		showText - True/false to show the label under the barcode. Defaults to true
		barWidth - The width of the bars in the barcode. Defaults to 0
		barHeight - The height of the bars in the barcode (doesn't seem to make a difference...). Defaults to 0
		resolution - The DPI resolution of the barcode image. Defaults to 72
		name - The name of the generated <img> tag
		id - The ID of the generated <img> tag
		alt - The ALT text of the generated <img> tag
		class - The CSS class to apply to the generated <img> tag
		
	Author:
		Adam Presley

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


<!---
	Validate that we have an end-tag provided. The content between start
	and end is the label for the barcode.
--->
<cfif NOT thisTag.hasEndTag>
	<cfthrow 
		type="com.adampresley.barbecue.error" 
		message="No end-tag defined" 
		detail="The Barbecue tag library requires an end tag to be provided." 
	/>
</cfif>

<cfif thisTag.executionMode EQ "start">
	<cfif NOT structKeyExists(attributes, "root")>
		<cfset attributes.root = "/com/adampresley/barbecue" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "type")>
		<cfset attributes.type = "code128" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "imageFormat")>
		<cfset attributes.imageFormat = "jpeg" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "requiresChecksum")>
		<cfset attributes.requiresChecksum = "false" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "rotateDegrees")>
		<cfset attributes.rotateDegrees = 0 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "scaleMultiplierX")>
		<cfset attributes.scaleMultiplierX = 0.0 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "scaleMultiplierY")>
		<cfset attributes.scaleMultiplierY = 0.0 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "showText")>
		<cfset attributes.showText = "true" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "barWidth")>
		<cfset attributes.barWidth = 0 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "barHeight")>
		<cfset attributes.barHeight = 0 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "resolution")>
		<cfset attributes.resolution = 72 />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "name")>
		<cfset attributes.name = "code128barcode" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "id")>
		<cfset attributes.id = "code128barcode" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "alt")>
		<cfset attributes.alt = "code128 barcode image" />
	</cfif>
	
	<cfif NOT structKeyExists(attributes, "class")>
		<cfset attributes.class = "" />
	</cfif>
	

<cfelse>
	<cfoutput>
	<img 
		src="#attributes.root#/BarbecueService.cfc?method=barcodeToBrowser&label=#trim(thisTag.generatedContent)#&type=#attributes.type#&imageFormat=#attributes.imageFormat#&requiresChecksum=#attributes.requiresChecksum#&rotateDegrees=#attributes.rotateDegrees#&scaleMultiplierX=#attributes.scaleMultiplierX#&scaleMultiplierY=#attributes.scaleMultiplierY#&showText=#attributes.showText#&barWidth=#attributes.barWidth#&barHeight=#attributes.barHeight#&resolution=#attributes.resolution#"
		alt="#attributes.alt#"
		name="#attributes.name#"
		id="#attributes.name#"
		class="#attributes.class#" />
	</cfoutput>
	
	<cfset thisTag.generatedContent = "" />
</cfif>
