import {Subject,Observable} from 'rxjs';

export type Action<T> = {
    type:string|number|T
    payload:any
};

//export type reducer = Function:<S, A>(state:S, action:A):Object
export interface Reducer {
    (state: Object, action:Action<string>): Object;
}

export class IStore {
    public store$:Observable<any>;
    public actionStream$:Subject<Action<string>>; //a stream of actions.
    public dispatch:Function = (action:Action<string>):any => this.actionStream$.next((action));
    public getInstance:Function = ():Observable<any> => {
        return this.store$;
    }
    //@ngInject
    constructor ( private initialState:any, private reducer:any,  private middleware?:Observable<any> ) {

        this.actionStream$ = new Subject<Action<string>>();

        this.store$ = this.actionStream$.startWith(initialState).scan(reducer);
        if (middleware){
            this.store$;
        }
        return this;
    }
}