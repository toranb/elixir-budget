import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

function TransactionList({ data: { loading, transactions } }) {
  if (loading) {
    return <div>Loading</div>;
  } else {
    return (
      <ul>
        {transactions.map(transaction =>
          <li key={transaction.id}>
          id: {transaction.id}
          amount: {transaction.amount}
          desc: {transaction.description}
          date: {transaction.date})
          </li>
        )}
      </ul>
    );
  }
}

export const QUERY_TRANSACTIONS = gql`
  query {
    transactions {
      id
      date
      amount
      description
    }
  }
`;

export default graphql(QUERY_TRANSACTIONS)(TransactionList);
