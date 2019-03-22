import React from 'react';

export const TransactionList = ({transactions}) => {
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
  )
};
