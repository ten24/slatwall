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
<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.product#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.product#" edit="#rc.edit#">
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="updateSkus" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.processproduct" processContext="updateDefaultImageFileNames" type="list" confirm="true" confirmtext="#$.slatwall.rbKey('entity.Product.process.updateDefaultImageFileNames_confirm')#" />
			<li class="divider"></li>
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSku" type="list" modal="true" />
			<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" type="list" modal="true" />
			<cf_HibachiActionCaller action="admin:entity.createImage" querystring="productID=#rc.product.getProductID()#&objectName=product&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<cf_HibachiActionCaller action="admin:entity.createfile" querystring="baseObject=#rc.product.getClassName()#&baseID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
			<cf_HibachiActionCaller action="admin:entity.createcomment" querystring="productID=#rc.product.getProductID()#&redirectAction=#request.context.slatAction#" modal="true" type="list" />
		</cf_HibachiEntityActionBar>
		<div class="row s-pannel-control" style="margin-top:10px;padding-bottom:2px;padding-right:2px;">
		  <div class="col-md-12" style="text-align:right;"><a href="##" class="openall" style="border-right:1px solid ##999;padding-right:4px;">Open All</a> <a href="##" class="closeall">Close All</a></div>
		</div>
		
		<script charset="utf-8">
		$('.closeall').click(function(){
		  $('.panel-collapse.in')
		    .collapse('hide');
		});
		$('.openall').click(function(){
		  $('.panel-collapse:not(".in")')
		    .collapse('show');
		});
		</script>
		<style media="screen">
		  .s-pannel-control a {color:##888;font-size:11px;}
		  .s-pannel-control a:hover {text-decoration:none;}
		  .panel-heading h4.panel-title {font-size:14px !important;}
		</style>
		
		<div class="panel-group s-pannel-group" id="accordion">
	      <div class="panel panel-default">
	        <a data-toggle="collapse"  href="##collapseOne">
	          <div class="panel-heading">
	            <h4 class="panel-title">
	                <span>Basic</span>
	                <i class="fa fa-caret-left" style="float:right;margin-top: 3px;"></i>
	            </h4>
	          </div>
	        </a>
	        <div id="collapseOne" class="panel-collapse collapse in">
	        	<div class="panel-body">
					
					
					<cf_HibachiPropertyRow>
						<cf_HibachiPropertyList divClass="col-md-6">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
						</cf_HibachiPropertyList>
						<cf_HibachiPropertyList divClass="col-md-6">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
							<cf_HibachiPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
							<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
							<cf_HibachiFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
						</cf_HibachiPropertyList>
					</cf_HibachiPropertyRow>
					
					
					
				</div>
			</div>
		  </div>
		</div>
		
		
	  <div class="panel panel-default">
        <a data-toggle="collapse"  href="##collapseTwo">
          <div class="panel-heading">
            <h4 class="panel-title">
                <span>Skus <span style="background-color: ##858585;border-radius: 20%;padding: 3px;font-size: 10px;width: 18px;display: inline-block;height: 15px;position: relative;margin-left: 7px;color: ##CCC;text-align:center;">35</span></span>
                <i class="fa fa-caret-left" style="float:right;margin-top: 3px;"></i>
            </h4>
          </div>
        </a>
        <div id="collapseTwo" class="panel-collapse collapse">
          <div class="panel-body">
          	<!--- Skus --->
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList divClass="col-md-12"> 
					<cf_HibachiPropertyDisplay object="#rc.product#" property="skus" edit="#rc.edit#" />
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
          </div>
        </div>
      </div>
		
		<cf_HibachiTabGroup object="#rc.product#">
			<!--- Skus --->
			<cf_HibachiTab property="skus" />
			
			<!--- Images --->
			<cf_HibachiTab view="admin:entity/producttabs/images" />
			
			<!--- Files --->
			<cf_SlatwallAdminTabFiles object="#rc.product#" />
			
			<!--- Description --->
			<cf_HibachiTab property="productDescription" />
			
			<!--- Relating --->
			<cf_HibachiTab property="listingPages" />
			<cf_HibachiTab property="categories" />
			<cf_HibachiTab property="relatedProducts" />
			
			<!--- Reference --->
			<cf_HibachiTab property="productReviews" />
			<cf_HibachiTab property="vendors" />
			
			<!--- Settings --->
			<cf_HibachiTab view="admin:entity/producttabs/productsettings" />
			<cf_HibachiTab view="admin:entity/producttabs/skusettings" />
			
			<!--- Custom Attributes --->
			<cfloop array="#rc.product.getAssignedAttributeSetSmartList().getRecords()#" index="attributeSet">
				<cf_SlatwallAdminTabCustomAttributes object="#rc.product#" attributeSet="#attributeSet#" />
			</cfloop>
			
			<!--- Comments --->
			<cf_SlatwallAdminTabComments object="#rc.product#" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>

</cfoutput>
