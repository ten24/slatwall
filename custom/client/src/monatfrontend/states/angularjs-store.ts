/**
 * CPOOIED FROM    "@ranndev/angularjs-store": "^4.0.5",
 *
 * because the lib had differen't versions of peer-dependencies
 * and that was cusing the TSC to throw-up in the console;
 *
 * It's a very light-weight state-management library for AngularJS
 *
 * For Doc, Tutorials visit https://angularjs-store.gitbook.io/docs/tutorials/
 *
 */

export type HookActionQuery<Actions extends string[] = string[]> =
	| '*'
	| Actions[number]
	| Array<Actions[number] | '*'>
	| RegExp;

export class NgStore<State extends { [key: string]: any } = {}, Actions extends string[] = string[]> {
	private $$stateHolder: StateHolder<State>;

	/**
	 * All registered hooks from the store.
	 */
	private $$hooks: Array<Hook<State>> = [];

	/**
	 * Create a Store.
	 * @param initialState Initial state value.
	 */
	constructor(initialState: State) {
		this.$$stateHolder = holdState(initialState);
	}

	/**
	 * Get a new copy of state.
	 */
	public copy(): State {
		return this.$$stateHolder.get();
	}

	/**
	 * Attach a hook to the store and get notified everytime the given query matched to dispatched action.
	 * @param query A query for the dispatched action.
	 * @param callback Invoke when query match to dispatched action.
	 */
	public hook(query: HookActionQuery<Actions>, callback: HookCallback<State>) {
		let matcher: HookMatcher;

		if (typeof query === 'string') {
			matcher = query === '*' ? () => true : (action) => action === query;
		} else if (Array.isArray(query)) {
			// @ts-ignore
			matcher = (action) => query.includes(action);
		} else if (query instanceof RegExp) {
			matcher = (action) => query.test(action);
		} else {
			/* istanbul ignore next */
			throw new TypeError('Invalid hook query.');
		}

		if (!angular.isFunction(callback)) {
			/* istanbul ignore next */
			throw new TypeError('Invalid hook callback.');
		}

		const hook = new Hook<State>(matcher, callback);

		this.$$hooks.push(hook);

		// Initial run of hook.
		hook.run('', this.$$stateHolder.get(), true);

		return new HookLink(() => {
			this.$$hooks.splice(this.$$hooks.indexOf(hook), 1);
		});
	}

	/**
	 * Dispatch an action for updating state.
	 * @param action Action name.
	 * @param state New state of store.
	 */
	public dispatch(action: Actions[number], state: Partial<State>): void;

	/**
	 * Dispatch an action for updating state.
	 * @param action Action name.
	 * @param setState State setter.
	 */
	public dispatch(action: Actions[number], setState: (prevState: State) => Partial<State>): void;

	/**
	 * Implementation.
	 */
	public dispatch(action: Actions[number], state: Partial<State> | ((prevState: State) => Partial<State>)) {
		// @ts-ignore
		const partialState = angular.isFunction(state) ? state(this.$$stateHolder.get()) : state;

		this.$$stateHolder.set(partialState);

		for (const hook of this.$$hooks) {
			hook.run(action, this.$$stateHolder.get());
		}
	}
}

/************************. StateHolder **************************/

export interface StateHolder<State> {
	/**
	 * Get a new copy of state.
	 */
	get(): State;

	/**
	 * Update the current state.
	 * @param partialState New partial state.
	 */
	set(partialState: Partial<State>): void;
}

export function holdState<State>(state: State): StateHolder<State> {
	const $$state = angular.copy(state);

	const get = () => {
		return angular.copy($$state);
	};

	const set = (partialState: Partial<State>) => {
		for (const key in partialState) {
			if (partialState.hasOwnProperty(key) && key in $$state) {
				$$state[key] = angular.copy(partialState[key])!;
			}
		}
	};

	return { get, set };
}

/************************. Hook **************************/

export type HookMatcher = (action: string) => boolean;

export type HookCallback<State> = (state: Readonly<State>, initialRun: boolean) => void;

export class Hook<State> {
	private $$match: HookMatcher;
	private $$callback: HookCallback<State>;
	private $$called = false;

	/**
	 * Create a Hook.
	 * @param matcher Function that test the dispatched action.
	 * @param callback Callback function that trigger when action passed to matcher.
	 */
	constructor(matcher: HookMatcher, callback: HookCallback<State>) {
		this.$$match = matcher;
		this.$$callback = callback;
	}

	/**
	 * Run the registered callback when action passed to matcher.
	 * @param action Action name.
	 * @param state A state to pass in callback.
	 * @param force Ignore the action checking and run the callback forcely. Disabled by default.
	 */
	public run(action: string, state: Readonly<State>, force = false) {
		if (!force && !this.$$match(action)) {
			return;
		}

		this.$$callback(state, !this.$$called);
		this.$$called = true;
	}
}

/************************. HookLink **************************/

import { IScope } from 'angular';

export class HookLink {
	private $$destroyer: () => void;

	/**
	 * Create a HookLink.
	 * @param destroyer Destroyer function.
	 */
	constructor(destroyer: () => void) {
		this.$$destroyer = destroyer;
	}

	/**
	 * Invoke the destroyer function.
	 */
	public destroy() {
		this.$$destroyer();
	}

	/**
	 * Bind hook to scope. Automatically destroy the hook link when scope destroyed.
	 * @param scope The scope where to bound the HookLink.
	 */
	public destroyOn(scope: IScope) {
		scope.$on('$destroy', () => {
			this.$$destroyer();
		});
	}
}
