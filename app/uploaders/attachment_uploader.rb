class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  version :thumb, :if => :image? do
    process resize_to_fill: [180, 180]
  end

  def store_dir
    "mountain_routes/attachements/#{model.id}"
  end

  protected

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end
