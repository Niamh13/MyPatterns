require "recommendation_system"
require "yarn_calculator"

class PatternsController < ApplicationController
  
  before_action :set_pattern, only: %i[ show edit update destroy ]

  # GET /patterns
  def index
    @patterns = Pattern.all.order(created_at: :desc)
  end

  # GET /patterns/1
  def show
    @recommendations = RecommendationSystem.similar_patterns(@pattern, Pattern.all)

    @estimate_yarn = @pattern.estimate_yarn
  end

  # GET /patterns/new
  def new
    @pattern = Pattern.new
  end

  # GET /patterns/1/edit
  def edit; end

  # POST /patterns
  def create
    @pattern = Pattern.new(pattern_params)

    if @pattern.save
      redirect_to @pattern, notice: "Pattern was successful created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /patterns/1
  def update
    if @pattern.update(pattern_params)
      redirect_to @pattern, notice: "Pattern was successful updated."
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /patterns/1
  def destroy
    @pattern.destroy!
    redirect_to patterns_url, notice: "Pattern was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pattern
      @pattern = Pattern.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pattern_params
      params.require(:pattern).permit( :title, :source, :rating, :difficulty, :made, :tags, :yarn_weight, :stitch_type, :size, :yarn_estimate, :notes, :link, :user_id )
    end
end
