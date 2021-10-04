import React from 'react';
import styled from 'styled-components';
import axios from 'axios';
import { ToastContainer, toast } from 'react-toastify';
import { Redirect } from 'react-router-dom';

import { Q10Context } from '../context/ContextProvider';

const HomeContainer = styled.section`
    height: 95vh;
    background-color: #b4b4b4;
    display: flex;
`;

const FormContainer = styled.div`
    margin: auto;
    display: flex;
    flex-direction: column;
    > div {
        display: flex;
        justify-content: space-evenly;
        > label {
            height: 4rem;
            padding: 4px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            > p {
                font-size: 1.2rem;
            }
        }
    }
    > form {
        display: flex;
        flex-direction: column;
        > input {
            margin: 8px;
            padding: 4px;
            border-radius: 4px;
            &:focus {
                outline: none;
            }
        }
        > button {
            width: 40%;
            margin: auto;
            transform: translateY(10px);
            padding: 4px;
            border-radius: 4px;
            background-color: blue;
            color: white;
            cursor: pointer;
        }
    }
`;

export default function Home() {
    const { setSession } = React.useContext(Q10Context);

    const [logged, setLogged] = React.useState(false);
    const [login, setLogin] = React.useState(true);

    const changeForm = (e) => {
        if (e.target.value === "login") {
            setLogin(true);
        } else {
            setLogin(false);
        }
    }

    const form = React.useRef();

    const handleSubmit = (e) => {
        e.preventDefault();
    
        const formData = new FormData(form.current);
    
        const object = {};
        formData.forEach((value, key) => {
          object[key] = value;
        });

        const url = login ? 'api/users/login' : 'api/users/register';
    
        axios.post(url, JSON.stringify(object), {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(data => {
                if (data.data.length > 0) {
                    toast.success('Bienvenido', {
                        position: "bottom-right",
                        autoClose: 2000,
                        hideProgressBar: false,
                        closeOnClick: true,
                        pauseOnHover: true,
                        draggable: true,
                        progress: undefined,
                    });
                    
                    setTimeout(() => {
                        setSession({
                            status: true,
                            user: data.data[0]['alias'],
                            id: data.data[0]['id']
                        });

                        setLogged(true);
                    }, 2000);
                } else {
                    toast.error('Alias y/o key incorrecto', {
                        position: "bottom-right",
                        autoClose: 2000,
                        hideProgressBar: false,
                        closeOnClick: true,
                        pauseOnHover: true,
                        draggable: true,
                        progress: undefined,
                    });
                }
                
                console.log(data);
            })
            .catch(error => {
                console.log(error);
            });
    }

    if (logged) {
        return <Redirect to="/dashboard"/>;
    }
    
    return (
        <HomeContainer>
            <ToastContainer/>
            <FormContainer>
                <div>
                    <label htmlFor="home_login">
                        <p>Ingresar</p>
                        <input
                            id="home_login"
                            type="radio"
                            name="login"
                            value="login"
                            onChange={changeForm}
                            checked={login}
                        />
                    </label>
                    <label htmlFor="home_register">
                        <p>Registrar</p>
                        <input
                            id="home_register"
                            type="radio"
                            name="login"
                            value="register"
                            onChange={changeForm}
                            checked={!login}
                        />
                    </label>
                </div>
                <form onSubmit={handleSubmit} ref={form} method="POST">
                    <input type="text" placeholder="Alias ...." name="alias" required/>
                    <input type="password" placeholder="Key ...." name="key" required/>
                    {!login && (
                        <input type="date"
                        placeholder="Fecha de nacimiento"
                        name="birthday"
                            required
                            />
                            )}
                    <button>{login ? 'Ingresar' : 'Registrar'}</button>
                </form>
            </FormContainer>
        </HomeContainer>
    );
}