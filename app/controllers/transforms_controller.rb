class TransformsController < ApplicationController
  def create
    params = transform_params
    scale_factor = 20 # template.png height divided by canvas height
    to_scale = [:image_x, :image_y, :height, :width]
    to_scale.each { |k| params[k] = params[k].to_i.abs * scale_factor }
    params[:artwork_id] = params[:artwork_id].to_i
    params[:design_id] = params[:design_id].to_i
    puts params.inspect
    @transform = Transform.new(params)
    respond_to do |format|
      if @transform.save
        format.js {render 'success'}
      else
        format.js {render 'error'}
      end
    end
  end

  def update
  end

  def edit
  end

  private

  def transform_params
    params.require(:transform).permit(:image_x, :image_y, :width, :height, :leg, :mirror, :artwork_id, :design_id, :rotation)
  end
end
