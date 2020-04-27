  CarrierWave.configure do |config|
    config.storage    =  :aws                  # required
    config.aws_bucket =  ENV['minimalistest']      # required
    config.aws_acl    =  :public_read

    config.aws_credentials = {
      access_key_id:      ENV['AWS_ACCESS_KEY_ID'],       # required
      secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY']     # required
    }

    config.aws_attributes = {
      'Cache-Control'=>"max-age=#{365.day.to_i}",
      'Expires'=>'Tue, 29 Dec 2015 23:23:23 GMT'
    }
  end