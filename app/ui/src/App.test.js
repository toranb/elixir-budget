import React from 'react';
import Enzyme, { mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import DateWrapper from './DateWrapper';
import PreloadWrapper from './PreloadWrapper';
import { App } from './App';
import { mocks, categories, uncategorizedCategoryId, autoCategoryId } from './App.data';
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

    let transactions = component.find('table tbody');
    expect(transactions.children().length).toEqual(2);

    expect(transactions.childAt(0).type()).toEqual('tr');
    let rows = component.find('table tbody');

    expect(rows.childAt(0).childAt(0).type()).toEqual('td');
    expect(rows.childAt(0).childAt(0).text()).toContain('2019-01-01');
    expect(rows.childAt(0).childAt(1).text()).toContain('100');
    expect(rows.childAt(0).childAt(2).text()).toContain('one');
    expect(rows.childAt(0).childAt(3).text()).toContain('Uncategorized');

    expect(rows.childAt(1).childAt(0).type()).toEqual('td');
    expect(rows.childAt(1).childAt(0).text()).toContain('2019-02-01');
    expect(rows.childAt(1).childAt(1).text()).toContain('200');
    expect(rows.childAt(1).childAt(2).text()).toContain('two');
    expect(rows.childAt(1).childAt(3).text()).toContain('Uncategorized');
  });

  it('form submit will insert transaction', async () => {
    const form = component.find('form');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    let transactions = component.find('table tbody');
    expect(transactions.children().length).toEqual(2);

    let descriptionInput = component.find('.description');
    let amountInput = component.find('.amount');
    let categoriesSelect = component.find('.category');

    categoriesSelect.simulate('change', { target: { name: 'category', value: autoCategoryId } });
    amountInput.simulate('change', { target: { name: 'amount', value: '300' } });
    descriptionInput.simulate('change', { target: { name: 'description', value: 'three' } });
    form.simulate('submit');

    await new Promise((resolve) => setTimeout(resolve, 1));
    component.update();

    transactions = component.find('table tbody');
    expect(transactions.children().length).toEqual(3);

    expect(transactions.childAt(0).type()).toEqual('tr');
    let rows = component.find('table tbody');

    expect(rows.childAt(2).childAt(0).type()).toEqual('td');
    expect(rows.childAt(2).childAt(0).text()).toContain('2019-03-01');
    expect(rows.childAt(2).childAt(1).text()).toContain('300');
    expect(rows.childAt(2).childAt(2).text()).toContain('three');
    expect(rows.childAt(2).childAt(3).text()).toContain('Auto');

    descriptionInput = component.find('.description');
    expect(descriptionInput.instance().value).toEqual('');
    amountInput = component.find('.amount');
    expect(amountInput.instance().value).toEqual('0');
    categoriesSelect = component.find('.category');
    expect(categoriesSelect.instance().value).toEqual(uncategorizedCategoryId);
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
