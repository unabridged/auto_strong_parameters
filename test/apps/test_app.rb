class TestApp
  def self.routes
    -> do
      get "new" => "basic#new"
      post "auto_permit" => "basic#auto_permit"
      post "unpermitted" => "basic#unpermitted"
    end
  end

  def self.secret_key_base
    '49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk'
  end
end
