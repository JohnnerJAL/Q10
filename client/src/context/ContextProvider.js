import React from 'react';
import { useLocalStorage } from './useLocalStorage';

const Q10Context = React.createContext();

const ContextProvider = (props) => {
    const [session, setSession] = useLocalStorage('session', {});
    const [currentTest, setCurrentTest] = useLocalStorage('currentTest', {});
    const [total, setTotal] = useLocalStorage('total', 0);
    const [game, setGame] = useLocalStorage('game', {
        lvl_sp: 'Primer nivel',
        lvl_text: 'First level',
        lvl: 1
    });

    return (
        <Q10Context.Provider value={{
            session,
            setSession,
            currentTest,
            setCurrentTest,
            game,
            setGame,
            total,
            setTotal
        }}>
            {props.children}
        </Q10Context.Provider>
    );
}

export { ContextProvider, Q10Context };