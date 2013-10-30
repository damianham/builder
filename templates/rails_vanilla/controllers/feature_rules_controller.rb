class FeatureRulesController < ApplicationController
  before_action :set_feature_rule, only: [:show, :edit, :update, :destroy]

  # GET /feature_rules
  # GET /feature_rules.json
  def index
    @feature_rules = FeatureRule.all
  end

  # GET /feature_rules/1
  # GET /feature_rules/1.json
  def show
  end

  # GET /feature_rules/new
  def new
    @feature_rule = FeatureRule.new
  end

  # GET /feature_rules/1/edit
  def edit
  end

  # POST /feature_rules
  # POST /feature_rules.json
  def create
    @feature_rule = FeatureRule.new(feature_rule_params)

    respond_to do |format|
      if @feature_rule.save
        format.html { redirect_to @feature_rule, notice: 'Feature rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feature_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @feature_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feature_rules/1
  # PATCH/PUT /feature_rules/1.json
  def update
    respond_to do |format|
      if @feature_rule.update(feature_rule_params)
        format.html { redirect_to @feature_rule, notice: 'Feature rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feature_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feature_rules/1
  # DELETE /feature_rules/1.json
  def destroy
    @feature_rule.destroy
    respond_to do |format|
      format.html { redirect_to feature_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature_rule
      @feature_rule = FeatureRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feature_rule_params
      params.require(:feature_rule).permit(:id, :feature, :feature_id, :country, :sitecode, :company, :department, :user_type, :deny, :active, :activation_date, :comments, :updated_at, :updated_by)
    end
end
