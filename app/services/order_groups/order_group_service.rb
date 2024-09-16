module OrderGroups
  class OrderGroupService
    attr_reader :params
    attr_accessor :success, :errors, :order_group, :order_groups

    def initialize(params = {})
      @params = params
      @success = false
      @errors = []
    end

    def execute_create_order_group
      handle_create_order_group
      self
    end

    def execute_edit_order_group
      handle_edit_order_group
      self
    end

    def execute_delete_order_group
      handle_delete_order_group
      self
    end

    def execute_get_all_order_groups
      handle_get_all_order_groups
      self
    end

    def success?
      @success || @errors.empty?
    end

    def errors
      @errors.join(", ")
    end

    private

    def handle_create_order_group
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @order_group = OrderGroup.new(order_group_params)
            if @order_group.save
              @success = true
              @errors = []
            else
              raise ActiveRecord::RecordNotSaved, "Order Group failed to create"
              @success = false
              @errors = [ @order_group.errors.full_messages ]
            end
          end
        else
          raise ActiveRecord::RecordNotFound, "User not logged in"
          @success = false
          @errors << "User not logged in"
        end
      rescue ActiveRecord::RecordNotFound => err
        @success = false
        @errors << err.message
      rescue ActiveRecord::RecordNotSaved => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_edit_order_group
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @order_group = OrderGroup.find(params[:order_group_id])
            raise ActiveRecord::RecordNotFound, "Order Group not found" if @order_group.nil?
            if @order_group.update(order_group_params)
              @success = true
              @errors = []
            else
              raise ActiveRecord::RecordNotSaved, "Order Group failed to edit"
              @success = false
              @errors = [ @order_group.errors.full_messages ]
            end
          end
        else
          raise ActiveRecord::RecordNotFound, "User not logged in"
          @success = false
          @errors << "User not logged in"
        end
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotSaved => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_delete_order_group
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @order_group = OrderGroup.find(params[:order_group_id])
            raise ActiveRecord::RecordNotFound, "Order Group not found" if @order_group.nil?
            if @order_group.destroy
              @success = true
              @errors = []
            else
              raise ActiveRecord::RecordNotDestroyed, "Order Group failed to delete"
              @success = false
              @errors = [ @order_group.errors.full_messages ]
            end
          end
        else
          raise ActiveRecord::RecordNotFound, "User not logged in"
          @success = false
          @errors << "User not logged in"
        end
      rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordNotDestroyed => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def handle_get_all_order_groups
      begin
        user = current_user
        if user
          ActsAsTenant.with_tenant(user.tenant) do
            @order_groups = OrderGroup.all
            @success = true
            @errors = []
          end
        else
          raise ActiveRecord::RecordNotFound, "User not logged in"
          @success = false
          @errors << "User not logged in"
        end
      rescue ActiveRecord::RecordNotFound => err
        @success = false
        @errors << err.message
      rescue StandardError => err
        @success = false
        @errors << "An unexpected error occurred: #{err.message}"
      end
    end

    def current_user
      params[:current_user]
    end

    def order_group_params
      ActionController::Parameters.new(params).permit(:tenant_id, :client_id, :venue_id, :start_on, :completed_on, :status,
         delivery_order_attributes: [
          :order_group_id, :source, :vehicle_type, :transport_id, :courier_id,
           line_items_attributes: [
             :quantity, :delivery_order_id, :merchandise_id, :merchandise_category_id, :price, :unit
            ]
           ])
    end
  end
end