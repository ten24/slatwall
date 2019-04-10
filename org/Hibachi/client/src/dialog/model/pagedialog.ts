
//model
class PageDialog {
    public partialFileName: string;
    public path: string;
    //@ngInject
    constructor(
        path: string
    ) {
        this.path = this.partialFileName;
    }
}
export {
    PageDialog
};
