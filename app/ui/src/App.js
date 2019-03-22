import React, { Component } from 'react';
import QueryTransactions from './Transactions/QueryTransactions';
import MutateTransactions from './Forms/MutateTransactions';

export class App extends Component {
  render() {
    return (
      <div>
        <MutateTransactions />
        <QueryTransactions />
      </div>
    )
  }
};
