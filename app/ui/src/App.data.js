import { QUERY_TRANSACTIONS } from './Transactions/QueryTransactions';
import { CREATE_TRANSACTION } from './Forms/MutateTransactions';

const categories = {
  dataset: {
    configuration: '[{"id":"0d015d96f63a8c12d96b8399482b593f","name":"Uncategorized"},{"id":"06b9281e396db002010bde1de57262eb","name":"Auto"},{"id":"308f182147c89087faffe07e0177610e","name":"Donations"}]'
  }
};

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
            date: '2019-01-01T00:00:00'
          },
          {
            id: '2',
            description: 'two',
            amount: 200,
            date: '2019-02-01T00:00:00'
          },
        ]
      },
    },
  },
  {
    request: {
      query: CREATE_TRANSACTION,
      variables: {
        description: 'three',
        amount: 300,
        date: '2019-03-01T00:00:00'
      },
    },
    result: {
      data: {
        createTransaction: {
          id: '3',
          description: 'three',
          amount: 300,
          date: '2019-03-01T00:00:00'
        },
      },
    },
  },
];

export { mocks, categories };
