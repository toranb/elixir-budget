import { QUERY_TRANSACTIONS } from './Transactions/QueryTransactions';

const mocks = [
  {
    request: {
      query: QUERY_TRANSACTIONS,
    },
    result: {
      data: {
        transactions: [
          {
            id: '1',
            description: 'one',
            amount: 100,
            date: '2019-01-01T01:00:00'
          },
          {
            id: '2',
            description: 'two',
            amount: 200,
            date: '2019-02-01T01:00:00'
          },
        ]
      },
    },
  },
];

export { mocks };
