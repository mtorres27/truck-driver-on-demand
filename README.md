# AVJunction

The easier way to hire and manage freelancers. We connect the best AV freelancers with the most reputable AV companies.

## Dependencies

- Ruby 2.4.1
- Rails 5.1.0
- PostgreSQL v9.6 or greater
- PostGIS (http://postgis.net/)
- RVM (https://rvm.io/)
- ImageMagick (https://www.imagemagick.org/)

## External Services

* [Amazon S3](https://aws.amazon.com/s3)
* [Google Maps API](https://developers.google.com/maps/)
* [HubSpot](https://www.hubspot.com)
* [Sendgrid](https://sendgrid.com)
* [Stripe](https://www.stripe.com)

## Instances

Stage - [https://staging.avjunction.com/](https://staging.avjunction.com/)
Production - [https://app.avjunction.com](https://app.avjunction.com)

## Development Setup

### Define ruby gemset

If using RVM, be sure to set up your gemset:

    cd avjunction
    echo "avjunction" > .ruby-gemset
    cd ..
    cd avjunction

### Update the database.yml

- Run `cp config/database.template.yml config/database.yml`
- Edit the database.yml to specify your specific database username/password if needed.

### Bundle

    gem install bundler
    bundle

### Secrets file

Create the secrets file:

    rails secrets:setup

Edit the secrets file:

    rails secrets:edit

And then copy the content from `config/secrets.yml.template` to the `secrets` and update the values.

### Create database

    rails db:create

### Migrate and seed database

    rails db:setup
