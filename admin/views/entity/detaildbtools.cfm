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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfoutput>
	<div class="svoadminsettingdetaildbtools">
		<ul id="navTask">
			
		</ul>
		<h2>Delete All Orders</h2>
		<form method="post">
			<input type="hidden" name="slatAction" value="admin:entity.deleteallorders" />
			<p>This will delete Orders, Carts and all other related data like Payments & Deliveries<br />Only Click this button if you are 100% sure that you want to remove all orders.</p>
			<br />
			<br />
			<input type="hidden" name="confirmDelete" value="" />
			Confirm Delete: <input type="checkbox" name="confirmDelete" value="1" />
			<hb:HibachiActionCaller action="admin:entity.deleteallorders" type="submit" class="button" confirmRequired="true">
		</form>
		<hr />
		<h2>Delete All Products (and Orders)</h2>
		<form method="post">
			<input type="hidden" name="slatAction" value="admin:entity.deleteallproducts" />
			<p>Only Click this button if you are 100% sure that you want to remove all products. <br />This will delete, Orders, Carts, Products, Stock, Skus, Attribute Values, ect.</p>
			<ul>
				<li>Delete Brands: <input type="checkbox" name="deleteBrands" value="1" /></li>
				<li>Delete Product Types: <input type="checkbox" name="deleteProductTypes" value="1" /></li>
				<li>Delete Product Options: <input type="checkbox" name="deleteOptions" value="1" /></li>
			</ul>
			<br />
			<br />
			<input type="hidden" name="confirmDelete" value="" />
			Confirm Delete: <input type="checkbox" name="confirmDelete" value="1" />
			<hb:HibachiActionCaller action="admin:entity.deleteallproducts" type="submit" class="button" confirmRequired="true">
		</form>
		<hr />
		<h2>Import Data From Bundle</h2>
		<form method="post">
			<input type="hidden" name="slatAction" value="admin:entity.importbundledata" />
			<p>Clicking this option will delete all Slatwall Data, and re-import it from a bundle.</p>
			<br />
			<input type="hidden" name="confirmImport" value="" />
			Confirm Import: <input type="checkbox" name="confirmImport" value="1" />
			<hb:HibachiActionCaller action="admin:entity.importbundledata" type="submit" class="button" confirmRequired="true">
		</form>
		<hr />
	</div>
</cfoutput>
