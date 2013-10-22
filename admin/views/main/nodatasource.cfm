<html>
	<head>
		<title>Slatwall Datasource</title>
	</head>
	<body>
		<p>
			Slatwall is almost ready for use, but you are missing a datasource.  You have Two Options<br />
			<br />
			<br />
			Option 1) Create a Datasource in your CFIDE or Railo Administrator called: Slatwall<br />
			<br />
			Option 2) Add/Edit File: <pre>/custom/config/configApplication.cfm</pre> and add a line of code to define a custom datasource such as: <pre>&lt;cfset this.datasource.name = "MyDatasourceName" /&gt;</pre>
		</p>
	</body>
</html>
		