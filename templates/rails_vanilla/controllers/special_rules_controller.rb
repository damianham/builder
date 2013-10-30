class SpecialRulesController < ApplicationController
  before_action :set_special_rule, only: [:show, :edit, :update, :destroy]

  # GET /special_rules
  # GET /special_rules.json
  def index
    @special_rules = SpecialRule.all
  end

  # GET /special_rules/1
  # GET /special_rules/1.json
  def show
  end

  # GET /special_rules/new
  def new
    @special_rule = SpecialRule.new
  end

  # GET /special_rules/1/edit
  def edit
  end

  # POST /special_rules
  # POST /special_rules.json
  def create
    @special_rule = SpecialRule.new(special_rule_params)

    respond_to do |format|
      if @special_rule.save
        format.html { redirect_to @special_rule, notice: 'Special rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @special_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @special_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /special_rules/1
  # PATCH/PUT /special_rules/1.json
  def update
    respond_to do |format|
      if @special_rule.update(special_rule_params)
        format.html { redirect_to @special_rule, notice: 'Special rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @special_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_rules/1
  # DELETE /special_rules/1.json
  def destroy
    @special_rule.destroy
    respond_to do |format|
      format.html { redirect_to special_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_rule
      @special_rule = SpecialRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_rule_params
      params.require(:special_rule).permit(:id, :sip_uri, :requestor, :feature_id, :feature, :operation, :new_value, :old_value, :comments, :on_hold, :week_before_email, :activated_email, :valid_from, :valid_until, :updated_at, :updated_by)
    end
end
