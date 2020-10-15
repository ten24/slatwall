<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>

<div class="page-title-overlap bg-lightgray pt-4 pb-5">
	<div class="container d-lg-flex justify-content-between py-2 py-lg-3">
		<div class="order-lg-1 pr-lg-4 text-center text-lg-left">
			<h1 class="h3 mb-0">${title}</h1>
		</div>
	</div>
</div>

<!-- Page Content-->
<div class="container pb-5 mb-2 mb-md-3">
	<div class="row">

		<!-- Content  -->
		<section class="col-lg-8">
			<!-- Summary Content-->
			<div class="mt-5 pt-5">
				${customSummary}
				
				<!--- UK Storage Signup Form --->
                <cfif isDefined("url.submitted")>
					<div class="alert alert-success" role="alert">
						Thank you for contacting us, we will get back to you as soon as possible.
					</div>
				</cfif>
				<div class="contactForm mt-4 <cfif IsDefined("url.submitted")>hide</cfif>">
					#dspForm('contact-us','?submitted=true')#
				</div>
			</div>
		</section>

		<!-- Sidebar-->
		<aside class="col-lg-4 pt-4 pt-lg-0">
			<div class="cz-sidebar-static rounded-lg box-shadow-lg p-4 mb-5">
				${customBody}
				<!--- google maps embed code --->
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2953.180159000361!2d-71.84762278454714!3d42.25332507919407!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89e4041d31deb0af%3A0xeb395499aba6c944!2sStone%20%26%20Berg%20Wholesale!5e0!3m2!1sen!2sus!4v1602162888268!5m2!1sen!2sus" width="400" height="250" frameborder="0" style="border:0;" allowfullscreen="" aria-hidden="false" tabindex="0"></iframe>
			</div>
		</aside>

	</div>
</div>

<div class="bg-primary p-5">
	<div class="container">
		<div class="row">
			<div class="col-0 col-md-2"></div>
			<div class="col-md-8 text-center">
				#$.renderContent($.getContentByUrlTitlePath('footer/contact-application').getContentID(), 'customBody')#
			</div>
			<div class="col-0 col-md-2"></div>
		</div>
	</div>     
</div>

</cfoutput>
<cfinclude template="inc/footer.cfm" />
