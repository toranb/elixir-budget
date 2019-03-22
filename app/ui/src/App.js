import React, { Component } from 'react';
import { connect } from 'react-redux';

const mapStateToProps = (state) => ({
  number: state.number
});

const mapDispatchToProps = (dispatch) => ({
  add: () => dispatch({type: 'ADD'})
});

class App extends Component {
  render() {
    return (
      <div>
        <button onClick={() => this.props.add()}>ADD</button>
        <span>{this.props.number}</span>
      </div>
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(App);
