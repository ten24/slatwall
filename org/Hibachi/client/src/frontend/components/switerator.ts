/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWIterator<T> {

        private count: number = 0;

        constructor(private lists: Array<T> = null) {}

        hasNext(): boolean {
            if(this.count < this.lists.length) {
                return true;
            }
            return false;
        }

        next(): T {
            var result: T;
            if(this.hasNext()) {
                result = this.lists[this.count];
                this.count += 1;
                return result;
            }
            return null;
        }

        remove(): T {
            if (this.count > this.lists.length){
                throw("Illegal state exception");
            }
            return this.lists.pop();
        }

    }
export {
  SWIterator
};