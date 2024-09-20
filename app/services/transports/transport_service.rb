module Transports
  class TransportService
    attr_reader :params
    attr_accessor :success, :errors, :transport, :transports
    def initialize(params = {})
      @params = params
      @success = false
      @errors = []
    end

    def execute_create_transport
      handle_create_transport
      self
    end

    def execute_update_transport
      handle_update_transport
      self
    end

    def execute_delete_transport
      handle_delete_transport
      self
    end

    def execute_get_all_transport
      handle_get_all_transport
      self
    end

    def execute_get_transports_by_vehicle_type(vehicle_type)
      handle_get_transports_by_vehicle_type(vehicle_type)
      self
    end

    def success?
      @success || @errors.empty?
    end

    def errors
      @errors.join(", ")
    end

    private

    def handle_create_transport
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @transport = Transport.new(transport_params)
            if @transport.save
              @success = true
              @errors = []
            else
              @success = false
              @errors = @transport.errors.full_messages
            end
          end
        else
          @success = false
          @errors << "User not logged in"
        end
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_update_transport
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @transport = Transport.find(params[:transport_id])
            if @transport.update(transport_params)
              @success = true
              @errors = []
            else
              @success = false
              @errors = @transport.errors.full_messages
            end
          end
        else
          @success = false
          @errors << "User not logged in"
        end
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_delete_transport
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @transport = Transport.find(params[:transport_id])
            if @transport.destroy
              @success = true
              @errors = []
            else
              @success = false
              @errors = @transport.errors.full_messages
            end
          end
        else
          @success = false
          @errors << "User not logged in"
        end
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_get_all_transport
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @transports = Transport.all
            @success = true
            @errors = []
          end
        else
          @success = false
          @errors << "User not logged in"
        end
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_get_transports_by_vehicle_type(vehicle_type)
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @transports = Transport.where(vehicle_type: vehicle_type)
            @success = true
            @errors = []
          end
        else
          @success = false
          @errors << "User not logged in"
        end
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def current_user
      params[:current_user]
    end

    def transport_params
      ActionController::Parameters.new(params).permit(:name, :status, :vehicle_type)
    end
  end
end