import React from 'react';

export const TransactionList = ({transactions}) => {
  return (
    <table>
      <thead>
        <tr>
          <th>date</th>
          <th>amount</th>
          <th>description</th>
          <th>category</th>
        </tr>
      </thead>
      <tbody>
      {transactions.map(transaction =>
        <tr key={transaction.id}>
          <td className="date-value">{transaction.date}</td>
          <td className="amount-value">{transaction.amount}</td>
          <td className="desc-value">{transaction.description}</td>
          <td className="category-value">{transaction.category.name}</td>
        </tr>
      )}
      </tbody>
    </table>
  )
};
