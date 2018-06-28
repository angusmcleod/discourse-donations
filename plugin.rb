# name: discourse-donations
# about: Integrates Stripe into Discourse to allow forum visitors to make donations
# version: 1.11.1
# url: https://github.com/chrisbeach/discourse-donations
# authors: Rimian Perkins, Chris Beach, Angus McLeod

gem 'stripe', '2.8.0'

register_asset "stylesheets/discourse-donations.scss"

enabled_site_setting :discourse_donations_enabled

register_html_builder('server:before-head-close') do
  "<script src='https://js.stripe.com/v3/'></script>"
end

after_initialize do
  load File.expand_path('../lib/discourse_donations/engine.rb', __FILE__)
  load File.expand_path('../config/routes.rb', __FILE__)
  load File.expand_path('../app/controllers/controllers.rb', __FILE__)
  load File.expand_path('../app/jobs/jobs.rb', __FILE__)
  load File.expand_path('../app/services/services.rb', __FILE__)

  Discourse::Application.routes.append do
    mount ::DiscourseDonations::Engine, at: 'donate'
  end

  class ::User
    def stripe_customer_id
      if custom_fields['stripe_customer_id']
        custom_fields['stripe_customer_id'].to_s
      else
        nil
      end
    end
  end
end
