import React from 'react';
import Enzyme, { mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { App } from './App';
import { mocks } from './App.data';
import { MockedProvider } from 'react-apollo/test-utils';

Enzyme.configure({ adapter: new Adapter() });

describe('App', () => {
  let component;

  beforeEach(() => {
    component = mount(
      <MockedProvider mocks={mocks} addTypename={false}>
        <App />
      </MockedProvider>
    );
  });

  it('query for transactions and show them', async () => {
    let transactions = component.find('div').text();
    expect(transactions).toEqual('Loading');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    transactions = component.find('ul');
    expect(transactions.children().length).toEqual(2);

    expect(transactions.childAt(0).type()).toEqual('li');
    expect(transactions.childAt(0).text()).toContain('id: 1');
    expect(transactions.childAt(0).text()).toContain('amount: 100');
    expect(transactions.childAt(0).text()).toContain('desc: one');
    expect(transactions.childAt(0).text()).toContain('date: 2019-01-01');

    expect(transactions.childAt(1).type()).toEqual('li');
    expect(transactions.childAt(1).text()).toContain('id: 2');
    expect(transactions.childAt(1).text()).toContain('amount: 200');
    expect(transactions.childAt(1).text()).toContain('desc: two');
    expect(transactions.childAt(1).text()).toContain('date: 2019-02-01');
  });

});
