<cfcomponent displayname="MxunitInstallVerificationTest" extends="mxunit.framework.TestCase">
			<cffunction name="testThis" >
				<cfset assertEquals("this","this") />
			</cffunction>

			<cffunction name="testThat" >
				<cfset assertEquals("this","that", "This is an intentional failure so you see what it looks like") />
			</cffunction>

			<cffunction name="testSomething" >
			   <cfset a = arrayNew(1)>
			   <cfset a[1] = "some debug traces" />
			    <cfset debug(a) />
				<cfset assertEquals(1,1) />
			</cffunction>

			<cffunction name="testSomethingElse">
				<cfset assertTrue(true) />
			</cffunction>

			<cffunction name="testIntentionalError">
				<cfset foo = bar />
			</cffunction>

		</cfcomponent>
