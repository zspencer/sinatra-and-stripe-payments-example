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

  puts params

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

__END__

@@ layout
<!DOCTYPE html>
<html>
<head></head>
<body>
<%= yield %>
</body>
</html>


@@ index
  <form action="/charge" method="post" class="payment">
    <article>
      <label class="amount">
        <span>Amount: $100.00</span>
      </label>
      <label>Email:
        <input name="email" type="email">
      </label>`
    </article>

    <script src="https://checkout.stripe.com/v2/checkout.js" class="stripe-button"
            data-key="<%= settings.publishable_key %>"></script>
  </form>

@@ charge
  <h2>Thanks, you paid <strong>$100.00</strong>!</h2>
