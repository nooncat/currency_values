class RateForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      manual_value: props.rate.manual_value,
      manual_value_till: props.rate.manual_value_till,
      saved: false,
      button_text: 'Сохранить',
      button_class: 'btn-primary',
      button_disabled: false
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.valid = this.valid.bind(this);
  }

  componentDidMount() {
    this.$datetimepicker = $(this.datetimepicker).datetimepicker({
      format: 'DD/MM/YYYY HH:mm',
      showClear: true,
      keepOpen: true,
      collapse: false,
      toolbarPlacement: 'bottom',
      useCurrent: false,
      minDate: moment(),
    });

    this.$datetimepicker.on('dp.change', (event) => {
      this.handleChange(event);
    });
  }

  componentWillUnmount() {
    this.$datetimepicker.destroy();
  }

  handleChange(event) {
    this.setState({
      [event.target.name]: event.target.value,
      saved: false,
      button_text: 'Сохранить',
      button_class: 'btn-primary',
      button_disabled: false
    });
  }

  valid() {
    return !!this.state.manual_value && !!this.state.manual_value_till;
  }

  handleSubmit(event) {
    event.preventDefault();
    this.setState({button_disabled: true});

    var self = this;
    $.ajax({
      url : Routes.admin_rate_path(this.props.rate.id),
      data : JSON.stringify({
        manual_value: this.state.manual_value,
        manual_value_till: this.state.manual_value_till
      }),
      type : 'PATCH',
      contentType : 'application/json',
      processData: false,
      dataType: 'json',
      success: function(response, status) {
        self.setState({saved: true, button_text: 'Сохранено', button_class: 'btn-success'});
      },
      error: function(response, status) {
        self.setState({button_text: 'Ошибка', button_class: 'btn-danger'});
      }
    });
  }

  render() {
    return <div className='rate-form'>
             <h5>{this.props.rate.from}/{this.props.rate.to}:</h5>
             <form className='form-inline' onSubmit={this.handleSubmit}>
               <div className='form-group'>
                 <input
                   type='number'
                   step='0.000001'
                   min='0.000001'
                   className='form-control'
                   placeholder='Укажите курс'
                   name='manual_value'
                   value={this.state.manual_value || ''}
                   onChange={this.handleChange}
                 />
               </div>
               <div className='form-group' style={{position: 'relative'}}>
                 <input
                   type='text'
                   className='form-control'
                   ref={datetimepicker => this.datetimepicker = datetimepicker}
                   placeholder='Укажите дату деактивации курса'
                   name='manual_value_till'
                   autoComplete='off'
                 />
               </div>
               <button
                 className={'btn ' + this.state.button_class}
                 type='submit'
                 disabled={this.state.button_disabled || this.state.saved || !this.valid()}
               >
                 {this.state.button_text}
               </button>
               <br />
               <br />
             </form>
           </div>;
  }
}
