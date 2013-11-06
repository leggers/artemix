class TransformController < ApplicationController
  def create
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
