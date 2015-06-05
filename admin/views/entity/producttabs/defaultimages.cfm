<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.product" type="any" />

<cfoutput>
	
	<div class="row s-image-uploader">
		
			<cfloop array="#rc.product.getDefaultProductImageFiles()#" index="imageFile">
				<cfset thisImagePath = "#$.slatwall.getBaseImageURL()#/product/default/#imageFile#" />
			
				<cfif fileExists(expandPath(thisImagePath))>
					<div class="col-xs-3">
						<div class="thumbnail">
							<div class="s-image">
								<a href="#$.slatwall.getResizedImagePath(imagePath=thisImagePath)#" target="_blank" alt="#imageFile#">
									#$.slatwall.getResizedImage(imagePath=thisImagePath, width=210, height=210)#
									<span class="s-zoom"><i class="fa fa-search"></i></span>
								</a>
							</div>
							<div class="s-caption">
								<h4 title="#imageFile#">#imageFile#</h4>
							</div>
							<div class="s-controlls">
								<div class="btn-group btn-group-justified" role="group">
									<div class="btn-group" role="group">
										<hb:HibachiProcessCaller entity="#rc.product#" processContext="uploadDefaultImage" action="admin:entity.preprocessproduct" queryString="imageFile=#imageFile#" class="btn btn-default" iconOnly="true" icon="pencil" modal="true" />
									</div>
									<div class="btn-group" role="group">
										<hb:HibachiProcessCaller entity="#rc.product#" processContext="deleteDefaultImage" action="admin:entity.processproduct" queryString="imageFile=#imageFile#" class="btn btn-default" iconOnly="true" icon="trash" />
									</div>
								</div>
							</div>
						</div>
					</div>
				<cfelse>
					<div class="alert alert-info deafult-margin" role="alert" sw-rbkey="'entity.Product.process.image.norecordsfound'"><!-- Message created by rb key --></div>
					<div class="col-xs-3">
						<hb:HibachiProcessCaller entity="#rc.product#" processContext="uploadDefaultImage" action="admin:entity.preprocessproduct" queryString="imageFile=#imageFile#" class="btn btn-primary" icon="plus" iconOnly="false"  modal="true" />
					</div>
				</cfif>
			</cfloop>
		
		
	</div>
	
	
</cfoutput>
