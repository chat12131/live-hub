class AvatarUploader < CarrierWave::Uploader::Base

  class AvatarUploader < CarrierWave::Uploader::Base
    storage (ENV["S3_BUCKET"].present? ? :fog : :file)

    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
