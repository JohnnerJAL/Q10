import React from 'react';
import styled from 'styled-components';

import { Q10Context } from '../context/ContextProvider';

const LayoutContainer = styled.section`
    height: 100vh;
    font-size: 1.6rem;
    > nav {
        background-color: gray;
        > ul {
            min-height: 5vh;
            width: 80%;
            margin: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            list-style: none;
            > li {
                margin-left: -40px;
                padding: 8px;
                &:last-child {
                    cursor: pointer;
                    &:hover {
                        background-color: black;
                        color: white;
                    }
                }
            }
        }
    }
`;

export default function Layout(props) {
    const { session, setSession } = React.useContext(Q10Context);

    return (
        <LayoutContainer>
            <nav>
                <ul>
                    <li><strong>Q10</strong></li>
                    {
                        session?.status && (
                            <li onClick={() => setSession({})}>Salir</li>
                        )
                    }
                </ul>
            </nav>
            {props.children}
        </LayoutContainer>
    );
}