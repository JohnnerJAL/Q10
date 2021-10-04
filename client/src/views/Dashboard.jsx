import React from 'react';
import styled from 'styled-components';
import { Redirect } from 'react-router-dom';
import { ToastContainer, toast } from 'react-toastify';
import axios from 'axios';

import { Q10Context } from '../context/ContextProvider';

const DashboardContainer = styled.section`
    height: 95vh;
    background-color: #b4b4b4;
    .cards {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100%;
    }
    .card {
        width: 25%;
        padding: 12px;
        background-color: gray;
        border-radius: 4px;
        cursor: pointer;
        > p {
            padding: 4px;
            &:first-child {
                font-weight: bold;
            }
        }
    }
`;

export default function Dashboard() {
    const { session, currentTest, setCurrentTest, total } = React.useContext(Q10Context);
    // `api/tests/${id}`
    const [tests, setTests] = React.useState([]);

    React.useEffect(() => {
        axios.get(`api/tests`, {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(data => {
                console.log(data);
                setTests(data.data);
            })
            .catch(error => console.log(error));
    }, []);

    const startTest = (id) => {
        toast.success('Comenzando test', {
            position: "bottom-right",
            autoClose: 2000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
        });

        setTimeout(() => {
            setCurrentTest({ id: id });
        }, 2000);
    }

    if (currentTest.id) {
        return <Redirect to={`/test/${currentTest.id}`}/>;
    }

    if (!session.status) {
        return <Redirect to="/"/>;
    }

    return (
        <DashboardContainer>
            <ToastContainer/>
            <p>Puntos totales: {total}</p>
            <div className="cards">
                {
                    tests.map(test => (
                        <div className="card" key={test.id} onClick={() => startTest(test.id)}>
                            <p>{test.name}</p>
                            <p>{test.description}</p>
                            <p>{test.createdOn}</p>
                        </div>
                    ))
                }
            </div>
        </DashboardContainer>
    );
}