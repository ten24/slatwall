export module Observable {
    export interface IObservable {
        observers:Observable.IObserver[];
        registerObserver(observer: Observable.IObserver);
        removeObserver(observer: Observable.IObserver);
        notifyObservers(message: any);
    }
    export interface IObserver {
        recieveNotification<T>(message:T):void;
    }
    export interface IMessage {
        type: string;
        body: any;
    }
}
