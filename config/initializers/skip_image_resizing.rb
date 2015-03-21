if Rails.env.test?
  CarrierWave.configure do |configure|
    configure.enable_processing = false
  end
end