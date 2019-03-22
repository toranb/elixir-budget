import React, { Component } from 'react';
import gql from 'graphql-tag';
import { Mutation } from 'react-apollo';
import { graphql } from 'react-apollo';
import { QUERY_TRANSACTIONS } from '../Transactions/QueryTransactions';
import { AddTransaction } from './AddTransaction';

export const CREATE_TRANSACTION = gql`
  mutation CreateTransaction($description: String!, $amount: Int!, $date: String!) {
    createTransaction(description: $description, amount: $amount, date: $date) {
      id
      date
      amount
      description
    }
  }
`;

const defaults = {
  amount: 0,
  description: ''
};

export class MutateTransactions extends Component {
  constructor(props) {
    super(props);

    this.state = defaults;
    this.dispatch = this.dispatch.bind(this);
    this.reset = this.reset.bind(this);
  }

  dispatch(event) {
    const target = event.target;
    const name = target.name;
    const value = target.value;
    this.setState({
      [name]: value
    });
  }

  reset() {
    this.setState(defaults);
  }

  render() {
    return (
      <Mutation
        mutation={CREATE_TRANSACTION}
        update={(cache, { data: { createTransaction } }) => {
          const { transactions } = cache.readQuery({ query: QUERY_TRANSACTIONS });
          cache.writeQuery({
            query: QUERY_TRANSACTIONS,
            data: { transactions: transactions.concat([createTransaction]) },
          });
          this.reset();
        }}
      >
        {(createTransaction, { data }) => (
          <AddTransaction inputs={this.state} dispatch={this.dispatch} createTransaction={createTransaction} data={data} />
        )}
      </Mutation>
    );
  }
};

export default graphql(CREATE_TRANSACTION)(MutateTransactions);
