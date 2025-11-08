require "recommendation_system"
require "yarn_calculator"

class PatternsController < ApplicationController
  
  before_action :set_pattern, only: %i[ show edit update destroy ]

  # GET /patterns
  def index
    @patterns = Pattern.all
    render json: @patterns
  end

  # GET /patterns/1
  def show
    #@recommendations = RecommendationSystem.similar_patterns(@pattern, Pattern.all)

    @yarn_estimate = @yarn_estimate = YarnCalculator.estimate(@pattern.yarn_weight, @pattern.stitch_type, @pattern.size)
    render json: { pattern: @pattern, recommendations: @recommendations, yarn_estimate: @yarn_estimate }
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
      render json: @book, status: :created, location: @book, notice: "Pattern was successful created."
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /patterns/1
  def update
    if @pattern.update(pattern_params)
      render json: @pattern, notice: "Pattern was successfully updated."
    else 
      render json: @pattern.errors, status: :unprocessable_entity
    end
  end

  # DELETE /patterns/1
  def destroy
    @pattern.destroy!
    render notice: "Pattern was successfully destroyed."
  end

  # GET /patterns/:id/recommendations
  #def recommendations
  #  recs = RecommendationSystem.similar_patterns(@pattern, Pattern.all)
  #  render json: recs.as_json(only: [:id, :title, :difficulty, :tags])
  #end

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