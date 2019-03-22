import { QUERY_TRANSACTIONS } from './Transactions/QueryTransactions';
import { CREATE_TRANSACTION } from './Forms/MutateTransactions';

export const uncategorizedCategoryId = '0d015d96f63a8c12d96b8399482b593f';
export const autoCategoryId = '06b9281e396db002010bde1de57262eb';
const donationsCategoryId = '308f182147c89087faffe07e0177610e';

const categories = {
  dataset: {
    configuration: `[{"id":"${uncategorizedCategoryId}","name":"Uncategorized"},{"id":"${autoCategoryId}","name":"Auto"},{"id":"${donationsCategoryId}","name":"Donations"}]`
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
            date: '2019-01-01T00:00:00',
            category: {
              id: uncategorizedCategoryId,
              name: 'Uncategorized'
            }
          },
          {
            id: '2',
            description: 'two',
            amount: 200,
            date: '2019-02-01T00:00:00',
            category: {
              id: uncategorizedCategoryId,
              name: 'Uncategorized'
            }
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
        date: '2019-03-01T00:00:00',
        categoryId: autoCategoryId
      },
    },
    result: {
      data: {
        createTransaction: {
          id: '3',
          description: 'three',
          amount: 300,
          date: '2019-03-01T00:00:00',
          categoryId: autoCategoryId,
          category: {
            id: autoCategoryId,
            name: 'Auto'
          }
        },
      },
    },
  },
];

export { mocks, categories };
