const DateWrapper = {
  now() {
    return new Date();
  },
  format() {
    return this.now().toISOString().split('.').shift();
  }
}

export default DateWrapper;
