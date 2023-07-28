def routes_block
  -> do
    get "new" => "basic#new"
    post "auto_permit" => "basic#auto_permit"
    post "unpermitted" => "basic#unpermitted"
  end
end
