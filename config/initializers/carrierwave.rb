unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIA27G5AP5DPFZAU7UL',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'rails-photo-123'
    config.cache_storage = :fog
  end
end