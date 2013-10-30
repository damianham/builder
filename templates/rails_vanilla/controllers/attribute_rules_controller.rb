class AttributeRulesController < ApplicationController
  before_action :set_attribute_rule, only: [:show, :edit, :update, :destroy]

  # GET /attribute_rules
  # GET /attribute_rules.json
  def index
    @attribute_rules = AttributeRule.all
  end

  # GET /attribute_rules/1
  # GET /attribute_rules/1.json
  def show
  end

  # GET /attribute_rules/new
  def new
    @attribute_rule = AttributeRule.new
  end

  # GET /attribute_rules/1/edit
  def edit
  end

  # POST /attribute_rules
  # POST /attribute_rules.json
  def create
    @attribute_rule = AttributeRule.new(attribute_rule_params)

    respond_to do |format|
      if @attribute_rule.save
        format.html { redirect_to @attribute_rule, notice: 'Attribute rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @attribute_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @attribute_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attribute_rules/1
  # PATCH/PUT /attribute_rules/1.json
  def update
    respond_to do |format|
      if @attribute_rule.update(attribute_rule_params)
        format.html { redirect_to @attribute_rule, notice: 'Attribute rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @attribute_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attribute_rules/1
  # DELETE /attribute_rules/1.json
  def destroy
    @attribute_rule.destroy
    respond_to do |format|
      format.html { redirect_to attribute_rules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute_rule
      @attribute_rule = AttributeRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attribute_rule_params
      params.require(:attribute_rule).permit(:id, :country, :sitecode, :company, :department, :user_type, :attribute, :attribute_value, :member_of, :operation, :update_attribute, :new_value, :feature, :group, :active, :activation_date, :comments, :updated_at, :updated_by)
    end
end
