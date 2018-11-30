class Rate extends React.Component {
  render() {
    return <li className='list-group-item'>
             {this.props.rate.from}/{this.props.rate.to}: {this.props.rate.value}
           </li>;
  }
}
