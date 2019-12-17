/**
 * @description
 * @export
 * @class RetryProxy
 */
class RetryProxy {

    private args: any[];
    private wait = () => new Promise((resolve) => setTimeout(resolve, this.delay));
    private attempt = () => new Promise((resolve) => resolve(this.context[this.func](...this.args)));

    /**
     *Creates an instance of RetryProxy.
     * @param {*} [context=console] any context against you want to call the function;
     * @param {string} [func='log'] name of the function
     * @param {number} [delay=200] delay in 'ms' b/w conjugative tries
     * @param {number} [cnt=500] max retry count
     * @param {boolean} [silent=true] whether it will throw an error after the last attempt 
     */
    constructor(
        private context: any = console,
        private func = 'log',
        private delay = 200,
        private cnt = 500,
        private silent = true
    ) {
        this.args = []
    }

    /**
     * @description
     * @param {*} args
     * @returns 
     * @memberof RetryProxy
     */
    public setArgs(...args) {
        this.args = args;
        return this;
    }

    /**
     * @description
     * @returns 
     * @memberof RetryProxy
     */
    public run() {
        return new Promise((resolve, reject) => {
            return this.attempt()
                .then(resolve)
                .catch((e) => {
                    if (--this.cnt > 0) {
                        console.log(`Called ${this.context}.${this.func}(), ${this.cnt}th time.\nGot Error --> ${e.message},\nRetrying in: --> ${this.delay}`);
                        return this.wait().then(this.run.bind(this, null)).then(resolve).catch(reject)
                    }
                    return this.silent ? resolve(e) : reject(e);
                })
        })
    }
}