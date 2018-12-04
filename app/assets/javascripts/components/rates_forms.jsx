class RatesForms extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      rates: props.rates
    };
  }

  render() {
    return <div className='rates-forms'>
             <h1>Редактирование курса</h1>
             <ul className='list-group'>
               {this.props.rates.map(rate => (
                 <RateForm key={rate.id} rate={rate} />
               ))}
             </ul>
           </div>;
  }
}

RatesForms.defaultProps = {
  rates: []
};
