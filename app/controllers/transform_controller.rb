class TransformController < ApplicationController
  def create
    @transform = Transform.new(transform_params)
    respond_to do |format|
      if @transform.save
        format.js {render 'success'}
      else
        format.js {render 'error'}
    end
  end

  def update
  end

  def edit
  end

  private

  def transform_params
    params.require(:transform).permit(:image_x, :image_y, :width, :height, :leg, :mirrored, :artwork_id, :design_id, :rotation)
  end
end
