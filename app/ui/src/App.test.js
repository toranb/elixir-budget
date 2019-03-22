import React from 'react';
import Enzyme, { mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import DateWrapper from './DateWrapper';
import PreloadWrapper from './PreloadWrapper';
import { App } from './App';
import { mocks, categories } from './App.data';
import { MockedProvider } from 'react-apollo/test-utils';

Enzyme.configure({ adapter: new Adapter() });

describe('App', () => {
  let component, original, original_preload;

  beforeEach(() => {
    original = DateWrapper.now;
    original_preload = PreloadWrapper.preload;
    DateWrapper.now = () => new Date('2019-03-01');
    PreloadWrapper.preload = () => categories;
    component = mount(
      <MockedProvider mocks={mocks} addTypename={false}>
        <App />
      </MockedProvider>
    );
  });

  afterEach(() => {
    DateWrapper.now = original;
    PreloadWrapper.preload = original_preload;
  });

  it('query for transactions and show them', async () => {
    let loading = component.find('#loading').text();
    expect(loading).toEqual('Loading');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    let transactions = component.find('ul');
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

  it('form submit will insert transaction', async () => {
    const form = component.find('form');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    let transactions = component.find('ul');
    expect(transactions.children().length).toEqual(2);

    let descriptionInput = component.find('.description');
    let amountInput = component.find('.amount');

    amountInput.simulate('change', { target: { name: 'amount', value: '300' } });
    descriptionInput.simulate('change', { target: { name: 'description', value: 'three' } });
    form.simulate('submit');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    transactions = component.find('ul');
    expect(transactions.children().length).toEqual(3);

    expect(transactions.childAt(2).type()).toEqual('li');
    expect(transactions.childAt(2).text()).toContain('id: 3');
    expect(transactions.childAt(2).text()).toContain('amount: 300');
    expect(transactions.childAt(2).text()).toContain('desc: three');
    expect(transactions.childAt(2).text()).toContain('date: 2019-03-01');

    descriptionInput = component.find('.description');
    expect(descriptionInput.instance().value).toEqual('');
    amountInput = component.find('.amount');
    expect(amountInput.instance().value).toEqual('0');
  });

  it('categories are preloaded and available when the form renders', async () => {
    const select = component.find('.category');
    expect(select.children().length).toEqual(3);
    expect(select.childAt(0).type()).toEqual('option');
    expect(select.childAt(0).text()).toEqual('Uncategorized');
    expect(select.childAt(1).type()).toEqual('option');
    expect(select.childAt(1).text()).toEqual('Auto');
    expect(select.childAt(2).type()).toEqual('option');
    expect(select.childAt(2).text()).toEqual('Donations');
  });

});
