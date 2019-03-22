import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';
import { TransactionList } from './TransactionList';

function QueryTransactions({ data: { loading, transactions } }) {
  if (loading) {
    return <div id="loading">Loading</div>;
  } else {
    return (
      <TransactionList transactions={transactions} />
    );
  }
};

export const QUERY_TRANSACTIONS = gql`
  query {
    transactions {
      id
      date
      amount
      description
      category {
        id
        name
      }
    }
  }
`;

export default graphql(QUERY_TRANSACTIONS)(QueryTransactions);
