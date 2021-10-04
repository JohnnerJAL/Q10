import React from 'react';
import styled from 'styled-components';
import axios from 'axios';
import { Redirect } from 'react-router-dom';

import { Q10Context } from '../context/ContextProvider';

const TestContainer = styled.section`
    height: 95vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #b4b4b4;
`;

export default function Test() {
    const { session, currentTest, setCurrentTest, game, setGame, total, setTotal } = React.useContext(Q10Context);

    const [gameId, setGameId] = React.useState(); // R
    const [test, setTest] = React.useState([]);
    const [question, setQuestion] = React.useState();
    const [answer, setAnswer] = React.useState(false);
    
    const transformData = (test) => {
        const SUPER_TEST = {};
        //
        test.forEach(row => {
            if (!SUPER_TEST[row[4]]) {
                SUPER_TEST[row[4]] = {
                    lvl: row[3],
                    lvl_txt: row[4],
                    prize: row[5],
                    questions: {
                        [row[7]]: {
                            question: row[6],
                            options: [
                                {
                                    answer: row[8],
                                    correct: row[9]
                                }
                            ]
                        }
                    }
                };
            } else if (SUPER_TEST[row[4]]['questions'][row[7]]) {
                SUPER_TEST[row[4]]['questions'][row[7]]['options'].push({
                    answer: row[8],
                    correct: row[9]
                });
            } else {
                SUPER_TEST[row[4]] = {
                    lvl: row[3],
                    lvl_txt: row[4],
                    prize: row[5],
                    questions: {
                        ...SUPER_TEST[row[4]]['questions'],
                        [row[7]]: {
                            question: row[6],
                            options: [
                                {
                                    answer: row[8],
                                    correct: row[9]
                                }
                            ]
                        }
                    }
                };
            }
        });

        return SUPER_TEST;
    }

    React.useEffect(async () => {
        axios.get(`/api/tests/${currentTest.id}`, {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(data => {
                console.log(data);
                setTest(transformData(data.data));
            })
            .catch(error => console.log(error));

        axios.post(`/api/games`, { User_id: session.id, Test_id: currentTest.id }, {
            headers: { 'Content-Type': 'application/json' }
        })
            .then(data => {
                console.log(data);
                setGameId(data.data.Games_id);
            })
            .catch(error => console.log(error));
    }, []);

    const randomQuestion = (lvl_text, lvl) => {
        const max = 5*lvl;
        const min = 5*lvl - 5;
        const random = Math.ceil((Math.random() * (max-min)) + min);
        const randomQuestion = test[lvl_text]['questions'][random];
        setQuestion(randomQuestion);
    }

    console.log(question)

    const selectAnswer = (e) => {
        if (e.target.value === '1') {
            setAnswer(true);
        } else {
            setAnswer(false);
        }
    }

    const NIVELES = {
        '2': 'Segundo nivel',
        '3': 'Tercer nivel',
        '4': 'Cuarto nivel',
        '5': 'Quinto nivel'
    }

    const LEVELS = {
        '2': 'Second level',
        '3': 'Third level',
        '4': 'Fourth level',
        '5': 'Fifth level'
    }

    console.log(game)
    console.log(gameId)

    const checkAnswer = (e) => {
        if (answer && (game.lvl < 5)) {
            randomQuestion(LEVELS[game['lvl'] + 1], [game['lvl'] + 1]);
            //
            setGame({
                lvl_sp: NIVELES[game['lvl'] + 1],
                lvl_text: LEVELS[game['lvl'] + 1],
                lvl: game['lvl'] + 1
            });
        } else {
            axios.put(`/api/games`, { Levels_id: game['lvl'], id: gameId, Users_id: 1, Tests_id: 1 }, {
                headers: { 'Content-Type': 'application/json' }
            })
                .then(data => {
                    setTotal(total + game['lvl']*100);
                    console.log(data);
                    setGame({
                        lvl_sp: 'Primer nivel',
                        lvl_text: 'First level',
                        lvl: 1
                    })
                    //
                    setCurrentTest({});
                })
                .catch(error => console.log(error));

            console.log('Error');
        }
    }

    if (!currentTest.id) {
        return <Redirect to={`/dashboard`}/>;
    }

    return (
        <TestContainer>
            <div className="question">
                <p>{game.lvl_sp}</p>
                <p>{question?.question && question.question}
                </p>
                    {
                        question && question.options && question.options.map((option, idx) => {
                            return (
                                <div key={idx}>
                                    <input
                                        type="radio"
                                        name="answer"
                                        value={option.correct}
                                        onChange={selectAnswer}
                                    />
                                    <span>{option.answer}</span>
                                </div>
                            )
                        })
                    }
                {
                    question ? (
                        <button onClick={() => checkAnswer()}>
                            Calificar
                        </button>
                    ) : (
                        <button onClick={() => randomQuestion('First level', 1)}>
                            Comenzar
                        </button>
                    )
                }
            </div>
        </TestContainer>
    );
}