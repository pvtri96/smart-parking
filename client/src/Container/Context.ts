import * as React from 'react';

export interface IContext {
    requestKey:  string;
    setState(requestKey: string): void;
}

const Context = React.createContext<IContext>({
    requestKey: "",
    setState: () => {}
});

export const ContextProvider = Context.Provider;

export const ContextConsumer = Context.Consumer;
