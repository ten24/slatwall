<cfoutput>
    <footer class="bg-light py-3">
        <div class="container text-center text-muted">
            &copy; #$.slatwall.getCurrentRequestSite().getSiteName()# #DateFormat( now(), "yyyy" )#
        </div>
    </footer>
    <script src="//cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>

    <!--- Bootstrap core JavaScript --->
    <script src="//stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/src/vendor.bundle.js" charset="utf-8"></script>
    <script src="#request.slatwallScope.getBaseURL()#/org/Hibachi/client/src/slatwall.js?instantiationKey=#$.slatwall.getApplicationValue('instantiationKey')#" charset="utf-8"></script>
</body>
</html>
</cfoutput>