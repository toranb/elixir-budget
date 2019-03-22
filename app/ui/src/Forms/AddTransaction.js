import React, { Component } from 'react';
import DateWrapper from '../DateWrapper';
export class AddTransaction extends Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();

    const date = DateWrapper.format();
    const { amount, description, category } = this.props.inputs;
    this.props.createTransaction({
      variables: {
        description: description,
        amount: parseInt(amount, 10),
        date: date,
        categoryId: category
      }
    });
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input name="description" className="description" placeholder="description" value={this.props.inputs.description} onChange={this.props.dispatch} />
        <input name="amount" className="amount" placeholder="amount" value={this.props.inputs.amount} onChange={this.props.dispatch} />

        <select className="category" name="category" value={this.props.inputs.category} onChange={this.props.dispatch}>
          {this.props.inputs.categories.map(category =>
            <option key={category.id} value={category.id}>{category.name}</option>
          )}
        </select>

        <button type="submit">Add Transaction</button>
      </form>
    )
  }
};
