
  CarrierWave.configure do |config|
    config.storage    =  :aws                  # required
    config.aws_bucket =  'minimalistest'      # required
    config.aws_acl    =  :public_read

    config.aws_credentials = {
      access_key_id:      ENV['AWS_ACCESS_KEY_ID'],       # required
      secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY']     # required
    }

    config.aws_attributes = -> { {
      expires: 1000.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    } }
  end
