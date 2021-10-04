import React from 'react';
import { BrowserRouter, Route } from 'react-router-dom'

import { ContextProvider } from './context/ContextProvider';
import Layout from './components/Layout';
import Home from './views/Home';
import Dashboard from './views/Dashboard';
import Test from './views/Test';

import './App.css';
import 'react-toastify/dist/ReactToastify.css';

function App() {
  return (
    <BrowserRouter>
      <ContextProvider>
        <Layout>
          <Route exact path="/" component={Home}/>
          <Route exact path="/dashboard" component={Dashboard}/>
          <Route exact path="/test/:id" component={Test}/>
        </Layout>
      </ContextProvider>
    </BrowserRouter>
  );
}

export default App;
