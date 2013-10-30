class ProfileRulesController < ApplicationController
  before_action :set_profile_rule, only: [:show, :edit, :update, :destroy]

  # GET /profile_rules
  # GET /profile_rules.json
  def index
    @profile_rules = ProfileRule.all
  end

  # GET /profile_rules/1
  # GET /profile_rules/1.json
  def show
  end

  # GET /profile_rules/new
  def new
    @profile_rule = ProfileRule.new
  end

  # GET /profile_rules/1/edit
  def edit
  end

  # POST /profile_rules
  # POST /profile_rules.json
  def create
    @profile_rule = ProfileRule.new(profile_rule_params)

    respond_to do |format|
      if @profile_rule.save
        format.html { redirect_to @profile_rule, notice: 'Profile rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @profile_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @profile_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profile_rules/1
  # PATCH/PUT /profile_rules/1.json
  def update
    respond_to do |format|
      if @profile_rule.update(profile_rule_params)
        format.html { redirect_to @profile_rule, notice: 'Profile rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @profile_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profile_rules/1
  # DELETE /profile_rules/1.json
  def destroy
    @profile_rule.destroy
    respond_to do |format|
      format.html { redirect_to profile_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_rule
      @profile_rule = ProfileRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_rule_params
      params.require(:profile_rule).permit(:id, :sitecode, :profile, :active, :activation_date, :comments, :updated_at, :updated_by)
    end
end
