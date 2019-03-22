import React, { Component } from 'react';
import gql from 'graphql-tag';
import { Mutation } from 'react-apollo';
import { graphql } from 'react-apollo';
import { QUERY_TRANSACTIONS } from '../Transactions/QueryTransactions';
import { AddTransaction } from './AddTransaction';
import PreloadWrapper from '../PreloadWrapper';

export const CREATE_TRANSACTION = gql`
  mutation CreateTransaction($description: String!, $amount: Int!, $date: String!, $categoryId: String!) {
    createTransaction(description: $description, amount: $amount, date: $date, categoryId: $categoryId) {
      id
      date
      amount
      description
      categoryId
      category {
        id
        name
      }
    }
  }
`;

export class MutateTransactions extends Component {
  constructor(props) {
    super(props);

    this.preload = this.preload.bind(this);
    this.state = this.defaults();
    this.dispatch = this.dispatch.bind(this);
    this.reset = this.reset.bind(this);
  }

  preload() {
    const loaded = PreloadWrapper.preload();
    const categories = JSON.parse(loaded.dataset.configuration);
    const defaultCategory = categories.filter((c) => c.name === 'Uncategorized');
    const [ found ] = defaultCategory;
    const uncategorized = found.id;
    return {
      categories,
      uncategorized
    }
  }

  defaults() {
    const { categories, uncategorized } = this.preload();
    return {
      amount: 0,
      description: '',
      category: uncategorized,
      categories: categories
    };
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
    this.setState(this.defaults());
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
