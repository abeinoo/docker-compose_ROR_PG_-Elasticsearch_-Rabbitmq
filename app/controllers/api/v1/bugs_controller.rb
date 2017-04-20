class Api::V1::BugsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_bug, only: [:show, :update, :destroy]
  before_action :set_bug_by_app_token, only: [:show_bug]

  # GET /bugs
  def index
    @bugs = Bug.search((params[:q].present? ? params[:q] : ""))
    @index_mapping = Bug.index_mapping 
    # for mapping the att. 
#     {"properties"=>{"application_token"=>{"type"=>"string"}, "comment"=>{"type"=>"string", "fields"=>{"keyword"=>{"type"=>"string", "index"=>
# "not_analyzed", "ignore_above"=>256, "fielddata"=>false}}, "fielddata"=>false}, "created_at"=>{"type"=>"date", "format"=>"strict_date_option
# al_time||epoch_millis"}, "id"=>{"type"=>"long"}, "number"=>{"type"=>"long"}, "priority"=>{"type"=>"string"}, "status"=>{"type"=>"string"}, "
# updated_at"=>{"type"=>"date", "format"=>"strict_date_optional_time||epoch_millis"}}}
    render json: @bugs
  end
  # GET /bugs/1
  def show
    render json: @bug
  end

  def show_bug
    render json: @bug
  end
  # POST /bugs
  def create
    @bug = Bug.new(bug_params)
    
    if @bug.save
      Publisher.publish("bugs", @bug.attributes)
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
      @bug = Bug.find(params[:id])
    end
    def set_bug_by_app_token
      @bug = Bug.find_by(number: params[:number],application_token: params[:app_token])
    end
    # Only allow a trusted parameter "white list" through.
    def bug_params
      params.require(:bug).permit(:application_token, :number, :status, :priority, :comment, :state_id, state_attributes: [ :id, :device, :os, :memory, :storage])
    end
end