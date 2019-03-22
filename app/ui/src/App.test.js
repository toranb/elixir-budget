import React from 'react';
import Enzyme, { mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import App from './App';
import { Provider } from 'react-redux';
import Store from './store';

Enzyme.configure({ adapter: new Adapter() });

describe('App', () => {
  let component;

  beforeEach(() => {
    const StoreInstance = Store();
    component = mount(
      <Provider store={StoreInstance}>
        <App />
      </Provider>
    );
  });

  it('clicking button increments counter', () => {
    let number = component.find('span').text();
    expect(number).toEqual('0');

    component.find('button').simulate('click');

    number = component.find('span').text();
    expect(number).toEqual('1');
  });

});
