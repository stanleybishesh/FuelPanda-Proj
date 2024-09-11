module Users
  class UserService
    attr_reader :params
    attr_accessor :success, :errors, :user, :token

    def initialize(params = {})
      @params = params
      @success = false
      @errors = []
    end

    def execute_user_login
      handle_user_login
      self
    end

    def execute_user_logout
      handle_user_logout
      self
    end

    def success?
      @success || @errors.empty?
    end

    def errors
      @errors.join(", ")
    end

    private

    def handle_user_login
      begin
        @user = User.find_by(email: params[:email])
        if @user
          ActsAsTenant.with_tenant(@user.tenant) do
            if @user&.valid_password?(params[:password])
              jti = SecureRandom.uuid
              @token = ::JWT.encode({ user_id: @user.id, jti: jti, exp: 1.day.from_now.to_i, type: "user" }, "secret", "HS256")

              # Optionally, store the JTI in the database or a cache with an expiration time
              @user.update(jti: jti)
              @success = true
              @errors = []
            else
              raise ActiveRecord::ActiveRecordError, "Invalid email or password"
              @success = false
              @errors = [ @user.errors.full_messages ]
            end
          end
        else
          raise ActiveRecord::RecordNotFound, "User not registered"
          @success = false
          @errors = [ @user.errors.full_messages ]
        end
      rescue ActiveRecord::ActiveRecordError => err
        @success = false
        @errors << err.message
      rescue ActiveRecord::RecordNotFound => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_user_logout
      begin
        @user = current_user
        if @user
          ActsAsTenant.with_tenant(@user.tenant) do
            new_jti = SecureRandom.uuid
            @user.update(jti: new_jti)
            @success = true
            @errors=[]
          end
        else
          raise ActiveRecord::RecordNotFound, "User not logged in"
          @success = false
          @errors = [ @user.errors.full_messages ]
        end
      rescue ActiveRecord::RecordNotFound => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
      debugger
    end

    def current_user
      params[:current_user]
    end

    def user_params
      ActionController::Parameters.new(params).permit(:name, :email, :password)
    end
  end
end