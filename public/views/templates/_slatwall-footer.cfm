<cfoutput>
		<div class="row">
			<div class="span12">
			<p class="footer pull-left">&copy; #dateformat(now(), "YYYY")# SlatWall. All Rights Reserved. </p>
			<p class="footer pull-right"><a href="?slatAction=public:main.account">My Account</a> | <a href="?slatAction=public:main.suppliers">Suppliers</a> <cfif $.slatwall.getLoggedInFlag()>| <a href="?slatAction=public:account.logout">logout</a></cfif></p>
			</div>
		</div>
</cfoutput>

	</div>
		
	</body>
</html>
