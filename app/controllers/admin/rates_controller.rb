module Admin
  class RatesController < ApplicationController
    def edit_index
      @rates = ::Rate.all
    end

    def update
      @rate = ::Rate.find(params[:id])

      if @rate.update(rate_params)
        render json: nil, status: :ok
      else
        render json: @rate.errors, status: :unprocessable_entity
      end
    end

    private

    def rate_params
      params.require(:rate).permit(:manual_value, :manual_value_till)
    end
  end
end
