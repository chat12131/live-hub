CarrierWave.configure do |config|
  if ENV["S3_BUCKET"].present?
    config.storage = :fog
    config.fog_provider = "fog/aws"

    config.fog_credentials = {
      provider:              "AWS",
      region:                ENV.fetch("AWS_REGION", "ap-northeast-1"),
      use_iam_profile:       true
    }

    config.fog_directory  = ENV["S3_BUCKET"]
    config.fog_public     = false
  end
end
