Thumbnailr.controllers :sandbox do
  get :index, :map => '/sandbox' do
    @title = 'Sandbox'
    render 'sandbox/index'
  end

  get :thumbnail do
    @thumbnail = Thumbnail.run_rule(params[:url],
                                    :regexp    => strip(params[:regexp]),
                                    :thumbnail => strip(params[:thumbnail]))
    render 'sandbox/thumbnail', :layout => false
  end

  get :webClip do
    @webClip = Html.run_rule(params[:url],
                             :regexp    => strip(params[:regexp]),
                             :clip      => strip(params[:clip]),
                             :transform => strip(params[:transform]))
    render 'sandbox/webClip', :layout => false
  end
end
