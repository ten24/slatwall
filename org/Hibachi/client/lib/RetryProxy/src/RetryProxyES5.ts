/**
 * @description
 * @export
 * @class RetryProxyES5
 */
class RetryProxyES5 {

    private args: any[];
    private attempted = 0;
    private resolve = (whatever: any): any => whatever;
    private reject = (whatever: any): any => { return whatever };

    /**
     *Creates an instance of RetryProxyES5.
     * @param {*} [context=console]
     * @param {string} [func='log']
     * @param {number} [delay=100]
     * @param {number} [maxAttempt=500]
     * @memberof RetryProxyES5
     */
    constructor(
        private context: any = console,
        private func = 'log',
        private delay = 100,
        private maxAttempt = 500,
        private debugMode = false
    ) {
        this.args = []
        this.resolve = () => { };
    }

    /**
     * @description
     * @param {any[]} args
     * @returns 
     * @memberof RetryProxyES5
     */
    public setArgs(args: any[]) {
        this.args = args;
        return this;
    }

    /**
     * @description
     * @param {() => any} resolve
     * @param {() => any} reject
     * @returns 
     * @memberof RetryProxyES5
     */
    public then(resolve: () => any, reject: () => any) {
        this.resolve = resolve;
        this.reject = reject;
        this.run();
        return this;
    }

    public run() {

        this.attempted++;

        try {
            return this.resolve(this.context[this.func].apply(this.context, this.args));
        }
        catch (e) {
            if (this.attempted <= this.maxAttempt) {
                
                if (this.debugMode) {
                    console.warn('retrying ->', this.func, ", attempt ->", this.attempted, "error ", e);
                }
                
                setTimeout(() => this.run(), this.delay);
            }
            else {
                return this.reject("Max attempt reached");
            }
        }
    }
}