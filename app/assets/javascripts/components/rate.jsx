class Rate extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: props.rate.value
    };

    this.handleReceivedData = this.handleReceivedData.bind(this);
  }

  componentDidMount() {
    this.subscription = App.cable.subscriptions.create(
      {channel: 'RateChannel', rate_id: this.props.rate.id},
      {received: this.handleReceivedData}
    );
  }

  componentWillUnmount() {
    this.subscription.unsubscribe();
  }

  handleReceivedData(data) {
    if (data.value !== this.state.value) {
      this.setState({value: data.value});
    }
  }

  render() {
    return <li className='list-group-item'>
             {this.props.rate.from}/{this.props.rate.to}: {this.state.value}
           </li>;
  }
}
