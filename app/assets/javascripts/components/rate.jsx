class Rate extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      value: props.rate.value
    };

    this.handleReceivedData = this.handleReceivedData.bind(this);
  }

  componentDidMount() {
    const cable = ActionCable.createConsumer('ws://localhost:3000/cable');

    this.sub = cable.subscriptions.create({channel: 'RateChannel', rate_id: this.props.rate.id}, {
      received: this.handleReceivedData
    });
  }

  render() {
    return <li className='list-group-item'>
             {this.props.rate.from}/{this.props.rate.to}: {this.state.value}
           </li>;
  }

  handleReceivedData(data) {
    if (data.value !== this.state.value) {
      this.setState({value: data.value});
    }
  }
}
