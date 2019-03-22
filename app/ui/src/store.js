import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';

const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const number = ((state, action) => {
  if(action.type === 'ADD') {
    return state + 1;
  }
  return state || 0;
});

const rootReducer = combineReducers({
  number
});

export default() => {
  const middleware = [thunk];
  const createStoreWithMiddleware = composeEnhancers(applyMiddleware(...middleware))(createStore);
  return createStoreWithMiddleware(rootReducer);
}
