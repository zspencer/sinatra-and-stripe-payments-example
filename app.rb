require 'sinatra'
require 'stripe'

require 'dotenv'
Dotenv.load

set :publishable_key, ENV['STRIPE_PUBLISHABLE_KEY']
set :secret_key, ENV['STRIPE_SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/charge' do
  # Amount in cents
  @amount = 10000

  customer = Stripe::Customer.create(
    :email => params[:email],
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Monthly Fee for Headspace',
    :currency    => 'usd',
    :customer    => customer.id
  )

  erb :charge
end


error Stripe::CardError do
  env['sinatra.error'].message
end
