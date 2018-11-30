class Rates extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      rates: props.rates
    };
  }

  render() {
    return <div className='records'>
             {/* TODO: to locals */}
             <h1>Currency values</h1>
             <ul className='list-group'>
               {this.props.rates.map(rate => (
                 <Rate key={rate.id} rate={rate} />
               ))}
             </ul>
           </div>;
  }
}

Rates.defaultProps = {
  rates: []
};
