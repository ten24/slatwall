describe("myFunction", function() {
    var myfunc = NS.myFunction;

    beforeEach(function(){
    	spyOn(myfunc, 'init').and.callThrough();
    });

    afterEach(function() {
        myfunc.reset();
    });

    it("Should be able to initialize", function() {
        expect(myfunc.init).toBeDefined();
        myfunc.init();
        expect(myfunc.init).toHaveBeenCalled();
    });

    it("Should populate stuff during initialization", function(){
        myfunc.init();
        expect(myfunc.stuff.length).toEqual(1);
        expect(myfunc.stuff[0]).toEqual('Testing');
    });
    describe("Appending strings", function() {
        it("Should be able to append 2 strings", function() {
            expect(myfunc.append).toBeDefined();
        });
        it("Should append 2 strings", function() {
            expect(myfunc.append('Hello ','Slatwall')).toEqual('Hello Slatwall');
        });
    });
});