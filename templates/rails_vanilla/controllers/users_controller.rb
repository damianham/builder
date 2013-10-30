class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :employee_type, :guid, :sip_uri, :mail, :account_name, :title, :given_name, :sn, :computer_user_id, :mail_nickname, :description, :display_name, :country, :sitecode, :department, :location, :office_name, :mobile, :telephone_number, :other_telephone, :dn, :domain_name, :ad_disabled, :company, :location_profile, :federation, :remote_access, :archiving, :option_flags, :pic, :rcc, :p2p_audio, :p2p_video, :anonymous_meetings, :uc, :tel_uri, :comments, :group_cache, :policy_cache, :frozen_from, :frozen_until, :proxy_addresses, :user_account_control, :shell_department_number, :shell_default_billing, :shell_customer_billing_code, :shell_telephone_extension, :shell_email_node_id, :shell_gender, :shell_known_by_name, :shell_modify_auth, :shell_office_locality, :updated_at, :updated_by)
    end
end
