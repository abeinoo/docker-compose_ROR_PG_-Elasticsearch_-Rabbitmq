class Api::V1::BugsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:index, :create]
  before_action :set_bug, only: [:show, :update, :destroy]
  # GET /bugs
  def index
    @bugs = Bug.all
    render json: @bugs
  end
  # GET /bugs/1
  def show
    render json: @bug
  end
  # POST /bugs
  def create
    byebug
    @bug = Bug.new(bug_params)
    if @bug.save
      render json: @bug, status: :created, location: [:api, @bug]
    else
      render json: @bug.errors, status: :unprocessable_entity
    end
  end
  # PATCH/PUT /bugs/1
  def update
    if @bug.update(bug_params)
      render json: @bug
    else
      render json: @bug.errors, status: :unprocessable_entity
    end
  end
  # DELETE /bugs/1
  def destroy
    @bug.destroy
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = bug.find(params[:id])
    end
    # Only allow a trusted parameter "white list" through.
    def bug_params
      params.require(:bug).permit(:application_token, :number, :status, :priority, :comment, :state_id, state_attributes: [ :id, :device, :os, :memory, :storage])
    end
end